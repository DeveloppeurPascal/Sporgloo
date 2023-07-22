unit uConnectedClient;

interface

uses
  System.net.Socket,
  System.Classes,
  uAPIMessages;

type
  TConnectedClient = class(TThread)
  private
    FSocket: TSocket;
    FMsg: TSporglooAPIMessage;
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
      Const PlayerX, PlayerY: TSporglooAPINumber);
    procedure SendMapCell(Const MapX, MapY: TSporglooAPINumber;
      Const MapTileID: TSporglooAPIShort);
    procedure SendPlayerMoveResponse;
    procedure SendPlayerPutAStarResponse(Const NewStarX,
      NewStarY: TSporglooAPINumber);
    procedure SendOtherPlayerMove(Const PlayerID: string;
      Const PlayerX, PlayerY: TSporglooAPINumber);
  public
    constructor Create(AClientSocket: TSocket);
    destructor Destroy; override;
  end;

implementation

uses
  System.Generics.Collections,
  System.SysUtils;

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
  NameThreadForDebugging('ConnectedClient');
  FMsg.Reset;
  while not TThread.CheckTerminated do
  begin
    RecCount := FSocket.Receive(Buffer);
    if (RecCount > 0) then
    begin
      for i := 0 to RecCount - 1 do
        if (Buffer[i] = CSportglooAPIMessageTerminator) then
        begin
          ReceivedAPIMessage;
          FMsg.Reset;
        end
        else
          FMsg.Push(Buffer[i]);
    end;
  end;
end;

procedure TConnectedClient.onClientLogin(const DeviceID,
  PlayerID: TSporglooAPIAlpha16);
var
  LDeviceID, LPlayerID, LSessionID: string;
  lplayerX, lplayery: TSporglooAPINumber;
begin
  Alpha16ToString(DeviceID, LDeviceID);
  // TODO : check if the device ID is known
  Alpha16ToString(PlayerID, LPlayerID);
  // TODO : check if the player exists
  // TODO : check if the devide ID is own by the player
  // TODO : generate a session ID
  LSessionID := '';
  // TODO : get data from the player and send them
  lplayerX := 0;
  lplayery := 0;
  SendClientLoginResponse(LDeviceID, LSessionID, lplayerX, lplayery);
end;

procedure TConnectedClient.onClientRegister(const DeviceID
  : TSporglooAPIAlpha16);
var
  LDeviceID, LPlayerID: string;
begin
  Alpha16ToString(DeviceID, LDeviceID);
  // TODO : check if the device ID already exists
  // TODO : generate a player ID and send it
  LPlayerID := '';
  SendClientRegisterResponse(LDeviceID, LPlayerID);
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
      SendMapCell(x, y, 0); // TODO : get MapTileID on (x,y)
end;

procedure TConnectedClient.onPlayerMove(const SessionID,
  PlayerID: TSporglooAPIAlpha16; const PlayerX, PlayerY: TSporglooAPINumber);
var
  LSessionID, LPlayerID: string;
begin
  Alpha16ToString(SessionID, LSessionID);
  // TODO : check the session ID
  Alpha16ToString(PlayerID, LPlayerID);
  // TODO : check the player ID
  // TODO : check the session if for this player
  // TODO : store player coordinates
  SendPlayerMoveResponse;
  // TODO : inform other users of the change
  // SendMapCell()
end;

procedure TConnectedClient.onPlayerPutAStar(const SessionID,
  PlayerID: TSporglooAPIAlpha16; const NewStarX, NewStarY: TSporglooAPINumber);
var
  LSessionID, LPlayerID: string;
begin
  Alpha16ToString(SessionID, LSessionID);
  // TODO : check the session ID
  Alpha16ToString(PlayerID, LPlayerID);
  // TODO : check the player ID
  // TODO : check the session if for this player
  // TODO : store new star coordinates (and changes on map tiles)
  SendPlayerPutAStarResponse(NewStarX, NewStarY);
  // TODO : inform other users of the change
  // SendMapCell()
end;

procedure TConnectedClient.ReceivedAPIMessage;
begin
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
    raise Exception.Create('Message ' + FMsg.MessageID.Tostring +
      ' received by the server.');
  end;
end;

procedure TConnectedClient.SendAPIMessage;
var
  MsgSize: integer;
begin
  if not assigned(FSocket) then
    exit;

  MsgSize := 0;
  while (MsgSize < CSportglooBufferLength) and
    (FMsg.Buffer[MsgSize] <> CSportglooAPIMessageTerminator) do
    inc(MsgSize);

  if not(MsgSize < CSportglooBufferLength) then
    raise Exception.Create('Wrong buffer size. Please increase it.');

  FSocket.Send(FMsg.Buffer, MsgSize);
end;

procedure TConnectedClient.SendClientLoginResponse(const DeviceID,
  SessionID: string; const PlayerX, PlayerY: TSporglooAPINumber);
begin
  FMsg.Clear;
  FMsg.MessageID := 4;
  StringToAlpha16(DeviceID, FMsg.Msg4DeviceID);
  StringToAlpha16(SessionID, FMsg.Msg4SessionID);
  FMsg.Msg4PlayerX := PlayerX;
  FMsg.Msg4Playery := PlayerY;
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
