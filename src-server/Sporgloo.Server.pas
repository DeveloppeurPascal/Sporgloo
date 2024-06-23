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

    procedure SendClientLoginResponse(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const DeviceID, SessionID, PlayerID: string);
    procedure SendClientRegisterResponse(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const DeviceID, PlayerID, DeviceAuthKey: string);
    procedure SendCoinsCountChange(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const ACoinsCount: TSporglooAPINumber);
    procedure SendCurrentPlayerKilledResponse(Const AToGame
      : TOlfSocketMessagingServerConnectedClient);
    procedure SendErrorMessage(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      const AErrorCode: TSporglooErrorCode; const AErrorText: string;
      const ARaiseException: boolean = true);
    procedure SendHallOfFame(Const AToGame
      : TOlfSocketMessagingServerConnectedClient; TODO_A_Completer: integer);
    procedure SendLivesCountChange(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const ALivesCount: TSporglooAPINumber);
    procedure SendLogoff(Const AToGame
      : TOlfSocketMessagingServerConnectedClient);
    procedure SendMapCellInfo(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const MapCell: TSporglooMapCell);
    procedure SendPlayerInfosResponse(Const AToGame
      : TOlfSocketMessagingServerConnectedClient; Const PlayerID: string);
    procedure SendStarsCountChange(Const AToGame
      : TOlfSocketMessagingServerConnectedClient;
      Const AStarsCount: TSporglooAPINumber);

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
  Olf.RTL.Params,
  Sporgloo.Utils,
  Olf.RTL.GenRandomID;

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
              SendMapCellInfo(Session.SocketClient, MapCell);
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
  SendErrorMessage(AFromGame, TSporglooErrorCode.WrongAPIVersion, 'Wrong API.');
end;

procedure TSporglooServer.DeprecatedOnClientRegister(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TClientRegisterDeprecatedMessage);
begin
  SendErrorMessage(AFromGame, TSporglooErrorCode.WrongAPIVersion, 'Wrong API.');
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
  // TODO : à compléter
  SendHallOfFame(AFromGame, 0);
end;

procedure TSporglooServer.onKillCurrentPlayer(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TKillCurrentPlayerMessage);
var
  Session: TSporglooSession;
begin
{$IFDEF DEBUG}
  // writeln('onKillCurrentPlayer');
{$ENDIF}
  if msg.SessionID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongSessionID,
      'Session ID needed.');

  if assigned(AFromGame.tagobject) and (AFromGame.tagobject is TSporglooSession)
    and (msg.SessionID = (AFromGame.tagobject as TSporglooSession).SessionID)
  then
    Session := AFromGame.tagobject as TSporglooSession
  else if SporglooSessions.TryGetValue(msg.SessionID, Session) then
    AFromGame.tagobject := Session
  else
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowSessionID,
      'Unknow Session !');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongPlayerID,
      'Player ID needed.');

  if (msg.PlayerID <> Session.Player.PlayerID) then
    SendErrorMessage(AFromGame,
      TSporglooErrorCode.WrongDeviceOrPlayerForSessionID,
      'Wrong player for this session.');

  // plus de lien entre le joueur en cours et l'appareil du joueur
  Session.Player.DeviceID := '';

  // annulation de la session
  AFromGame.tagobject := nil;
  Session.SocketClient := nil;
  Session.Free;

  // Confirmation de la suppression du lien entre le player et son joueur
  SendCurrentPlayerKilledResponse(AFromGame);
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
  Session: TSporglooSession;
begin
{$IFDEF DEBUG}
  // writeln('onAskForMapRefresh');
{$ENDIF}
  if msg.SessionID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongSessionID,
      'Session ID needed.');

  if assigned(AFromGame.tagobject) and (AFromGame.tagobject is TSporglooSession)
    and (msg.SessionID = (AFromGame.tagobject as TSporglooSession).SessionID)
  then
    Session := AFromGame.tagobject as TSporglooSession
  else if SporglooSessions.TryGetValue(msg.SessionID, Session) then
    AFromGame.tagobject := Session
  else
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowSessionID,
      'Unknow Session !');

  if msg.ColNumber < 1 then
    Exit;
  if msg.RowNumber < 1 then
    Exit;

  for X := msg.X to msg.X + msg.ColNumber - 1 do
    for Y := msg.Y to msg.Y + msg.RowNumber - 1 do
    begin
      SendMapCellInfo(AFromGame, SporglooMap.GetCellAt(X, Y));
      // TODO : référencer la session au niveau de la liste des sessions à mettre à jour en cas de changement de chaque cellule
    end;
end;

procedure TSporglooServer.onAskForPlayerInfos(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TAskForPlayerInfosMessage);
var
  Session: TSporglooSession;
begin
{$IFDEF DEBUG}
  // writeln('onAskForPlayerInfos');
{$ENDIF}
  if msg.SessionID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongSessionID,
      'Session ID needed.');

  if assigned(AFromGame.tagobject) and (AFromGame.tagobject is TSporglooSession)
    and (msg.SessionID = (AFromGame.tagobject as TSporglooSession).SessionID)
  then
    Session := AFromGame.tagobject as TSporglooSession
  else if SporglooSessions.TryGetValue(msg.SessionID, Session) then
    AFromGame.tagobject := Session
  else
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowSessionID,
      'Unknow Session !');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongPlayerID,
      'Player ID needed.');

  SendPlayerInfosResponse(AFromGame, msg.PlayerID);
end;

procedure TSporglooServer.onClientLogin(const AFromGame
  : TOlfSocketMessagingServerConnectedClient; const msg: TClientLoginMessage);
var
  Player: TSporglooPlayer;
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

  if not SporglooPlayers.TryGetValue(msg.PlayerID, Player) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowPlayerID,
      'Unknow player !');

  if msg.DeviceID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongDeviceID,
      'Login with empty device ID is not allowed.');

  if (Player.DeviceID <> msg.DeviceID) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongDeviceForPlayerID,
      'Can''t log with this player on your device.');

  if (msg.TokenID <> GetTokenID(Player.PlayerID, Player.DeviceID,
    Player.DeviceAuthKey)) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongToken, 'Wrong token.');

  Session := TSporglooSession.Create;
  Session.SessionID := GetUniqID;
  Session.Player := Player;
  Session.SocketClient := AFromGame;
  AFromGame.tagobject := Session;

  System.Tmonitor.enter(SporglooSessions);
  try
    SporglooSessions.Add(Session.SessionID, Session);
  finally
    System.Tmonitor.Exit(SporglooSessions);
  end;

  SendClientLoginResponse(AFromGame, Session.Player.DeviceID, Session.SessionID,
    Session.Player.PlayerID);
end;

procedure TSporglooServer.onClientRegister(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TClientRegisterMessage);
var
  Player: TSporglooPlayer;
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

  if (msg.ServerAuthKey <> GetServerAuthKey(msg.DeviceID)) then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongToken, 'Wrong token.');

  Player := SporglooPlayers.GetPlayerByDevice(msg.DeviceID);
  if not assigned(Player) then
  begin
    Player := TSporglooPlayer.Create;
    Player.DeviceID := msg.DeviceID;
    Player.DeviceAuthKey := TOlfRandomIDGenerator.getIDBase62(50);
    Player.PlayerID := GetUniqID;

    if (SporglooSessions.count > 0) then
    begin
      Session := SporglooSessions.ToArray[random(SporglooSessions.count)].Value;
      repeat
        Player.PlayerX := Session.Player.PlayerX +
          random(CStartDistanceFromLastPlayer * 2) -
          CStartDistanceFromLastPlayer;
        Player.PlayerY := Session.Player.PlayerY +
          random(CStartDistanceFromLastPlayer * 2) -
          CStartDistanceFromLastPlayer;
        ok := true;
        // TODO : tester si un joueur est à ces nouvelles coordonnées une fois les joueurs dans la grille
      until ok;
    end
    else
    begin
      repeat
        Player.PlayerX := random(CStartDistanceFromLastPlayer +
          CStartDistanceFromLastPlayer + 1) - CStartDistanceFromLastPlayer;
        Player.PlayerY := random(CStartDistanceFromLastPlayer +
          CStartDistanceFromLastPlayer + 1) - CStartDistanceFromLastPlayer;
        ok := true;
        // TODO : tester si un joueur est à ces nouvelles coordonnées une fois les joueurs dans la grille
      until ok;
    end;

    Player.CoinsCount := 0;
    Player.StarsCount := CStartStarsCount;
    Player.LivesCount := CStartLifeLevel;
    SporglooPlayers.Add(Player.PlayerID, Player);

    MapCell := SporglooMap.GetCellAt(Player.PlayerX, Player.PlayerY);
    MapCell.TileID := CSporglooTilePath;
    MapCell.PlayerID := Player.PlayerID;
    MapCell.PlayerImageID := Player.ImageID;

    SendClientRegisterResponse(AFromGame, Player.DeviceID, Player.PlayerID,
      Player.DeviceAuthKey);
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
  else if SporglooSessions.TryGetValue(msg.SessionID, Session) then
    AFromGame.tagobject := Session
  else
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowSessionID,
      'Unknow Session !');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongPlayerID,
      'Player ID needed.');

  if (msg.PlayerID <> Session.Player.PlayerID) then
    SendErrorMessage(AFromGame,
      TSporglooErrorCode.WrongDeviceOrPlayerForSessionID,
      'Wrong player for this session.');

  if (Session.Player.PlayerX <> msg.X) or (Session.Player.PlayerY <> msg.Y) then
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
        Session.Player.StarsCount := Session.Player.StarsCount + 1;
{$IFDEF DEBUG}
        // writeln('StarsCount = ' + Session.player.StarsCount.tostring);
{$ENDIF}
      end;
      // TODO : check the TileID, change score if needed, change lifelevel, change map tile

      PrevMapCell := SporglooMap.GetCellAt(Session.Player.PlayerX,
        Session.Player.PlayerY);
      PrevMapCell.PlayerID := '';

      Session.Player.PlayerX := msg.X;
      Session.Player.PlayerY := msg.Y;

      MapCell.PlayerID := Session.Player.PlayerID;
      MapCell.PlayerImageID := Session.Player.ImageID;
    end
    else
      SendErrorMessage(AFromGame, TSporglooErrorCode.PlayerMoveDenied,
        'New position not available.');
{$IFDEF DEBUG}
  end
  else
  begin
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
  else if SporglooSessions.TryGetValue(msg.SessionID, Session) then
    AFromGame.tagobject := Session
  else
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowSessionID,
      'Unknow Session !');

  if msg.PlayerID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongPlayerID,
      'Player ID needed.');

  if (msg.PlayerID <> Session.Player.PlayerID) then
    SendErrorMessage(AFromGame,
      TSporglooErrorCode.WrongDeviceOrPlayerForSessionID,
      'Wrong player for this session.');

  if (Session.Player.StarsCount > 0) then
  begin
    SporglooMap.GetCellAt(msg.X, msg.Y).TileID := CSporglooTileStar;
    Session.Player.StarsCount := Session.Player.StarsCount - 1;
{$IFDEF DEBUG}
    // writeln('StarsCount = ' + Session.player.StarsCount.tostring);
{$ENDIF}
  end;
end;

procedure TSporglooServer.onPlayerImageChanged(const AFromGame
  : TOlfSocketMessagingServerConnectedClient;
const msg: TPlayerImageChangedMessage);
var
  Session: TSporglooSession;
begin
{$IFDEF DEBUG}
  // writeln('onPlayerImageChanged');
{$ENDIF}
  if msg.SessionID.IsEmpty then
    SendErrorMessage(AFromGame, TSporglooErrorCode.WrongSessionID,
      'Session ID needed.');

  if assigned(AFromGame.tagobject) and (AFromGame.tagobject is TSporglooSession)
    and (msg.SessionID = (AFromGame.tagobject as TSporglooSession).SessionID)
  then
    Session := AFromGame.tagobject as TSporglooSession
  else if SporglooSessions.TryGetValue(msg.SessionID, Session) then
    AFromGame.tagobject := Session
  else
    SendErrorMessage(AFromGame, TSporglooErrorCode.UnknowSessionID,
      'Unknow Session !');

  Session.Player.ImageID := msg.ImageID;
  SporglooMap.GetCellAt(Session.Player.PlayerX, Session.Player.PlayerY)
    .PlayerImageID := msg.ImageID;
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
  : TOlfSocketMessagingServerConnectedClient; const DeviceID, SessionID,
  PlayerID: string);
var
  msg: TClientLoginResponseMessage;
begin
  msg := TClientLoginResponseMessage.Create;
  try
    msg.DeviceID := DeviceID;
    msg.SessionID := SessionID;
    msg.PlayerID := PlayerID;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendClientRegisterResponse(Const AToGame
  : TOlfSocketMessagingServerConnectedClient;
const DeviceID, PlayerID, DeviceAuthKey: string);
var
  msg: TClientRegisterResponseMessage;
begin
  msg := TClientRegisterResponseMessage.Create;
  try
    msg.DeviceID := DeviceID;
    msg.PlayerID := PlayerID;
    msg.DeviceAuthKey := DeviceAuthKey;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendCoinsCountChange(const AToGame
  : TOlfSocketMessagingServerConnectedClient;
const ACoinsCount: TSporglooAPINumber);
var
  msg: TCoinsCountChangeMessage;
begin
  msg := TCoinsCountChangeMessage.Create;
  try
    msg.CoinsCount := ACoinsCount;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendCurrentPlayerKilledResponse
  (const AToGame: TOlfSocketMessagingServerConnectedClient);
var
  msg: TCurrentPlayerKilledMessage;
begin
  msg := TCurrentPlayerKilledMessage.Create;
  try
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
  writeln('ERROR ' + ord(AErrorCode).tostring + ': ' + AErrorText);
  // TODO : pprem
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

procedure TSporglooServer.SendHallOfFame(const AToGame
  : TOlfSocketMessagingServerConnectedClient; TODO_A_Completer: integer);
begin
  // TODO : à compléter
end;

procedure TSporglooServer.SendLivesCountChange(const AToGame
  : TOlfSocketMessagingServerConnectedClient;
Const ALivesCount: TSporglooAPINumber);
var
  msg: TLivesCountChangeMessage;
begin
  msg := TLivesCountChangeMessage.Create;
  try
    msg.LivesCount := ALivesCount;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendLogoff(const AToGame
  : TOlfSocketMessagingServerConnectedClient);
var
  msg: TLogoffMessage;
begin
  msg := TLogoffMessage.Create;
  try
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendMapCellInfo(Const AToGame
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
    msg.ImageID := MapCell.PlayerImageID;
    msg.StarsCount := MapCell.StarsCount;
    msg.LivesCount := MapCell.LivesCount;
    msg.CoinsCount := MapCell.CoinsCount;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendPlayerInfosResponse(const AToGame
  : TOlfSocketMessagingServerConnectedClient; const PlayerID: string);
var
  Player: TSporglooPlayer;
  msg: TPlayerInfosMessage;
begin
  if PlayerID.IsEmpty then
    SendErrorMessage(AToGame, TSporglooErrorCode.WrongPlayerID,
      'Player ID needed.');

  if not SporglooPlayers.TryGetValue(PlayerID, Player) then
    SendErrorMessage(AToGame, TSporglooErrorCode.UnknowPlayerID,
      'Unknow player.');

  msg := TPlayerInfosMessage.Create;
  try
    msg.PlayerID := PlayerID;
    msg.X := Player.PlayerX;
    msg.Y := Player.PlayerY;
    msg.ImageID := Player.ImageID;
    msg.CoinsCount := Player.CoinsCount;
    msg.LivesCount := Player.LivesCount;
    msg.StarsCount := Player.StarsCount;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

procedure TSporglooServer.SendStarsCountChange(const AToGame
  : TOlfSocketMessagingServerConnectedClient;
Const AStarsCount: TSporglooAPINumber);
var
  msg: TStarsCountChangeMessage;
begin
  msg := TStarsCountChangeMessage.Create;
  try
    msg.StarsCount := AStarsCount;
    AToGame.SendMessage(msg);
  finally
    msg.Free;
  end;
end;

initialization

tparams.InitDefaultFileNameV2('Gamolf', 'SporglooServer');

end.
