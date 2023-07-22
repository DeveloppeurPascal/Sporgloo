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
    procedure onClientRegister(Const DeviceID: TSporglooAPIAlpha16);
    procedure onClientLogin(Const DeviceID, PlayerID: TSporglooAPIAlpha16);
    procedure onMapRefresh(Const MapX, MapY, ColNumber,
      RowNumber: TSporglooAPINumber);
    procedure onPlayerMove(Const SessionID, PlayerID: TSporglooAPIAlpha16;
      Const PlayerX, PlayerY: TSporglooAPINumber);
    procedure onPlayerPutAStar(Const SessionID, PlayerID: TSporglooAPIAlpha16;
      Const NewStarX, NewStarY: TSporglooAPINumber);
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

procedure TConnectedClient.SetSocket(const Value: TSocket);
begin
  FSocket := Value;
end;

initialization

ClientsList := TThreadList<TConnectedClient>.Create;

finalization

FreeClientsList;

end.
