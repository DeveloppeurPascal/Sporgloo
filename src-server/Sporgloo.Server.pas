unit Sporgloo.Server;

interface

uses
  Olf.Net.Socket.Messaging,
  Sporgloo.Types,
  Sporgloo.Database,
  Sporgloo.API.Messages,
  Sporgloo.Consts,
  System.Generics.Collections;

type
  TSporglooServer = class(TSporglooSocketMessagesServer)
  private
  protected
    SporglooPlayers: TSporglooPlayersList;
    SporglooMap: TSporglooMap;
    SporglooSessions: TSporglooSessionsList;

    procedure onClientRegister(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TClientRegisterMessage);
    procedure onClientLogin(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TClientLoginMessage);
    procedure onMapRefresh(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TMapRefreshDemandMessage);
    procedure onPlayerMove(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TPlayerMoveMessage);
    procedure onPlayerPutAStar(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TPlayerAddAStarOnTheMapMessage);

    procedure onErrorMessage(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient; Const msg: TErrorMessage);

    procedure SendClientRegisterResponse(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const DeviceID, PlayerID: string);
    procedure SendClientLoginResponse(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const DeviceID, SessionID: string; const X, Y, Score, Stars,
      Life: TSporglooAPINumber);
    procedure SendMapCell(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const X, Y: TSporglooAPINumber; Const TileID: TSporglooAPIShort);
    procedure SendPlayerMoveResponse(Const AToGame
      : TOlfSocketMessagingServerConnectedClient);
    procedure SendPlayerPutAStarResponse(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const X, Y: TSporglooAPINumber);
    procedure SendOtherPlayerMove(Const AToGame
      : TOlfSocketMessagingServerConnectedClient; Const PlayerID: string;
      Const X, Y: TSporglooAPINumber);

    procedure SendErrorMessage(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      const AErrorCode: TSporglooErrorCode; const AErrorText: string;
      const ARaiseException: boolean = true);
  public
    constructor Create(AIP: string; APort: Word); override;
    destructor Destroy; override;
  end;

implementation

uses
  System.Classes,
  System.SysUtils;

{ TSporglooServer }

constructor TSporglooServer.Create(AIP: string; APort: Word);
begin
  inherited;
  onReceiveClientRegisterMessage := onClientRegister;
  onReceiveClientLoginMessage := onClientLogin;
  onReceiveMapRefreshDemandMessage := onMapRefresh;
  onReceivePlayerMoveMessage := onPlayerMove;
  onReceivePlayerAddAStarOnTheMapMessage := onPlayerPutAStar;
  onReceiveErrorMessage := onErrorMessage;

  SporglooPlayers := TSporglooPlayersList.Create([doownsvalues]);
  SporglooMap := TSporglooMap.Create;
  SporglooSessions := TSporglooSessionsList.Create([doownsvalues]);
end;

destructor TSporglooServer.Destroy;
begin
  SporglooSessions.Free;
  SporglooMap.Free;
  SporglooPlayers.Free;
  inherited;
end;

procedure TSporglooServer.onClientLogin(const AFromGame
  : TOlfSocketMessagingServerConnectedClient; const msg: TClientLoginMessage);
var
  player: TSporglooPlayer;
  Session: TSporglooSession;
begin
{$IFDEF DEBUG}
  writeln('onClientLogin');
{$ENDIF}
  if msg.DeviceID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongDeviceID,
      'Login with empty device ID is not allowed.');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongPlayerID,
      'Login with empty player ID is not allowed.');

  if msg.VersionAPI <> CAPIVersion then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongAPIVersion,
      'Wrong API.');

  if not SporglooPlayers.TryGetValue(msg.PlayerID, player) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowPlayerID,
      'Unknow player !');

  if (player.DeviceID <> msg.DeviceID) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongDeviceForPlayerID,
      'Can''t log with this player on your device.');

  Session := TSporglooSession.Create;
  Session.SessionID := GetUniqID;
  Session.DeviceID := player.DeviceID;
  Session.PlayerID := player.PlayerID;
  Session.MapRangeX := 0;
  Session.MapRangey := 0;
  Session.MapRangeColNumber := 0;
  Session.MapRangeRowNumber := 0;
  Session.SocketClient := AFromGame;
  // TODO : add a link to the player instance in the session

  SporglooSessions.Add(Session.SessionID, Session);

  SendClientLoginResponse(AFromGame, Session.DeviceID, Session.SessionID,
    player.PlayerX, player.PlayerY, player.Score, player.StarsCount,
    player.LifeLevel);
end;

procedure TSporglooServer.onClientRegister(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
  const msg: TClientRegisterMessage);
var
  player: TSporglooPlayer;
begin
{$IFDEF DEBUG}
  writeln('onClientRegister');
{$ENDIF}
  if msg.DeviceID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongDeviceID,
      'Empty DeviceID to register.');

  if msg.VersionAPI <> CAPIVersion then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongAPIVersion,
      'Wrong API.');

  player := SporglooPlayers.GetPlayerByDevice(msg.DeviceID);
  if not assigned(player) then
  begin
    player := TSporglooPlayer.Create;
    player.DeviceID := msg.DeviceID;
    player.PlayerID := GetUniqID;
    player.PlayerX := 0;
    player.PlayerY := 0;
    // TODO : change the coordinates if an other player is here too
    player.Score := 0;
    player.StarsCount := 12; // TODO : use a constant for stars count start
    player.LifeLevel := 24; // TODO : use a const for life level start
    SporglooPlayers.Add(player.PlayerID, player);
    SporglooMap.SetTileID(player.PlayerX, player.PlayerY, CSporglooTilePath);
    // TODO : send to all clients this new TileID
  end;

  SendClientRegisterResponse(AFromGame, player.DeviceID, player.PlayerID);
end;

procedure TSporglooServer.onErrorMessage(const AFromGame
  : TOlfSocketMessagingServerConnectedClient; const msg: TErrorMessage);
begin
{$IFDEF DEBUG}
  writeln('onErrorMessage n°' + msg.ErrorCode.tostring +
    ' received from a client.');
{$ENDIF}
  // TODO : manage the received error
end;

procedure TSporglooServer.onMapRefresh(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
  const msg: TMapRefreshDemandMessage);
var
  X, Y: TSporglooAPINumber;
begin
{$IFDEF DEBUG}
  writeln('onMapRefresh');
{$ENDIF}
  if msg.ColNumber < 1 then
    exit;
  if msg.RowNumber < 1 then
    exit;
  for X := msg.X to msg.X + msg.ColNumber - 1 do
    for Y := msg.Y to msg.Y + msg.RowNumber - 1 do
      SendMapCell(AFromGame, X, Y, SporglooMap.GetTileID(X, Y));
end;

procedure TSporglooServer.onPlayerMove(const AFromGame
  : TOlfSocketMessagingServerConnectedClient; const msg: TPlayerMoveMessage);
var
  Session: TSporglooSession;
  player: TSporglooPlayer;
begin
{$IFDEF DEBUG}
  writeln('onPlayerMove');
{$ENDIF}
  if msg.SessionID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongSessionID,
      'Session ID needed.');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongPlayerID,
      'Player ID needed.');

  if not SporglooSessions.TryGetValue(msg.SessionID, Session) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowSessionID,
      'Unknow Session !');

  if not SporglooPlayers.TryGetValue(msg.PlayerID, player) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowPlayerID,
      'Unknow player !');

  if (player.DeviceID <> Session.DeviceID) and
    (player.PlayerID <> Session.PlayerID) then
    SendErrorMessage(AFromGame,
      TSporglooErrorCode.WrongDeviceOrPlayerForSessionID,
      'Wrong player for this session.');

  // TODO : check if the movement the position is free on the map
  player.PlayerX := msg.X;
  player.PlayerY := msg.Y;

  // TODO : check the TileID, change score if needed, change lifelevel, change map tile

  SendPlayerMoveResponse(AFromGame);

  // TODO : to optimize this feature, store the new coordinates in a list and have a separate check for it
  for Session in SporglooSessions.Values do
    if assigned(Session.SocketClient) and (Session.SocketClient <> AFromGame)
    then
      try
        SendOtherPlayerMove(Session.SocketClient, player.PlayerID,
          player.PlayerX, player.PlayerY);
      except
        // TODO : erreur avec une session, la virer ou traiter en fonction de l'erreur
      end;
end;

procedure TSporglooServer.onPlayerPutAStar(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
  const msg: TPlayerAddAStarOnTheMapMessage);
var
  Session: TSporglooSession;
  player: TSporglooPlayer;
begin
{$IFDEF DEBUG}
  writeln('onPlayerPutAStar');
{$ENDIF}
  if msg.SessionID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongSessionID,
      'Session ID needed.');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongPlayerID,
      'Player ID needed.');

  if not SporglooSessions.TryGetValue(msg.SessionID, Session) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowSessionID,
      'Unknow Session !');

  if not SporglooPlayers.TryGetValue(msg.PlayerID, player) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowPlayerID,
      'Unknow player !');

  if (player.DeviceID <> Session.DeviceID) and
    (player.PlayerID <> Session.PlayerID) then
    SendErrorMessage(AFromGame,
      TSporglooErrorCode.WrongDeviceOrPlayerForSessionID,
      'Wrong player for this session.');

  if (player.StarsCount > 0) then
  begin
    SporglooMap.SetTileID(msg.X, msg.Y, CSporglooTileStar);
    player.StarsCount := player.StarsCount - 1;
  end;
  SendPlayerPutAStarResponse(AFromGame, msg.X, msg.Y);

  // TODO : to optimize this feature, store the changes in a list and have a separate check for it
  for Session in SporglooSessions.Values do
    if assigned(Session.SocketClient) and (Session.SocketClient <> AFromGame)
    then
      try
        SendMapCell(Session.SocketClient, msg.X, msg.Y, CSporglooTileStar);
      except
        // TODO : erreur avec une session, la virer ou traiter en fonction de l'erreur
      end;
end;

procedure TSporglooServer.SendClientLoginResponse(Const AToGame
  : TOlfSocketMessagingServerConnectedClient; const DeviceID, SessionID: string;
  const X, Y, Score, Stars, Life: TSporglooAPINumber);
var
  msg: TClientLoginResponseMessage;
begin
  msg := TClientLoginResponseMessage.Create;
  try
    msg.DeviceID := DeviceID;
    msg.SessionID := SessionID;
    msg.X := X;
    msg.Y := Y;
    msg.Score := Score;
    msg.Stars := Stars;
    msg.Life := Life;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendClientRegisterResponse(Const AToGame
  : TOlfSocketMessagingServerConnectedClient; const DeviceID, PlayerID: string);
var
  msg: TClientRegisterResponseMessage;
begin
  msg := TClientRegisterResponseMessage.Create;
  try
    msg.DeviceID := DeviceID;
    msg.PlayerID := PlayerID;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendErrorMessage(const AToGame
  : TOlfSocketMessagingServerConnectedClient;
  const AErrorCode: TSporglooErrorCode; const AErrorText: string;
  const ARaiseException: boolean);
var
  msg: TErrorMessage;
begin
  // TODO : add a server log or an error reporting (in case of attack or other problem)

  msg := TErrorMessage.Create;
  try
    msg.ErrorCode := ord(AErrorCode);
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;

  if ARaiseException then
    raise TSporglooException.Create(AErrorCode, AErrorText);
end;

procedure TSporglooServer.SendMapCell(Const AToGame
  : TOlfSocketMessagingServerConnectedClient; const X, Y: TSporglooAPINumber;
  const TileID: TSporglooAPIShort);
var
  msg: TMapCellMessage;
begin
  if (TileID = CSporglooTileNone) then
    exit;

{$IFDEF DEBUG}
  writeln('=> ', X, ',', Y, '=', TileID);
{$ENDIF}
  msg := TMapCellMessage.Create;
  try
    msg.X := X;
    msg.Y := Y;
    msg.TileID := TileID;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendOtherPlayerMove(Const AToGame
  : TOlfSocketMessagingServerConnectedClient; const PlayerID: string;
  const X, Y: TSporglooAPINumber);
var
  msg: TOtherPlayerMoveMessage;
begin
  msg := TOtherPlayerMoveMessage.Create;
  try
    msg.PlayerID := PlayerID;
    msg.X := X;
    msg.Y := Y;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendPlayerMoveResponse(Const AToGame
  : TOlfSocketMessagingServerConnectedClient);
var
  msg: TPlayerMoveResponseMessage;
begin
  msg := TPlayerMoveResponseMessage.Create;
  try
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendPlayerPutAStarResponse(Const AToGame
  : TOlfSocketMessagingServerConnectedClient; const X, Y: TSporglooAPINumber);
var
  msg: TServerAcceptTheStarAddingMessage;
begin
  msg := TServerAcceptTheStarAddingMessage.Create;
  try
    msg.X := X;
    msg.Y := Y;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

end.
