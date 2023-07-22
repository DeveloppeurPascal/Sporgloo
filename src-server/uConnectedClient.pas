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
    procedure SetSocket(const Value: TSocket);
  protected
    procedure Execute; override;

    procedure ReceivedAPIMessage(Const Msg: TSporglooAPIMessage);
    procedure SendAPIMessage(Const Msg: TSporglooAPIMessage);

    procedure onClientRegister(Const DeviceID: TSporglooAPIAlpha16);
    procedure onClientLogin(Const DeviceID, PlayerID: TSporglooAPIAlpha16);
    procedure onMapRefresh(Const MapX, MapY, ColNumber,
      RowNumber: TSporglooAPINumber);
    procedure onPlayerMove(Const SessionID, PlayerID: TSporglooAPIAlpha16;
      Const PlayerX, PlayerY: TSporglooAPINumber);
    procedure onPlayerPutAStar(Const SessionID, PlayerID: TSporglooAPIAlpha16;
      Const NewStarX, NewStarY: TSporglooAPINumber);

    procedure SendClientRegisterResponse(Const DeviceID, PlayerID: string;
      var Msg: TSporglooAPIMessage);
    procedure SendClientLoginResponse(Const DeviceID, SessionID: string;
      Const PlayerX, PlayerY: TSporglooAPINumber; var Msg: TSporglooAPIMessage);
    procedure SendMapCell(Const MapX, MapY: TSporglooAPINumber;
      Const MapTileID: TSporglooAPIShort; var Msg: TSporglooAPIMessage);
    procedure SendPlayerMoveResponse(var Msg: TSporglooAPIMessage);
    procedure SendPlayerPutAStarResponse(Const NewStarX,
      NewStarY: TSporglooAPINumber; var Msg: TSporglooAPIMessage);
    procedure SendOtherPlayerMove(Const PlayerID: string;
      Const PlayerX, PlayerY: TSporglooAPINumber; var Msg: TSporglooAPIMessage);
  public
    property Socket: TSocket read FSocket write SetSocket;
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
  Socket := AClientSocket;
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
  Msg: TSporglooAPIMessage;
  i: integer;
begin
  NameThreadForDebugging('ConnectedClient');
  Msg.Reset;
  while not TThread.CheckTerminated do
  begin
    RecCount := FSocket.Receive(Buffer);
    if (RecCount > 0) then
    begin
      for i := 0 to RecCount - 1 do
        if (Buffer[i] = CSportglooAPIMessageTerminator) then
        begin
          ReceivedAPIMessage(Msg);
          Msg.Reset;
        end
        else
          Msg.Push(Buffer[i]);
    end;
  end;
end;

procedure TConnectedClient.onClientLogin(const DeviceID,
  PlayerID: TSporglooAPIAlpha16);
begin
  // TODO : à compléter
end;

procedure TConnectedClient.onClientRegister(const DeviceID
  : TSporglooAPIAlpha16);
begin
  // TODO : à compléter
end;

procedure TConnectedClient.onMapRefresh(const MapX, MapY, ColNumber,
  RowNumber: TSporglooAPINumber);
begin
  // TODO : à compléter
end;

procedure TConnectedClient.onPlayerMove(const SessionID,
  PlayerID: TSporglooAPIAlpha16; const PlayerX, PlayerY: TSporglooAPINumber);
begin
  // TODO : à compléter
end;

procedure TConnectedClient.onPlayerPutAStar(const SessionID,
  PlayerID: TSporglooAPIAlpha16; const NewStarX, NewStarY: TSporglooAPINumber);
begin
  // TODO : à compléter
end;

procedure TConnectedClient.ReceivedAPIMessage(const Msg: TSporglooAPIMessage);
begin
  case Msg.MessageID of
    1:
      onClientRegister(Msg.Msg1DeviceID);
    3:
      onClientLogin(Msg.Msg2DeviceID, Msg.Msg2PlayerID);
    5:
      onMapRefresh(Msg.Msg5MapX, Msg.Msg5MapY, Msg.Msg5ColNumber,
        Msg.Msg5RowNumber);
    7:
      onPlayerMove(Msg.Msg7SessionID, Msg.Msg7PlayerID, Msg.Msg7PlayerX,
        Msg.Msg7PlayerY);
    9:
      onPlayerPutAStar(Msg.Msg9SessionID, Msg.Msg9PlayerID, Msg.Msg9NewStarX,
        Msg.Msg9NewStarY);
  else
    raise Exception.Create('Message ' + Msg.MessageID.Tostring +
      ' received by the server.');
  end;
end;

procedure TConnectedClient.SendAPIMessage(const Msg: TSporglooAPIMessage);
var
  MsgSize: integer;
begin
  if not assigned(FSocket) then
    exit;

  MsgSize := 0;
  while (MsgSize < CSportglooBufferLength) and
    (Msg.Buffer[MsgSize] <> CSportglooAPIMessageTerminator) do
    inc(MsgSize);

  if not(MsgSize < CSportglooBufferLength) then
    raise Exception.Create('Wrong buffer size. Please increase it.');

  FSocket.Send(Msg.Buffer, MsgSize);
end;

procedure TConnectedClient.SendClientLoginResponse(const DeviceID,
  SessionID: string; const PlayerX, PlayerY: TSporglooAPINumber;
  var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 4;
  StringToAlpha16(DeviceID, Msg.Msg4DeviceID);
  StringToAlpha16(SessionID, Msg.Msg4SessionID);
  Msg.Msg4PlayerX := PlayerX;
  Msg.Msg4Playery := PlayerY;
  SendAPIMessage(Msg);
end;

procedure TConnectedClient.SendClientRegisterResponse(const DeviceID,
  PlayerID: string; var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 2;
  StringToAlpha16(DeviceID, Msg.Msg2DeviceID);
  StringToAlpha16(PlayerID, Msg.Msg2PlayerID);
  SendAPIMessage(Msg);
end;

procedure TConnectedClient.SendMapCell(const MapX, MapY: TSporglooAPINumber;
  const MapTileID: TSporglooAPIShort; var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 6;
  Msg.Msg6MapX := MapX;
  Msg.Msg6MapY := MapY;
  Msg.Msg6MapTileID := MapTileID;
  SendAPIMessage(Msg);
end;

procedure TConnectedClient.SendOtherPlayerMove(const PlayerID: string;
  const PlayerX, PlayerY: TSporglooAPINumber; var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 11;
  StringToAlpha16(PlayerID, Msg.Msg11PlayerID);
  Msg.Msg11PlayerX := PlayerX;
  Msg.Msg11Playery := PlayerY;
  SendAPIMessage(Msg);
end;

procedure TConnectedClient.SendPlayerMoveResponse(var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 8;
  SendAPIMessage(Msg);
end;

procedure TConnectedClient.SendPlayerPutAStarResponse(const NewStarX,
  NewStarY: TSporglooAPINumber; var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 10;
  Msg.Msg10NewStarX := NewStarX;
  Msg.Msg10NewStary := NewStarY;
  SendAPIMessage(Msg);
end;

procedure TConnectedClient.SetSocket(const Value: TSocket);
begin
  FSocket := Value;
end;

initialization

ClientsList := TThreadList<TConnectedClient>.Create;

finalization

FreeClientsList;

end.
