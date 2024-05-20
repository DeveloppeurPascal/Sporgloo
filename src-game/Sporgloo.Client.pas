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
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TMapCellInfoMessage);
    procedure onLogoff(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient; Const msg: TLogoffMessage);
    procedure onCoinsCountChange(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TCoinsCountChangeMessage);
    procedure onCurrentPlayerKilled(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TCurrentPlayerKilledMessage);
    procedure onHallOfFame(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: THallOfFameMessage);
    procedure onLivesCountChange(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TLivesCountChangeMessage);
    procedure onPlayerInfos(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TPlayerInfosMessage);
    procedure onStarsCountChange(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TStarsCountChangeMessage);

    procedure onErrorMessage(Const AFromServer
      : TOlfSocketMessagingServerConnectedClient; Const msg: TErrorMessage);
  public
    constructor Create(AServerIP: string; AServerPort: word); override;

    procedure SendClientRegister(Const DeviceID: string);
    procedure SendClientLogin(Const DeviceID, PlayerID: string);
    procedure SendMapRefresh(Const X, Y, ColNumber,
      RowNumber: TSporglooAPINumber; Const SessionID: string);
    procedure SendPlayerMove(Const SessionID, PlayerID: string;
      Const X, Y: TSporglooAPINumber);
    procedure SendPlayerPutAStar(Const SessionID, PlayerID: string;
      Const X, Y: TSporglooAPINumber);

    procedure SendAskForPlayerInfos(Const SessionID, PlayerID: string);
    procedure SendGetHallOfFameScores(Const SessionID: string;
      Const PageNumber: integer);
    procedure SendKillCurrentPlayer(Const SessionID, PlayerID: string);
    procedure SendPlayerImageChanged(Const SessionID: string;
      Const ImageID: integer);

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
  Sporgloo.Database,
  Sporgloo.Utils;

{ TSporglooClient }

constructor TSporglooClient.Create(AServerIP: string; AServerPort: word);
begin
  inherited;
  onReceiveClientLoginResponseMessage := onClientLoginResponse;
  onReceiveClientRegisterResponseMessage := onClientRegisterResponse;
  onReceiveCoinsCountChangeMessage := onCoinsCountChange;
  onReceiveCurrentPlayerKilledMessage := onCurrentPlayerKilled;
  onReceiveErrorMessage := onErrorMessage;
  onReceiveHallOfFameMessage := onHallOfFame;
  onReceiveLivesCountChangeMessage := onLivesCountChange;
  onReceiveLogoffMessage := onLogoff;
  onReceiveMapCellInfoMessage := onMapCell;
  onReceivePlayerInfosMessage := onPlayerInfos;
  onReceiveStarsCountChangeMessage := onStarsCountChange;
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
  SendAskForPlayerInfos(msg.SessionID, msg.PlayerID);
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

  tconfig.Current.DeviceAuthKey := msg.DeviceAuthKey;

  SendClientLogin(msg.DeviceID, msg.PlayerID);
end;

procedure TSporglooClient.onCoinsCountChange(const AFromServer
  : TOlfSocketMessagingServerConnectedClient;
  const msg: TCoinsCountChangeMessage);
begin
  // TODO : à compléter
end;

procedure TSporglooClient.onCurrentPlayerKilled(const AFromServer
  : TOlfSocketMessagingServerConnectedClient;
  const msg: TCurrentPlayerKilledMessage);
begin
  // TODO : à compléter
end;

procedure TSporglooClient.onErrorMessage(const AFromServer
  : TOlfSocketMessagingServerConnectedClient; const msg: TErrorMessage);
begin
  // TODO : manage the received error
  if (msg.ErrorCode = ord(TSporglooErrorCode.PlayerMoveDenied)) then
    TThread.ForceQueue(nil,
      procedure
      begin
        TMessageManager.DefaultManager.SendMessage(self,
          TPlayerMoveDeniedByTheServerMessage.Create);
      end);
end;

procedure TSporglooClient.onHallOfFame(const AFromServer
  : TOlfSocketMessagingServerConnectedClient; const msg: THallOfFameMessage);
begin
  // TODO : à compléter
end;

procedure TSporglooClient.onLivesCountChange(const AFromServer
  : TOlfSocketMessagingServerConnectedClient;
const msg: TLivesCountChangeMessage);
begin
  // TODO : à compléter
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
  : TOlfSocketMessagingServerConnectedClient; const msg: TMapCellInfoMessage);
var
  MapCell: TSporglooMapCell;
begin
  MapCell := TGameData.Current.Map.GetCellAt(msg.X, msg.Y);
  MapCell.TileID := msg.TileID;
  MapCell.PlayerID := msg.PlayerID;

  TThread.queue(nil,
    procedure
    begin
      TMessageManager.DefaultManager.SendMessage(self,
        TMapCellUpdateMessage.Create(MapCell));
    end);
end;

procedure TSporglooClient.onPlayerInfos(const AFromServer
  : TOlfSocketMessagingServerConnectedClient; const msg: TPlayerInfosMessage);
var
  LGameData: TGameData;
  LPlayer: tsporglooplayer;
begin
  LGameData := TGameData.Current;
  if (LGameData.Player.PlayerID = msg.PlayerID) then
    LPlayer := LGameData.Player
  else
    LPlayer := LGameData.OtherPlayers.GetPlayer(msg.PlayerID);

  if assigned(LPlayer) then
  begin
    LPlayer.PlayerX := msg.X;
    LPlayer.PlayerY := msg.Y;
    LPlayer.CoinsCount := msg.CoinsCount;
    LPlayer.StarsCount := msg.StarsCount;
    LPlayer.LivesCount := msg.LivesCount;
    LPlayer.ImageID := msg.ImageID;
  end;

  // TODO : voir si utile ou si le déplacement du jouer suffit à se repositionner

  // if (LPlayer = LGameData.Player) then
  // LGameData.RefreshMap;
end;

procedure TSporglooClient.onStarsCountChange(const AFromServer
  : TOlfSocketMessagingServerConnectedClient;
const msg: TStarsCountChangeMessage);
begin
  // TODO : à compléter
end;

procedure TSporglooClient.SendAskForPlayerInfos(const SessionID,
  PlayerID: string);
var
  msg: TAskForPlayerInfosMessage;
begin
  msg := TAskForPlayerInfosMessage.Create;
  try
    msg.SessionID := SessionID;
    msg.PlayerID := PlayerID;
    SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendClientLogin(const DeviceID, PlayerID: string);
var
  msg: TClientLoginMessage;
begin
  msg := TClientLoginMessage.Create;
  try
    msg.VersionAPI := CAPIVersion;
    msg.DeviceID := DeviceID;
    msg.PlayerID := PlayerID;
    msg.TokenID := GetTokenID(PlayerID, DeviceID,
      tconfig.Current.DeviceAuthKey);
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
    msg.VersionAPI := CAPIVersion;
    msg.DeviceID := DeviceID;
    msg.ServerAuthKey := GetServerAuthKey(DeviceID);
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

procedure TSporglooClient.SendGetHallOfFameScores(const SessionID: string;
const PageNumber: integer);
var
  msg: TGetHallOfFameScoresMessage;
begin
  // TODO : à revoir lorsqu'on saura comment afficher la liste de scores
  msg := TGetHallOfFameScoresMessage.Create;
  try
    msg.SessionID := SessionID;
    msg.PageNumber := 0;
    SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendKillCurrentPlayer(const SessionID,
  PlayerID: string);
var
  msg: TKillCurrentPlayerMessage;
begin
  msg := TKillCurrentPlayerMessage.Create;
  try
    msg.SessionID := SessionID;
    msg.PlayerID := PlayerID;
    SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendMapRefresh(const X, Y, ColNumber,
  RowNumber: TSporglooAPINumber; Const SessionID: string);
var
  msg: TAskForMapRefreshMessage;
begin
  msg := TAskForMapRefreshMessage.Create;
  try
    msg.X := X;
    msg.Y := Y;
    msg.ColNumber := ColNumber;
    msg.RowNumber := RowNumber;
    msg.SessionID := SessionID;
    SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooClient.SendPlayerImageChanged(const SessionID: string;
const ImageID: integer);
var
  msg: TPlayerImageChangedMessage;
begin
  msg := TPlayerImageChangedMessage.Create;
  try
    msg.SessionID := SessionID;
    msg.ImageID := ImageID;
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
