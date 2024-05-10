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

    procedure DeprecatedOnClientRegister(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TClientRegisterDeprecatedMessage);
    procedure DeprecatedOnClientLogin(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TClientLoginDeprecatedMessage);
    procedure onAskForMapRefresh(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TAskForMapRefreshMessage);
    procedure onPlayerMove(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TPlayerMoveMessage);
    procedure onPlayerAddAStarOnTheMap(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TPlayerAddAStarOnTheMapMessage);
    procedure onLogoff(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient; Const msg: TLogoffMessage);
    procedure onAskForPlayerInfos(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TAskForPlayerInfosMessage);
    procedure onClientLogin(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TClientLoginMessage);
    procedure onClientRegister(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TClientRegisterMessage);
    procedure onGetHallOfFameScores(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TGetHallOfFameScoresMessage);
    procedure onKillCurrentPlayer(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TKillCurrentPlayerMessage);
    procedure onPlayerImageChanged(Const AFromGame
      : TOlfSocketMessagingServerConnectedClient;
      Const msg: TPlayerImageChangedMessage);

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
      Const MapCell: TSporglooMapCell);

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
  onReceiveAskForMapRefreshMessage := onAskForMapRefresh;
  onReceiveAskForPlayerInfosMessage := onAskForPlayerInfos;
  onReceiveClientLoginDeprecatedMessage := DeprecatedOnClientLogin;
  onReceiveClientLoginMessage := onClientLogin;
  onReceiveClientRegisterDeprecatedMessage := DeprecatedOnClientRegister;
  onReceiveClientRegisterMessage := onClientRegister;
  onReceiveErrorMessage := onErrorMessage;
  onReceiveGetHallOfFameScoresMessage := onGetHallOfFameScores;
  onReceiveKillCurrentPlayerMessage := onKillCurrentPlayer;
  onReceiveLogoffMessage := onLogoff;
  onReceivePlayerAddAStarOnTheMapMessage := onPlayerAddAStarOnTheMap;
  onReceivePlayerImageChangedMessage := onPlayerImageChanged;
  onReceivePlayerMoveMessage := onPlayerMove;

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
        // writeln('DB saved');
{$ENDIF}
      end;
    end).start;

  tthread.createanonymousthread(
    procedure
    var
      MapCell: TSporglooMapCell;
      Session: TSporglooSession;
    begin
      while not tthread.CheckTerminated do
      begin
        MapCell := GetNextChangedMapCell;
        if assigned(MapCell) then
        begin
          MapCell.HasChanged := false;
          for Session in SporglooSessions.Values do
            try
              SendMapCell(Session.SocketClient, MapCell);
            except
              // TODO : erreur avec une session, la virer ou traiter en fonction de l'erreur
            end;
        end
        else
          sleep(10);
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

procedure TSporglooServer.DeprecatedOnClientLogin(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TClientLoginDeprecatedMessage);
begin
end;

procedure TSporglooServer.DeprecatedOnClientRegister(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TClientRegisterDeprecatedMessage);
begin
end;

procedure TSporglooServer.onErrorMessage(const AFromGame
  : TOlfSocketMessagingServerConnectedClient; const msg: TErrorMessage);
begin
{$IFDEF DEBUG}
  // writeln('onErrorMessage n°' + msg.ErrorCode.tostring +  ' received from a client.');
{$ENDIF}
  // TODO : manage the received error
end;

procedure TSporglooServer.onGetHallOfFameScores(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TGetHallOfFameScoresMessage);
begin

end;

procedure TSporglooServer.onKillCurrentPlayer(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TKillCurrentPlayerMessage);
begin

end;

procedure TSporglooServer.onLogoff(const AFromGame
  : TOlfSocketMessagingServerConnectedClient; const msg: TLogoffMessage);
var
  SessionID: string;
{$IFDEF DEBUG}
  nb: integer;
{$ENDIF}
begin
  if assigned(AFromGame.tagobject) and (AFromGame.tagobject is TSporglooSession)
  then
  begin
{$IFDEF DEBUG}
    // writeln('onLogOff');
    // writeln('nb sessions = ', SporglooSessions.count);
    nb := 0;
    ForEachConnectedClient(
      procedure(Const AConnectedClient: TOlfSMSrvConnectedClient)
      begin
        AtomicIncrement(nb);
      end);
    // writeln('nb = ', nb);
{$ENDIF}
    tthread.CurrentThread.Terminate;
    SessionID := (AFromGame.tagobject as TSporglooSession).SessionID;
    (AFromGame.tagobject as TSporglooSession).SocketClient := nil;
    AFromGame.tagobject := nil;
    System.Tmonitor.enter(SporglooSessions);
    try
      SporglooSessions.Remove(SessionID);
    finally
      System.Tmonitor.Exit(SporglooSessions);
    end;
{$IFDEF DEBUG}
    // writeln('nb sessions = ', SporglooSessions.count);
    nb := 0;
    ForEachConnectedClient(
      procedure(Const AConnectedClient: TOlfSMSrvConnectedClient)
      begin
        AtomicIncrement(nb);
      end);
    // writeln('nb = ', nb);
{$ENDIF}
  end;
end;

procedure TSporglooServer.onAskForMapRefresh(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TAskForMapRefreshMessage);
var
  X, Y: TSporglooAPINumber;
begin
{$IFDEF DEBUG}
  // writeln('onMapRefresh');
{$ENDIF}
  if msg.ColNumber < 1 then
    Exit;
  if msg.RowNumber < 1 then
    Exit;

  // TODO : envoyer un message avec toutes les données plutôt que X messages pour chaque case
  for X := msg.X to msg.X + msg.ColNumber - 1 do
    for Y := msg.Y to msg.Y + msg.RowNumber - 1 do
    begin
      SendMapCell(AFromGame, SporglooMap.GetCellAt(X, Y));
      // TODO : référencer la session au niveau de la liste des sessions à mettre à jour en cas de changement de chaque cellule
    end;
end;

procedure TSporglooServer.onAskForPlayerInfos(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TAskForPlayerInfosMessage);
begin

end;

procedure TSporglooServer.onClientLogin(const AFromGame
  : TOlfSocketMessagingServerConnectedClient; const msg: TClientLoginMessage);
var
  player: TSporglooPlayer;
  Session: TSporglooSession;
begin
{$IFDEF DEBUG}
  // writeln('onClientLogin');
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
  Session.SocketClient := AFromGame;
  AFromGame.tagobject := Session;

  System.Tmonitor.enter(SporglooSessions);
  try
    SporglooSessions.Add(Session.SessionID, Session);
  finally
    System.Tmonitor.Exit(SporglooSessions);
  end;

  SendClientLoginResponse(AFromGame, Session.player.DeviceID, Session.SessionID,
    Session.player.PlayerX, Session.player.PlayerY, Session.player.Score,
    Session.player.StarsCount, Session.player.LifeLevel);
end;

procedure TSporglooServer.onClientRegister(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TClientRegisterMessage);
var
  player: TSporglooPlayer;
  Session: TSporglooSession;
  ok: boolean;
  MapCell: TSporglooMapCell;
begin
{$IFDEF DEBUG}
  // writeln('onClientRegister');
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

    if (SporglooSessions.count > 0) then
    begin
      Session := SporglooSessions.ToArray[random(SporglooSessions.count)].Value;
      repeat
        player.PlayerX := Session.player.PlayerX +
          random(CStartDistanceFromLastPlayer * 2) -
          CStartDistanceFromLastPlayer;
        player.PlayerY := Session.player.PlayerY +
          random(CStartDistanceFromLastPlayer * 2) -
          CStartDistanceFromLastPlayer;
        ok := true;
        // TODO : tester si un joueur est à ces nouvelles coordonnées une fois les joueurs dans la grille
      until ok;
    end
    else
    begin
      repeat
        player.PlayerX := random(CStartDistanceFromLastPlayer +
          CStartDistanceFromLastPlayer + 1) - CStartDistanceFromLastPlayer;
        player.PlayerY := random(CStartDistanceFromLastPlayer +
          CStartDistanceFromLastPlayer + 1) - CStartDistanceFromLastPlayer;
        ok := true;
        // TODO : tester si un joueur est à ces nouvelles coordonnées une fois les joueurs dans la grille
      until ok;
    end;

    player.Score := 0;
    player.StarsCount := CStartStarsCount;
    player.LifeLevel := CStartLifeLevel;
    SporglooPlayers.Add(player.PlayerID, player);

    MapCell := SporglooMap.GetCellAt(player.PlayerX, player.PlayerY);
    MapCell.TileID := CSporglooTilePath;
    MapCell.PlayerID := player.PlayerID;

    SendClientRegisterResponse(AFromGame, player.DeviceID, player.PlayerID);
  end
  else
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongDeviceForPlayerID,
      'A player is already registered for this device.');
end;

procedure TSporglooServer.onPlayerMove(const AFromGame
  : TOlfSocketMessagingServerConnectedClient; const msg: TPlayerMoveMessage);
var
  Session: TSporglooSession;
  MapCell, PrevMapCell: TSporglooMapCell;
begin
{$IFDEF DEBUG}
  // writeln('onPlayerMove');
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

  if (Session.player.PlayerX <> msg.X) or (Session.player.PlayerY <> msg.Y) then
  begin
{$IFDEF DEBUG}
    // writeln('onPlayerMove - new coordinates');
{$ENDIF}
    MapCell := SporglooMap.GetCellAt(msg.X, msg.Y);
    if (not(MapCell.TileID = CSporglooTileForest)) and MapCell.PlayerID.IsEmpty
    then
    begin
{$IFDEF DEBUG}
      // writeln('onPlayerMove - accepted move');
{$ENDIF}
      if MapCell.TileID = CSporglooTileStar then
      begin
        MapCell.TileID := CSporglooTilePath;
        Session.player.StarsCount := Session.player.StarsCount + 1;
{$IFDEF DEBUG}
        // writeln('StarsCount = ' + Session.player.StarsCount.tostring);
{$ENDIF}
      end;
      // TODO : check the TileID, change score if needed, change lifelevel, change map tile

      PrevMapCell := SporglooMap.GetCellAt(Session.player.PlayerX,
        Session.player.PlayerY);
      PrevMapCell.PlayerID := '';

      Session.player.PlayerX := msg.X;
      Session.player.PlayerY := msg.Y;

      MapCell.PlayerID := Session.player.PlayerID;
    end
    else
      SendErrorMessage(AFromGame, TSporglooErrorCode.PlayerMoveDenied,
        'New position not available.');
  end
  else
  begin
{$IFDEF DEBUG}
    // writeln('onPlayerMove - but same coordinates');
{$ENDIF}
  end;
end;

procedure TSporglooServer.onPlayerAddAStarOnTheMap(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TPlayerAddAStarOnTheMapMessage);
var
  Session: TSporglooSession;
begin
{$IFDEF DEBUG}
  // writeln('onPlayerPutAStar');
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
    SporglooMap.GetCellAt(msg.X, msg.Y).TileID := CSporglooTileStar;
    Session.player.StarsCount := Session.player.StarsCount - 1;
{$IFDEF DEBUG}
    // writeln('StarsCount = ' + Session.player.StarsCount.tostring);
{$ENDIF}
  end;
end;

procedure TSporglooServer.onPlayerImageChanged(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TPlayerImageChangedMessage);
begin

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
    // TODO : login answer changed
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
{$IFDEF DEBUG}
  // writeln('ERROR ' + ord(AErrorCode).tostring + ': ' + AErrorText);
{$ENDIF}
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
  : TOlfSocketMessagingServerConnectedClient; Const MapCell: TSporglooMapCell);
var
  msg: TMapCellInfoMessage;
begin
{$IFDEF DEBUG}
  // writeln('=> ', MapCell.PlayerID, ' - ', MapCell.X, ',', MapCell.Y, '=',  MapCell.TileID);
{$ENDIF}
  msg := TMapCellInfoMessage.Create;
  try
    msg.X := MapCell.X;
    msg.Y := MapCell.Y;
    msg.TileID := MapCell.TileID;
    msg.PlayerID := MapCell.PlayerID;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

initialization

tparams.InitDefaultFileNameV2('Gamolf', 'SporglooServer');

end.
