unit uConnectedClient;

interface

uses
  System.net.Socket,
  System.Classes,
  Sporgloo.API.Messages,
  Sporgloo.Types,
  Sporgloo.Database;

type
  TConnectedClient = class(TThread)
  private
    FSocket: TSocket;
    FMsg: TSporglooAPIMessage;
    FSession: TSporglooSession;
    function GetSession: TSporglooSession;
  protected
    procedure Execute; override;

    procedure ReceivedAPIMessage;
    procedure SendAPIMessage;

    procedure onClientRegister(Const DeviceID: TSporglooAPIAlpha16);
    procedure onClientLogin(Const DeviceID, PlayerID: TSporglooAPIAlpha16);
    procedure onMapRefresh(Const MapX, MapY, ColNumber,
      RowNumber: TSporglooAPINumber);
    procedure onPlayerMove(Const SessionID, PlayerID: TSporglooAPIAlpha16;
      Const PlayerX, PlayerY: TSporglooAPINumber);
    procedure onPlayerPutAStar(Const SessionID, PlayerID: TSporglooAPIAlpha16;
      Const NewStarX, NewStarY: TSporglooAPINumber);

    procedure SendClientRegisterResponse(Const DeviceID, PlayerID: string);
    procedure SendClientLoginResponse(Const DeviceID, SessionID: string;
      Const PlayerX, PlayerY, Score, StarsCount, LifeLevel: TSporglooAPINumber);
    procedure SendMapCell(Const MapX, MapY: TSporglooAPINumber;
      Const MapTileID: TSporglooAPIShort);
    procedure SendPlayerMoveResponse;
    procedure SendPlayerPutAStarResponse(Const NewStarX,
      NewStarY: TSporglooAPINumber);
    procedure SendOtherPlayerMove(Const PlayerID: string;
      Const PlayerX, PlayerY: TSporglooAPINumber);
  public
    property Session: TSporglooSession read GetSession;

    constructor Create(AClientSocket: TSocket);
    destructor Destroy; override;
  end;

implementation

uses
  System.Generics.Collections,
  System.SysUtils, uServerData, Sporgloo.Consts;

var
  ClientsList: TThreadList<TConnectedClient>;

procedure FreeClientsList;
var
  i: integer;
  List: TList<TConnectedClient>;
begin
  List := ClientsList.LockList;
  try
    for i := List.count - 1 downto 0 do
      List[i].Terminate;
  finally
    ClientsList.UnlockList;
  end;
  ClientsList.Free;
end;

{ TConnectedClient }

constructor TConnectedClient.Create(AClientSocket: TSocket);
begin
  inherited Create(false);
  FSocket := AClientSocket;
  FSession := nil;
  FreeOnTerminate := true;
  ClientsList.Add(self);
end;

destructor TConnectedClient.Destroy;
begin
  ClientsList.Remove(self);
  FSocket.Free;
  inherited;
end;

procedure TConnectedClient.Execute;
var
  Buffer: TBytes;
  RecCount: integer;
  i: integer;
begin
{$IFDEF DEBUG}
  NameThreadForDebugging('ConnectedClient_' + FSocket.RemoteAddress);
  writeln('ConnectedClient_' + FSocket.RemoteAddress);
{$ENDIF}
  FMsg.Reset;
  while not TThread.CheckTerminated do
  begin
    RecCount := FSocket.Receive(Buffer);
    if (RecCount > 0) then
    begin
      for i := 0 to RecCount - 1 do
        if (Buffer[i] = CSporglooAPIMessageTerminator) then
        begin
          ReceivedAPIMessage;
          FMsg.Reset;
        end
        else
          FMsg.Push(Buffer[i]);
    end;
  end;
end;

function TConnectedClient.GetSession: TSporglooSession;
begin
  // TODO : lock the session for each access to it
  result := FSession;
end;

procedure TConnectedClient.onClientLogin(const DeviceID,
  PlayerID: TSporglooAPIAlpha16);
var
  LDeviceID, LPlayerID: string;
  player: TSporglooPlayer;
  Session: TSporglooSession;
begin
  Alpha16ToString(DeviceID, LDeviceID);
  if LDeviceID.IsEmpty then
    raise exception.Create('Login with empty device ID is not allowed.');

  Alpha16ToString(PlayerID, LPlayerID);
  if LPlayerID.IsEmpty then
    raise exception.Create('Login with empty player ID is not allowed.');

  if not TServerData.Current.Players.TryGetValue(LPlayerID, player) then
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
  // TODO : add a link to the player instance in the session

  TServerData.Current.Sessions.Add(Session.SessionID, Session);

  SendClientLoginResponse(Session.DeviceID, Session.SessionID, player.PlayerX,
    player.PlayerY, player.Score, player.StarsCount, player.LifeLevel);
end;

procedure TConnectedClient.onClientRegister(const DeviceID
  : TSporglooAPIAlpha16);
var
  LDeviceID, LPlayerID: string;
  player: TSporglooPlayer;
begin
  Alpha16ToString(DeviceID, LDeviceID);
  if LDeviceID.IsEmpty then
    raise exception.Create('Empty DeviceID to register.');

  player := TServerData.Current.Players.GetPlayerByDevice(LDeviceID);
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
    TServerData.Current.Players.Add(player.PlayerID, player);
  end;

  SendClientRegisterResponse(player.DeviceID, player.PlayerID);
end;

procedure TConnectedClient.onMapRefresh(const MapX, MapY, ColNumber,
  RowNumber: TSporglooAPINumber);
var
  x, y: TSporglooAPINumber;
begin
  if ColNumber < 1 then
    exit;
  if RowNumber < 1 then
    exit;
  for x := MapX to MapX + ColNumber - 1 do
    for y := MapY to MapY + RowNumber - 1 do
      SendMapCell(x, y, TServerData.Current.Map.GetTileID(x, y));
  // TODO : send the sessionID with the demand and store the size of displayed map for this session
end;

procedure TConnectedClient.onPlayerMove(const SessionID,
  PlayerID: TSporglooAPIAlpha16; const PlayerX, PlayerY: TSporglooAPINumber);
var
  LSessionID, LPlayerID: string;
  Session: TSporglooSession;
  player: TSporglooPlayer;
  List: TList<TConnectedClient>;
  i: integer;
begin
  Alpha16ToString(SessionID, LSessionID);
  if LSessionID.IsEmpty then
    raise exception.Create('Session ID needed.');

  Alpha16ToString(PlayerID, LPlayerID);
  if LPlayerID.IsEmpty then
    raise exception.Create('Player ID needed.');

  if not TServerData.Current.Sessions.TryGetValue(LSessionID, Session) then
    raise exception.Create('Unknow Session !');

  if not TServerData.Current.Players.TryGetValue(LPlayerID, player) then
    raise exception.Create('Unknow player !');

  if (player.DeviceID <> Session.DeviceID) and
    (player.PlayerID <> Session.PlayerID) then
    raise exception.Create('Wrong player for this session.');

  // TODO : check if the movement the position is free on the map
  player.PlayerX := PlayerX;
  player.PlayerY := PlayerY;

  // TODO : check the TileID, change score if needed, change lifelevel, change map tile

  SendPlayerMoveResponse;

  // TODO : to optimize this feature, store the new coordinates in a list and have a separate check for it
  List := ClientsList.LockList;
  try // TODO : try with TParallel.for()
    for i := 0 to List.count - 1 do
      if (List[i] <> self) then
        List[i].SendOtherPlayerMove(player.PlayerID, player.PlayerX,
          player.PlayerY);
  finally
    ClientsList.UnlockList;
  end;
end;

procedure TConnectedClient.onPlayerPutAStar(const SessionID,
  PlayerID: TSporglooAPIAlpha16; const NewStarX, NewStarY: TSporglooAPINumber);
var
  LSessionID, LPlayerID: string;
  Session: TSporglooSession;
  player: TSporglooPlayer;
  List: TList<TConnectedClient>;
  i: integer;
begin
  Alpha16ToString(SessionID, LSessionID);
  if LSessionID.IsEmpty then
    raise exception.Create('Session ID needed.');

  Alpha16ToString(PlayerID, LPlayerID);
  if LPlayerID.IsEmpty then
    raise exception.Create('Player ID needed.');

  if not TServerData.Current.Sessions.TryGetValue(LSessionID, Session) then
    raise exception.Create('Unknow Session !');

  if not TServerData.Current.Players.TryGetValue(LPlayerID, player) then
    raise exception.Create('Unknow player !');

  if (player.DeviceID <> Session.DeviceID) and
    (player.PlayerID <> Session.PlayerID) then
    raise exception.Create('Wrong player for this session.');

  if (player.StarsCount > 0) then
  begin
    TServerData.Current.Map.SetTileID(NewStarX, NewStarY, CSporglooTileStar);
    player.StarsCount := player.StarsCount - 1;
  end;
  SendPlayerPutAStarResponse(NewStarX, NewStarY);

  // TODO : to optimize this feature, store the changes in a list and have a separate check for it
  List := ClientsList.LockList;
  try // TODO : try with TParallel.for()
    for i := 0 to List.count - 1 do
      if (List[i] <> self) then
        List[i].SendMapCell(NewStarX, NewStarY, CSporglooTileStar);
  finally
    ClientsList.UnlockList;
  end;
end;

procedure TConnectedClient.ReceivedAPIMessage;
begin
{$IFDEF DEBUG}
  writeln('Message ' + FMsg.MessageID.Tostring + ' received from ' +
    FSocket.RemoteAddress);
{$ENDIF}
  case FMsg.MessageID of
    1:
      onClientRegister(FMsg.Msg1DeviceID);
    3:
      onClientLogin(FMsg.Msg2DeviceID, FMsg.Msg2PlayerID);
    5:
      onMapRefresh(FMsg.Msg5MapX, FMsg.Msg5MapY, FMsg.Msg5ColNumber,
        FMsg.Msg5RowNumber);
    7:
      onPlayerMove(FMsg.Msg7SessionID, FMsg.Msg7PlayerID, FMsg.Msg7PlayerX,
        FMsg.Msg7PlayerY);
    9:
      onPlayerPutAStar(FMsg.Msg9SessionID, FMsg.Msg9PlayerID, FMsg.Msg9NewStarX,
        FMsg.Msg9NewStarY);
  else
    raise exception.Create('Message ' + FMsg.MessageID.Tostring +
      ' received by the server.');
  end;
end;

procedure TConnectedClient.SendAPIMessage;
var
  TerminatorPosition: integer;
  SentBytes: word;
begin
  if not assigned(FSocket) then
    exit;

  TerminatorPosition := 0;
  while (TerminatorPosition < CSporglooAPIBufferLength) and
    (FMsg.Buffer[TerminatorPosition] <> CSporglooAPIMessageTerminator) do
    inc(TerminatorPosition);

  if not(TerminatorPosition < CSporglooAPIBufferLength) then
    raise exception.Create('Wrong buffer size. Please increase it.');

  SentBytes := FSocket.Send(FMsg.Buffer, TerminatorPosition + 1);
  if (SentBytes <> TerminatorPosition + 1) then
    raise exception.Create('Sending message ' + FMsg.MessageID.Tostring +
      ' error (' + SentBytes.Tostring + '/' + (TerminatorPosition + 1)
      .Tostring + ').');
end;

procedure TConnectedClient.SendClientLoginResponse(const DeviceID,
  SessionID: string; const PlayerX, PlayerY, Score, StarsCount,
  LifeLevel: TSporglooAPINumber);
begin
  FMsg.Clear;
  FMsg.MessageID := 4;
  StringToAlpha16(DeviceID, FMsg.Msg4DeviceID);
  StringToAlpha16(SessionID, FMsg.Msg4SessionID);
  FMsg.Msg4PlayerX := PlayerX;
  FMsg.Msg4Playery := PlayerY;
  FMsg.Msg4Score := Score;
  FMsg.Msg4StarsCount := StarsCount;
  FMsg.Msg4LifeLevel := LifeLevel;
  SendAPIMessage;
end;

procedure TConnectedClient.SendClientRegisterResponse(const DeviceID,
  PlayerID: string);
begin
  FMsg.Clear;
  FMsg.MessageID := 2;
  StringToAlpha16(DeviceID, FMsg.Msg2DeviceID);
  StringToAlpha16(PlayerID, FMsg.Msg2PlayerID);
  SendAPIMessage;
end;

procedure TConnectedClient.SendMapCell(const MapX, MapY: TSporglooAPINumber;
  const MapTileID: TSporglooAPIShort);
begin
  FMsg.Clear;
  FMsg.MessageID := 6;
  FMsg.Msg6MapX := MapX;
  FMsg.Msg6MapY := MapY;
  FMsg.Msg6MapTileID := MapTileID;
  SendAPIMessage;
end;

procedure TConnectedClient.SendOtherPlayerMove(const PlayerID: string;
  const PlayerX, PlayerY: TSporglooAPINumber);
begin
  FMsg.Clear;
  FMsg.MessageID := 11;
  StringToAlpha16(PlayerID, FMsg.Msg11PlayerID);
  FMsg.Msg11PlayerX := PlayerX;
  FMsg.Msg11Playery := PlayerY;
  SendAPIMessage;
end;

procedure TConnectedClient.SendPlayerMoveResponse;
begin
  FMsg.Clear;
  FMsg.MessageID := 8;
  SendAPIMessage;
end;

procedure TConnectedClient.SendPlayerPutAStarResponse(const NewStarX,
  NewStarY: TSporglooAPINumber);
begin
  FMsg.Clear;
  FMsg.MessageID := 10;
  FMsg.Msg10NewStarX := NewStarX;
  FMsg.Msg10NewStary := NewStarY;
  SendAPIMessage;
end;

initialization

ClientsList := TThreadList<TConnectedClient>.Create;

finalization

FreeClientsList;

end.
