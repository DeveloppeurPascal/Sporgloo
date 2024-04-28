unit Sporgloo.Client;

interface

uses
  Olf.Net.Socket.Messaging,
  Sporgloo.API.Messages,
  Sporgloo.Types,
  Sporgloo.Consts;

type
  TSporglooClient = class(TSporglooSocketMessagesClient)
  private
  protected
    procedure onClientRegisterResponse(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TClientRegisterResponseMessage);
    procedure onClientLoginResponse(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TClientLoginResponseMessage);
    procedure onMapCell(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient; Const msg: TMapCellMessage);
    procedure onPlayerMoveResponse(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TPlayerMoveResponseMessage);
    procedure onPlayerPutAStarResponse(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TServerAcceptTheStarAddingMessage);
    procedure onOtherPlayerMove(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TOtherPlayerMoveMessage);
    procedure onLogoff(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient; Const msg: TLogoffMessage);

    procedure onErrorMessage(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient; Const msg: TErrorMessage);
  public
    constructor Create(AServerIP: string; AServerPort: word); override;

    procedure SendClientRegister(Const DeviceID: string);
    procedure SendClientLogin(Const DeviceID, PlayerID: string);
    procedure SendMapRefresh(Const X, Y, ColNumber,
      RowNumber: TSporglooAPINumber);
    procedure SendPlayerMove(Const SessionID, PlayerID: string;
      Const X, Y: TSporglooAPINumber);
    procedure SendPlayerPutAStar(Const SessionID, PlayerID: string;
      Const X, Y: TSporglooAPINumber);

    procedure SendErrorMessage(const AErrorCode: TSporglooErrorCode;
      const AErrorText: string; const ARaiseException: boolean = true);
  end;

implementation

Uses
  System.Classes,
  System.SysUtils,
  System.Messaging,
  uGameData,
  uConfig,
  Sporgloo.Messaging,
  Sporgloo.Database;

{ TSporglooClient }

constructor TSporglooClient.Create(AServerIP: string; AServerPort: word);
begin
  inherited;
  onReceiveClientRegisterResponseMessage := onClientRegisterResponse;
  onReceiveClientLoginResponseMessage := onClientLoginResponse;
  onReceiveMapCellMessage := onMapCell;
  onReceivePlayerMoveResponseMessage := onPlayerMoveResponse;
  onReceiveServerAcceptTheStarAddingMessage := onPlayerPutAStarResponse;
  onReceiveOtherPlayerMoveMessage := onOtherPlayerMove;
  OnReceiveErrorMessage := onErrorMessage;
  onReceiveLogoffMessage := onLogoff;
end;

procedure TSporglooClient.onClientLoginResponse(const AFromServer
  : TOlfSocketMessagingServerConnectedClient;
  const msg: TClientLoginResponseMessage);
var
  LGameData: TGameData;
begin
  if (tconfig.Current.DeviceID <> msg.DeviceID) then
    SendErrorMessage(TSporglooErrorCode.WrongDeviceID,
      'Wrong DeviceID sent from the server.');

  if msg.SessionID.IsEmpty then
    SendErrorMessage(TSporglooErrorCode.WrongSessionID,
      'No SessionID returned by the server.');

  LGameData := TGameData.Current;
  LGameData.Session.SessionID := msg.SessionID;
  LGameData.Player.PlayerX := msg.X;
  LGameData.Player.PlayerY := msg.Y;
  LGameData.Player.Score := msg.Score;
  LGameData.Player.StarsCount := msg.Stars;
  LGameData.Player.LifeLevel := msg.Life;

  LGameData.RefreshMap;
end;

procedure TSporglooClient.onClientRegisterResponse(const AFromServer
  : TOlfSocketMessagingServerConnectedClient;
  const msg: TClientRegisterResponseMessage);
begin
  if (tconfig.Current.DeviceID <> msg.DeviceID) then
    SendErrorMessage(TSporglooErrorCode.WrongDeviceID,
      'Wrong DeviceID sent from the server.');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(TSporglooErrorCode.WrongPlayerID,
      'No PlayerID returned by the server.');

  tconfig.Current.PlayerID := msg.PlayerID;
  TGameData.Current.Player.PlayerID := msg.PlayerID;
  TGameData.Current.Session.Player := TGameData.Current.Player;

  SendClientLogin(msg.DeviceID, msg.PlayerID);
end;

procedure TSporglooClient.onErrorMessage(const AFromServer
  : TOlfSocketMessagingServerConnectedClient; const msg: TErrorMessage);
begin
  // TODO : manage the received error
end;

procedure TSporglooClient.onLogoff(const AFromServer
  : TOlfSocketMessagingServerConnectedClient; const msg: TLogoffMessage);
begin
  TThread.ForceQueue(nil,
    procedure
    begin
      TMessageManager.DefaultManager.SendMessage(self,
        TDisconnectMessage.Create);
    end);
end;

procedure TSporglooClient.onMapCell(const AFromServer
  : TOlfSocketMessagingServerConnectedClient; const msg: TMapCellMessage);
var
  X, Y: TSporglooAPINumber;
  TileID: byte;
begin
  X := msg.X;
  Y := msg.Y;
  TileID := msg.TileID;
  TThread.queue(nil,
    procedure
    begin
      TGameData.Current.Map.SetTileID(X, Y, TileID);
      TMessageManager.DefaultManager.SendMessage(self,
        TMapCellUpdateMessage.Create(TSporglooMapCell.Create(X, Y, TileID)));
    end);
end;

procedure TSporglooClient.onOtherPlayerMove(const AFromServer
  : TOlfSocketMessagingServerConnectedClient;
const msg: TOtherPlayerMoveMessage);
var
  X, Y: TSporglooAPINumber;
  PlayerID: string;
begin
  X := msg.X;
  Y := msg.Y;
  PlayerID := msg.PlayerID;
  TThread.queue(nil,
    procedure
    var
      Player: TSporglooPlayer;
    begin
      Player := TGameData.Current.OtherPlayers.GetPlayer(PlayerID);
      if not assigned(Player) then
      begin
        Player := TSporglooPlayer.Create;
        Player.PlayerID := PlayerID;
        TGameData.Current.OtherPlayers.add(PlayerID, Player);
      end;

      // TODO : redessiner la tuile où se trouvait le joueur avant son déplacement (si on le connaissait)

      Player.PlayerX := X;
      Player.PlayerY := Y;

      TMessageManager.DefaultManager.SendMessage(self,
        TOtherPlayerUpdateMessage.Create(Player));
    end);
end;

procedure TSporglooClient.onPlayerMoveResponse(const AFromServer
  : TOlfSocketMessagingServerConnectedClient;
const msg: TPlayerMoveResponseMessage);
begin
  // TODO : register the playerx,playerY coordinates have been send to the server
end;

procedure TSporglooClient.onPlayerPutAStarResponse(const AFromServer
  : TOlfSocketMessagingServerConnectedClient;
const msg: TServerAcceptTheStarAddingMessage);
begin
  // TODO : check if X,Y correspond to a "new star" sent
end;

procedure TSporglooClient.SendClientLogin(const DeviceID, PlayerID: string);
var
  msg: TClientLoginMessage;
begin
  msg := TClientLoginMessage.Create;
  try
    msg.DeviceID := DeviceID;
    msg.PlayerID := PlayerID;
    msg.VersionAPI := CAPIVersion;
    SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendClientRegister(const DeviceID: string);
var
  msg: TClientRegisterMessage;
begin
  msg := TClientRegisterMessage.Create;
  try
    msg.DeviceID := DeviceID;
    msg.VersionAPI := CAPIVersion;
    SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendErrorMessage(const AErrorCode: TSporglooErrorCode;
const AErrorText: string; const ARaiseException: boolean);
var
  msg: TErrorMessage;
begin
  // TODO : add a client log or an error reporting (in case of attack or other problem)

  msg := TErrorMessage.Create;
  try
    msg.ErrorCode := ord(AErrorCode);
    SendMessage(msg);
  finally
    msg.Free;
  end;

  if ARaiseException then
    raise TSporglooException.Create(AErrorCode, AErrorText);
end;

procedure TSporglooClient.SendMapRefresh(const X, Y, ColNumber,
  RowNumber: TSporglooAPINumber);
var
  msg: TMapRefreshDemandMessage;
begin
  msg := TMapRefreshDemandMessage.Create;
  try
    msg.X := X;
    msg.Y := Y;
    msg.ColNumber := ColNumber;
    msg.RowNumber := RowNumber;
    SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendPlayerMove(const SessionID, PlayerID: string;
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
    SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendPlayerPutAStar(const SessionID, PlayerID: string;
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
    SendMessage(msg);
  finally
    msg.Free;
  end;
end;

end.
