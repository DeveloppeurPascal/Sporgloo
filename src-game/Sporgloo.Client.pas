unit Sporgloo.Client;

interface

uses
  Olf.Net.Socket.Messaging,
  Sporgloo.API.Messages,
  Sporgloo.Types;

type
  TSporglooClient = class(TOlfSMClient)
  private
  protected
    procedure onClientRegisterResponse(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);
    procedure onClientLoginResponse(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);
    procedure onMapCell(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);
    procedure onPlayerMoveResponse(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);
    procedure onPlayerPutAStarResponse(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);
    procedure onOtherPlayerMove(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);
  public
    constructor Create(AServerIP: string; AServerPort: word); override;
    destructor Destroy; override;

    procedure SendClientRegister(Const DeviceID: string); overload;
    procedure SendClientRegister(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const DeviceID: string); overload;
    procedure SendClientLogin(Const DeviceID, PlayerID: string); overload;
    procedure SendClientLogin(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const DeviceID, PlayerID: string); overload;
    procedure SendMapRefresh(Const X, Y, ColNumber,
      RowNumber: TSporglooAPINumber); overload;
    procedure SendMapRefresh(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const X, Y, ColNumber, RowNumber: TSporglooAPINumber); overload;
    procedure SendPlayerMove(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const SessionID, PlayerID: string; Const X, Y: TSporglooAPINumber);
    procedure SendPlayerPutAStar(Const SessionID, PlayerID: string;
      Const X, Y: TSporglooAPINumber); overload;
    procedure SendPlayerPutAStar(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const SessionID, PlayerID: string;
      Const X, Y: TSporglooAPINumber); overload;
  end;

implementation

Uses
  System.Classes,
  System.SysUtils,
  System.Messaging,
  System.Net.Socket,
  uGameData,
  uConfig,
  Sporgloo.Messaging, Sporgloo.Database;

{ TSporglooClient }

constructor TSporglooClient.Create(AServerIP: string; AServerPort: word);
begin
  inherited;

  RegisterMessagesReceivedByTheClient(self);

  SubscribeToMessage(2, onClientRegisterResponse);
  SubscribeToMessage(4, onClientLoginResponse);
  SubscribeToMessage(6, onMapCell);
  SubscribeToMessage(8, onPlayerMoveResponse);
  SubscribeToMessage(10, onPlayerPutAStarResponse);
  SubscribeToMessage(11, onOtherPlayerMove);
end;

destructor TSporglooClient.Destroy;
begin

  inherited;
end;

procedure TSporglooClient.onClientLoginResponse(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
  const AMessage: TOlfSocketMessage);
var
  LDeviceID, LSessionID: string;
  LGameData: TGameData;
  msg: TClient_login_response_message;
begin
  if not(AMessage is TClient_login_response_message) then
    raise exception.Create('Not the client login response message expected.');

  msg := AMessage as TClient_login_response_message;

  Alpha16ToString(msg.DeviceID, LDeviceID);
  if (tconfig.Current.DeviceID <> LDeviceID) then
    raise exception.Create('Wrong DeviceID sent from the server.');

  Alpha16ToString(msg.SessionID, LSessionID);
  if LSessionID.IsEmpty then
    raise exception.Create('No SessionID returned by the server.');

  LGameData := TGameData.Current;
  LGameData.Session.SessionID := LSessionID;
  LGameData.Player.PlayerX := msg.X;
  LGameData.Player.PlayerY := msg.Y;
  LGameData.Player.Score := msg.Score;
  LGameData.Player.StarsCount := msg.Stars;
  LGameData.Player.LifeLevel := msg.Life;

  LGameData.RefreshMap;
end;

procedure TSporglooClient.onClientRegisterResponse(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
  const AMessage: TOlfSocketMessage);
var
  LDeviceID, LPlayerID: string;
  msg: TClient_register_response_message;
begin
  if not(AMessage is TClient_register_response_message) then
    raise exception.Create
      ('Not the client register response message expected.');

  msg := AMessage as TClient_register_response_message;

  Alpha16ToString(msg.DeviceID, LDeviceID);
  if (tconfig.Current.DeviceID <> LDeviceID) then
    raise exception.Create('Wrong DeviceID sent from the server.');

  Alpha16ToString(msg.PlayerID, LPlayerID);
  if LPlayerID.IsEmpty then
    raise exception.Create('No PlayerID returned by the server.');

  tconfig.Current.PlayerID := LPlayerID;
  TGameData.Current.Player.PlayerID := LPlayerID;
  TGameData.Current.Session.PlayerID := LPlayerID;

  SendClientLogin(AFromGame, LDeviceID, LPlayerID);
end;

procedure TSporglooClient.onMapCell(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
  const AMessage: TOlfSocketMessage);
var
  msg: TMap_cell_message;
begin
  if not(AMessage is TMap_cell_message) then
    raise exception.Create('Not the map cell message expected.');

  msg := AMessage as TMap_cell_message;

  TGameData.Current.Map.SetTileID(msg.X, msg.Y, msg.TileID);
  TThread.synchronize(nil,
    procedure
    begin
      TMessageManager.DefaultManager.SendMessage(self,
        TMapCellUpdateMessage.Create(TSporglooMapCell.Create(msg.X, msg.Y,
        msg.TileID)));
    end);
end;

procedure TSporglooClient.onOtherPlayerMove(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const AMessage: TOlfSocketMessage);
var
  Player: TSporglooPlayer;
  LPlayerID: string;
  msg: TOther_player_move_message;
begin
  if not(AMessage is TOther_player_move_message) then
    raise exception.Create('Not the other player move message expected.');

  msg := AMessage as TOther_player_move_message;

  Alpha16ToString(msg.PlayerID, LPlayerID);
  if not TGameData.Current.OtherPlayers.TryGetValue(LPlayerID, Player) then
  begin
    Player := TSporglooPlayer.Create;
    Player.PlayerID := LPlayerID;
    TGameData.Current.OtherPlayers.add(LPlayerID, Player);
  end;
  Player.PlayerX := msg.X;
  Player.PlayerY := msg.Y;
  // TODO : refresh the map cell
end;

procedure TSporglooClient.onPlayerMoveResponse(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const AMessage: TOlfSocketMessage);
var
  msg: TPlayer_move_response;
begin
  if not(AMessage is TPlayer_move_response) then
    raise exception.Create('Not the player move response message expected.');

  msg := AMessage as TPlayer_move_response;

  // TODO : register the playerx,playerY coordinates have been send to the server
end;

procedure TSporglooClient.onPlayerPutAStarResponse(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const AMessage: TOlfSocketMessage);
var
  msg: TServer_accept_the_star_adding_message;
begin
  if not(AMessage is TServer_accept_the_star_adding_message) then
    raise exception.Create('Not the client login message expected.');

  msg := AMessage as TServer_accept_the_star_adding_message;

  // TODO : check if X,Y correspond to a "new star" sent
end;

procedure TSporglooClient.SendClientLogin(const AToGame
  : TOlfSocketMessagingServerConnectedClient; const DeviceID, PlayerID: string);
var
  LDeviceID, LPlayerID: TSporglooAPIAlpha16;
  msg: TClient_login_message;
begin
  msg := TClient_login_message.Create;
  try
    StringToAlpha16(DeviceID, LDeviceID);
    msg.DeviceID := LDeviceID;
    StringToAlpha16(PlayerID, LPlayerID);
    msg.PlayerID := LPlayerID;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendClientLogin(const DeviceID, PlayerID: string);
begin
  SendClientLogin(self, DeviceID, PlayerID);
end;

procedure TSporglooClient.SendClientRegister(const DeviceID: string);
begin
  SendClientRegister(self, DeviceID);
end;

procedure TSporglooClient.SendClientRegister(const AToGame
  : TOlfSocketMessagingServerConnectedClient; const DeviceID: string);
var
  LDeviceID: TSporglooAPIAlpha16;
  msg: TClient_register_message;
begin
  msg := TClient_register_message.Create;
  try
    StringToAlpha16(DeviceID, LDeviceID);
    msg.DeviceID := LDeviceID;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendMapRefresh(const X, Y, ColNumber,
  RowNumber: TSporglooAPINumber);
begin
  SendMapRefresh(self, X, Y, ColNumber, RowNumber);
end;

procedure TSporglooClient.SendMapRefresh(const AToGame
  : TOlfSocketMessagingServerConnectedClient;
const X, Y, ColNumber, RowNumber: TSporglooAPINumber);
var
  msg: TMap_refresh_demand_message;
begin
  msg := TMap_refresh_demand_message.Create;
  try
    msg.X := X;
    msg.Y := Y;
    msg.ColNumber := ColNumber;
    msg.RowNumber := RowNumber;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendPlayerMove(const AToGame
  : TOlfSocketMessagingServerConnectedClient; const SessionID, PlayerID: string;
const X, Y: TSporglooAPINumber);
var
  LSessionID, LPlayerID: TSporglooAPIAlpha16;
  msg: TPlayer_move_message;
begin
  msg := TPlayer_move_message.Create;
  try
    StringToAlpha16(SessionID, LSessionID);
    msg.SessionID := LSessionID;
    StringToAlpha16(PlayerID, LPlayerID);
    msg.PlayerID := LPlayerID;
    msg.X := X;
    msg.Y := Y;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendPlayerPutAStar(const SessionID, PlayerID: string;
const X, Y: TSporglooAPINumber);
begin
  SendPlayerPutAStar(self, SessionID, PlayerID, X, Y);
end;

procedure TSporglooClient.SendPlayerPutAStar(const AToGame
  : TOlfSocketMessagingServerConnectedClient; const SessionID, PlayerID: string;
const X, Y: TSporglooAPINumber);
var
  LSessionID, LPlayerID: TSporglooAPIAlpha16;
  msg: TPlayer_add_a_star_on_the_map_message;
begin
  msg := TPlayer_add_a_star_on_the_map_message.Create;
  try
    StringToAlpha16(SessionID, LSessionID);
    msg.SessionID := LSessionID;
    StringToAlpha16(PlayerID, LPlayerID);
    msg.PlayerID := LPlayerID;
    msg.X := X;
    msg.Y := Y;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

end.
