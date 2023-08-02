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
  TSporglooServer = class(TOlfSocketMessagingServer)
  private
  protected
    SporglooPlayers: TSporglooPlayersList;
    SporglooMap: TSporglooMap;
    SporglooSessions: TSporglooSessionsList;

    procedure onClientRegister(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);
    procedure onClientLogin(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);
    procedure onMapRefresh(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);
    procedure onPlayerMove(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);
    procedure onPlayerPutAStar(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AMessage: TOlfSocketMessage);

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
  SporglooPlayers := TSporglooPlayersList.Create([doownsvalues]);
  SporglooMap := TSporglooMap.Create;
  SporglooSessions := TSporglooSessionsList.Create([doownsvalues]);

  RegisterMessagesReceivedByTheServer(self);

  SubscribeToMessage(1, onClientRegister);
  SubscribeToMessage(3, onClientLogin);
  SubscribeToMessage(5, onMapRefresh);
  SubscribeToMessage(7, onPlayerMove);
  SubscribeToMessage(9, onPlayerPutAStar);
end;

destructor TSporglooServer.Destroy;
begin
  SporglooSessions.Free;
  SporglooMap.Free;
  SporglooPlayers.Free;
  inherited;
end;

procedure TSporglooServer.onClientLogin(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
  const AMessage: TOlfSocketMessage);
var
  LDeviceID, LPlayerID: string;
  player: TSporglooPlayer;
  Session: TSporglooSession;
  msg: TClient_login_message;
begin
  if not(AMessage is TClient_login_message) then
    raise exception.Create('Not the client login message expected.');

  msg := AMessage as TClient_login_message;

  Alpha16ToString(msg.DeviceID, LDeviceID);
  if LDeviceID.IsEmpty then
    raise exception.Create('Login with empty device ID is not allowed.');

  Alpha16ToString(msg.PlayerID, LPlayerID);
  if LPlayerID.IsEmpty then
    raise exception.Create('Login with empty player ID is not allowed.');

  if not SporglooPlayers.TryGetValue(LPlayerID, player) then
    raise exception.Create('Unknow player !');

  if (player.DeviceID <> LDeviceID) then
    raise exception.Create('Can''t log with this player on your device.');

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
  const AMessage: TOlfSocketMessage);
var
  LDeviceID: string;
  player: TSporglooPlayer;
  msg: TClient_register_message;
begin
  if not(AMessage is TClient_register_message) then
    raise exception.Create('Not the client register message expected.');

  msg := AMessage as TClient_register_message;

  Alpha16ToString(msg.DeviceID, LDeviceID);
  if LDeviceID.IsEmpty then
    raise exception.Create('Empty DeviceID to register.');

  player := SporglooPlayers.GetPlayerByDevice(LDeviceID);
  if not assigned(player) then
  begin
    player := TSporglooPlayer.Create;
    player.DeviceID := LDeviceID;
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

procedure TSporglooServer.onMapRefresh(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
  const AMessage: TOlfSocketMessage);
var
  X, Y: TSporglooAPINumber;
  msg: TMap_refresh_demand_message;
begin
  if not(AMessage is TMap_refresh_demand_message) then
    raise exception.Create('Not the map refresh demand message expected.');

  msg := AMessage as TMap_refresh_demand_message;

  if msg.ColNumber < 1 then
    exit;
  if msg.RowNumber < 1 then
    exit;
  for X := msg.X to msg.X + msg.ColNumber - 1 do
    for Y := msg.Y to msg.Y + msg.RowNumber - 1 do
      SendMapCell(AFromGame, X, Y, SporglooMap.GetTileID(X, Y));
end;

procedure TSporglooServer.onPlayerMove(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
  const AMessage: TOlfSocketMessage);
var
  LSessionID, LPlayerID: string;
  Session: TSporglooSession;
  player: TSporglooPlayer;
  msg: TPlayer_move_message;
begin
  if not(AMessage is TPlayer_move_message) then
    raise exception.Create('Not the player move message expected.');

  msg := AMessage as TPlayer_move_message;

  Alpha16ToString(msg.SessionID, LSessionID);
  if LSessionID.IsEmpty then
    raise exception.Create('Session ID needed.');

  Alpha16ToString(msg.PlayerID, LPlayerID);
  if LPlayerID.IsEmpty then
    raise exception.Create('Player ID needed.');

  if not SporglooSessions.TryGetValue(LSessionID, Session) then
    raise exception.Create('Unknow Session !');

  if not SporglooPlayers.TryGetValue(LPlayerID, player) then
    raise exception.Create('Unknow player !');

  if (player.DeviceID <> Session.DeviceID) and
    (player.PlayerID <> Session.PlayerID) then
    raise exception.Create('Wrong player for this session.');

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
  const AMessage: TOlfSocketMessage);
var
  LSessionID, LPlayerID: string;
  Session: TSporglooSession;
  player: TSporglooPlayer;
  msg: TPlayer_add_a_star_on_the_map_message;
begin
  if not(AMessage is TPlayer_add_a_star_on_the_map_message) then
    raise exception.Create('Not the player add a star message expected.');

  msg := AMessage as TPlayer_add_a_star_on_the_map_message;

  Alpha16ToString(msg.SessionID, LSessionID);
  if LSessionID.IsEmpty then
    raise exception.Create('Session ID needed.');

  Alpha16ToString(msg.PlayerID, LPlayerID);
  if LPlayerID.IsEmpty then
    raise exception.Create('Player ID needed.');

  if not SporglooSessions.TryGetValue(LSessionID, Session) then
    raise exception.Create('Unknow Session !');

  if not SporglooPlayers.TryGetValue(LPlayerID, player) then
    raise exception.Create('Unknow player !');

  if (player.DeviceID <> Session.DeviceID) and
    (player.PlayerID <> Session.PlayerID) then
    raise exception.Create('Wrong player for this session.');

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
  msg: TClient_login_response_message;
  LDeviceID, LSessionID: TSporglooAPIAlpha16;
begin
  msg := TClient_login_response_message.Create;
  try
    StringToAlpha16(DeviceID, LDeviceID);
    msg.DeviceID := LDeviceID;
    StringToAlpha16(SessionID, LSessionID);
    msg.SessionID := LSessionID;
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
  msg: TClient_register_response_message;
  LDeviceID, LPlayerID: TSporglooAPIAlpha16;
begin
  msg := TClient_register_response_message.Create;
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

procedure TSporglooServer.SendMapCell(Const AToGame
  : TOlfSocketMessagingServerConnectedClient; const X, Y: TSporglooAPINumber;
  const TileID: TSporglooAPIShort);
var
  msg: TMap_cell_message;
begin
  if (TileID = CSporglooTileNone) then
    exit;

{$IFDEF DEBUG}
  writeln('=> ', X, ',', Y, '=', TileID);
{$ENDIF}
  msg := TMap_cell_message.Create;
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
  msg: TOther_player_move_message;
  LPlayerID: TSporglooAPIAlpha16;
begin
  msg := TOther_player_move_message.Create;
  try
    StringToAlpha16(PlayerID, LPlayerID);
    msg.PlayerID := LPlayerID;
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
  msg: TPlayer_move_response;
begin
  msg := TPlayer_move_response.Create;
  try
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendPlayerPutAStarResponse(Const AToGame
  : TOlfSocketMessagingServerConnectedClient; const X, Y: TSporglooAPINumber);
var
  msg: TServer_accept_the_star_adding_message;
begin
  msg := TServer_accept_the_star_adding_message.Create;
  try
    msg.X := X;
    msg.Y := Y;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

end.
