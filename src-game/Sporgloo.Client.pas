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
  LGameData: TGameData;
  msg: TClientLoginResponseMessage;
begin
  if not(AMessage is TClientLoginResponseMessage) then
    raise exception.Create('Not the client login response message expected.');

  msg := AMessage as TClientLoginResponseMessage;

  if (tconfig.Current.DeviceID <> msg.DeviceID) then
    raise exception.Create('Wrong DeviceID sent from the server.');

  if msg.SessionID.IsEmpty then
    raise exception.Create('No SessionID returned by the server.');

  LGameData := TGameData.Current;
  LGameData.Session.SessionID := msg.SessionID;
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
  msg: TClientRegisterResponseMessage;
begin
  if not(AMessage is TClientRegisterResponseMessage) then
    raise exception.Create
      ('Not the client register response message expected.');

  msg := AMessage as TClientRegisterResponseMessage;

  if (tconfig.Current.DeviceID <> msg.DeviceID) then
    raise exception.Create('Wrong DeviceID sent from the server.');

  if msg.PlayerID.IsEmpty then
    raise exception.Create('No PlayerID returned by the server.');

  tconfig.Current.PlayerID := msg.PlayerID;
  TGameData.Current.Player.PlayerID := msg.PlayerID;
  TGameData.Current.Session.PlayerID := msg.PlayerID;

  SendClientLogin(AFromGame, msg.DeviceID, msg.PlayerID);
end;

procedure TSporglooClient.onMapCell(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
  const AMessage: TOlfSocketMessage);
var
  msg: TMapCellMessage;
begin
  if not(AMessage is TMapCellMessage) then
    raise exception.Create('Not the map cell message expected.');

  msg := AMessage as TMapCellMessage;

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
  msg: TOtherPlayerMoveMessage;
begin
  if not(AMessage is TOtherPlayerMoveMessage) then
    raise exception.Create('Not the other player move message expected.');

  msg := AMessage as TOtherPlayerMoveMessage;

  if not TGameData.Current.OtherPlayers.TryGetValue(msg.PlayerID, Player) then
  begin
    Player := TSporglooPlayer.Create;
    Player.PlayerID := msg.PlayerID;
    TGameData.Current.OtherPlayers.add(msg.PlayerID, Player);
  end;
  Player.PlayerX := msg.X;
  Player.PlayerY := msg.Y;
  // TODO : refresh the map cell
end;

procedure TSporglooClient.onPlayerMoveResponse(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const AMessage: TOlfSocketMessage);
var
  msg: TPlayerMoveResponseMessage;
begin
  if not(AMessage is TPlayerMoveResponseMessage) then
    raise exception.Create('Not the player move response message expected.');

  msg := AMessage as TPlayerMoveResponseMessage;

  // TODO : register the playerx,playerY coordinates have been send to the server
end;

procedure TSporglooClient.onPlayerPutAStarResponse(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const AMessage: TOlfSocketMessage);
var
  msg: TServerAcceptTheStarAddingMessage;
begin
  if not(AMessage is TServerAcceptTheStarAddingMessage) then
    raise exception.Create('Not the client login message expected.');

  msg := AMessage as TServerAcceptTheStarAddingMessage;

  // TODO : check if X,Y correspond to a "new star" sent
end;

procedure TSporglooClient.SendClientLogin(const AToGame
  : TOlfSocketMessagingServerConnectedClient; const DeviceID, PlayerID: string);
var
  msg: TClientLoginMessage;
begin
  msg := TClientLoginMessage.Create;
  try
    msg.DeviceID := DeviceID;
    msg.PlayerID := PlayerID;
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
  msg: TClientRegisterMessage;
begin
  msg := TClientRegisterMessage.Create;
  try
    msg.DeviceID := DeviceID;
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
  msg: TMapRefreshDemandMessage;
begin
  msg := TMapRefreshDemandMessage.Create;
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
  msg: TPlayerMoveMessage;
begin
  msg := TPlayerMoveMessage.Create;
  try
    msg.SessionID := SessionID;
    msg.PlayerID := PlayerID;
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
  msg: TPlayerAddAStarOnTheMapMessage;
begin
  msg := TPlayerAddAStarOnTheMapMessage.Create;
  try
    msg.SessionID := SessionID;
    msg.PlayerID := PlayerID;
    msg.X := X;
    msg.Y := Y;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

end.
