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
    function GetGameDataFileName: string;
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

    procedure LoadGameData;
    procedure SaveGameData;
  public
    constructor Create(AIP: string; APort: Word); override;
    destructor Destroy; override;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.IOutils,
  Olf.RTL.Params;

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

  LoadGameData;

  tthread.createanonymousthread(
    procedure
    begin
      while not tthread.CheckTerminated do
      begin
        // TODO : utiliser plutôt un timer ou de préférence un stockage des changements en base de données, traités par un thread secondaire
        sleep(1000 * 60); // attente 1 minute
        SaveGameData;
{$IFDEF DEBUG}
        writeln('DB saved');
{$ENDIF}
      end;
    end).start;
end;

destructor TSporglooServer.Destroy;
begin
  SaveGameData;

  SporglooSessions.Free;
  SporglooMap.Free;
  SporglooPlayers.Free;
  inherited;
end;

function TSporglooServer.GetGameDataFileName: string;
var
  FilePath: string;
begin
  FilePath := tpath.GetDirectoryName(tparams.getFilePath);
{$IFDEF DEBUG}
  result := tpath.combine(FilePath, 'Sporgloo-debug.dta');
{$ELSE}
  result := tpath.combine(FilePath, 'Sporgloo.dta');
{$ENDIF}
end;

procedure TSporglooServer.LoadGameData;
var
  fs: tfilestream;
  FileName: string;
begin
  FileName := GetGameDataFileName;
  if (not FileName.IsEmpty) and tfile.Exists(FileName) then
  begin
    fs := tfilestream.Create(FileName, fmOpenRead);
    try
      SporglooPlayers.LoadFromStream(fs);
      SporglooMap.LoadFromStream(fs);
    finally
      fs.Free;
    end;
  end;
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
  if msg.VersionAPI <> CAPIVersion then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongAPIVersion,
      'Wrong API.');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongPlayerID,
      'Login with empty player ID is not allowed.');

  if not SporglooPlayers.TryGetValue(msg.PlayerID, player) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowPlayerID,
      'Unknow player !');

  if msg.DeviceID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongDeviceID,
      'Login with empty device ID is not allowed.');

  if (player.DeviceID <> msg.DeviceID) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongDeviceForPlayerID,
      'Can''t log with this player on your device.');

  Session := TSporglooSession.Create;
  Session.SessionID := GetUniqID;
  Session.player := player;
  Session.MapRangeX := 0;
  Session.MapRangey := 0;
  Session.MapRangeColNumber := 0;
  Session.MapRangeRowNumber := 0;
  Session.SocketClient := AFromGame;
  AFromGame.tagobject := Session;

  SporglooSessions.Add(Session.SessionID, Session);

  SendClientLoginResponse(AFromGame, Session.player.DeviceID, Session.SessionID,
    Session.player.PlayerX, Session.player.PlayerY, Session.player.Score,
    Session.player.StarsCount, Session.player.LifeLevel);
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
    player.StarsCount := CStartStarsCount;
    player.LifeLevel := CStartLifeLevel;
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
  // TODO : envoyer un message avec toutes les données plutôt que X messages pour chaque case
  for X := msg.X to msg.X + msg.ColNumber - 1 do
    for Y := msg.Y to msg.Y + msg.RowNumber - 1 do
      SendMapCell(AFromGame, X, Y, SporglooMap.GetTileID(X, Y));
end;

procedure TSporglooServer.onPlayerMove(const AFromGame
  : TOlfSocketMessagingServerConnectedClient; const msg: TPlayerMoveMessage);
var
  Session: TSporglooSession;
begin
{$IFDEF DEBUG}
  writeln('onPlayerMove');
{$ENDIF}
  if msg.SessionID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongSessionID,
      'Session ID needed.');

  if assigned(AFromGame.tagobject) and (AFromGame.tagobject is TSporglooSession)
    and (msg.SessionID = (AFromGame.tagobject as TSporglooSession).SessionID)
  then
    Session := AFromGame.tagobject as TSporglooSession
  else if not SporglooSessions.TryGetValue(msg.SessionID, Session) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowSessionID,
      'Unknow Session !');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongPlayerID,
      'Player ID needed.');

  if (msg.PlayerID <> Session.player.PlayerID) then
    SendErrorMessage(AFromGame,
      TSporglooErrorCode.WrongDeviceOrPlayerForSessionID,
      'Wrong player for this session.');

  // TODO : check if the movement the position is free on the map
  Session.player.PlayerX := msg.X;
  Session.player.PlayerY := msg.Y;

  // TODO : check the TileID, change score if needed, change lifelevel, change map tile

  SendPlayerMoveResponse(AFromGame);

  // TODO : to optimize this feature, store the new coordinates in a list and have a separate check for it
  for Session in SporglooSessions.Values do
    if assigned(Session.SocketClient) and (Session.SocketClient <> AFromGame)
    then
      try
        SendOtherPlayerMove(Session.SocketClient, Session.player.PlayerID,
          Session.player.PlayerX, Session.player.PlayerY);
      except
        // TODO : erreur avec une session, la virer ou traiter en fonction de l'erreur
      end;
end;

procedure TSporglooServer.onPlayerPutAStar(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TPlayerAddAStarOnTheMapMessage);
var
  Session: TSporglooSession;
begin
{$IFDEF DEBUG}
  writeln('onPlayerPutAStar');
{$ENDIF}
  if msg.SessionID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongSessionID,
      'Session ID needed.');

  if assigned(AFromGame.tagobject) and (AFromGame.tagobject is TSporglooSession)
    and (msg.SessionID = (AFromGame.tagobject as TSporglooSession).SessionID)
  then
    Session := AFromGame.tagobject as TSporglooSession
  else if not SporglooSessions.TryGetValue(msg.SessionID, Session) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowSessionID,
      'Unknow Session !');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongPlayerID,
      'Player ID needed.');

  if (msg.PlayerID <> Session.player.PlayerID) then
    SendErrorMessage(AFromGame,
      TSporglooErrorCode.WrongDeviceOrPlayerForSessionID,
      'Wrong player for this session.');

  if (Session.player.StarsCount > 0) then
  begin
    SporglooMap.SetTileID(msg.X, msg.Y, CSporglooTileStar);
    Session.player.StarsCount := Session.player.StarsCount - 1;

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
  SendPlayerPutAStarResponse(AFromGame, msg.X, msg.Y);
end;

procedure TSporglooServer.SaveGameData;
var
  fs: tfilestream;
  FileName: string;
  Folder: string;
begin
  FileName := GetGameDataFileName;
  if not FileName.IsEmpty then
  begin
    Folder := tpath.GetDirectoryName(FileName);
    if (not Folder.IsEmpty) then
    begin
      if not TDirectory.Exists(Folder) then
        TDirectory.CreateDirectory(Folder);
      fs := tfilestream.Create(FileName, fmcreate + fmOpenWrite);
      try
        SporglooPlayers.SaveToStream(fs);
        SporglooMap.SaveToStream(fs);
      finally
        fs.Free;
      end;
    end;
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

initialization

tparams.InitDefaultFileNameV2('Gamolf', 'SporglooServer');

end.
