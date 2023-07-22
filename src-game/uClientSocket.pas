unit uClientSocket;

interface

uses
  System.Classes,
  System.net.Socket,
  uAPIMessages;

type
  TSporglooAPIClient = class(TThread)
  private
    FPort: word;
    FIP: string;
    FMsg: TSporglooAPIMessage;
  protected
    FSocket: Tsocket;
    procedure Execute; override;

    procedure ReceivedAPIMessage;
    procedure SendAPIMessage;

    procedure onClientRegisterResponse(Const DeviceID,
      PlayerID: TSporglooAPIAlpha16);
    procedure onClientLoginResponse(Const DeviceID,
      SessionID: TSporglooAPIAlpha16;
      Const PlayerX, PlayerY: TSporglooAPINumber);
    procedure onMapCell(Const MapX, MapY: TSporglooAPINumber;
      Const MapTileID: TSporglooAPIShort);
    procedure onPlayerMoveResponse;
    procedure onPlayerPutAStarResponse(Const NewStarX,
      NewStarY: TSporglooAPINumber);
    procedure onOtherPlayerMove(Const PlayerID: TSporglooAPIAlpha16;
      Const PlayerX, PlayerY: TSporglooAPINumber);

    procedure SendClientRegister(Const DeviceID: string);
    procedure SendClientLogin(Const DeviceID, PlayerID: string);
    procedure SendMapRefresh(Const MapX, MapY, ColNumber,
      RowNumber: TSporglooAPINumber);
    procedure SendPlayerMove(Const SessionID, PlayerID: string;
      Const PlayerX, PlayerY: TSporglooAPINumber);
    procedure SendPlayerPutAStar(Const SessionID, PlayerID: string;
      Const NewStarX, NewStarY: TSporglooAPINumber);
  public
    constructor Create(AIP: string; APort: word);
  end;

implementation

uses
  System.SysUtils;

{ TSporglooAPIClient }

constructor TSporglooAPIClient.Create(AIP: string; APort: word);
begin
  inherited Create(true);
  FIP := AIP;
  FPort := APort;
  FSocket := nil;
  FreeOnTerminate := true;
  resume;
end;

procedure TSporglooAPIClient.Execute;
var
  Buffer: TBytes;
  RecCount: integer;
  i: integer;
begin
  NameThreadForDebugging('SporglooAPIClient');
  FSocket := Tsocket.Create(tsockettype.tcp, tencoding.UTF8);
  try
    FSocket.Connect('', FIP, '', FPort);
    try
      FMsg.Reset;
      if (tsocketstate.connected in FSocket.State) then
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
        end
      else; // TODO : can't connect to the server
    finally
      FSocket.Close;
    end;
  finally
    freeandnil(FSocket);
  end;
end;

procedure TSporglooAPIClient.onClientLoginResponse(const DeviceID,
  SessionID: TSporglooAPIAlpha16; const PlayerX, PlayerY: TSporglooAPINumber);
begin
  // TODO : à compléter
end;

procedure TSporglooAPIClient.onClientRegisterResponse(const DeviceID,
  PlayerID: TSporglooAPIAlpha16);
begin
  // TODO : à compléter
end;

procedure TSporglooAPIClient.onMapCell(const MapX, MapY: TSporglooAPINumber;
  const MapTileID: TSporglooAPIShort);
begin
  // TODO : à compléter
end;

procedure TSporglooAPIClient.onOtherPlayerMove(const PlayerID
  : TSporglooAPIAlpha16; const PlayerX, PlayerY: TSporglooAPINumber);
begin
  // TODO : à compléter
end;

procedure TSporglooAPIClient.onPlayerMoveResponse;
begin
  // TODO : à compléter
end;

procedure TSporglooAPIClient.onPlayerPutAStarResponse(const NewStarX,
  NewStarY: TSporglooAPINumber);
begin
  // TODO : à compléter
end;

procedure TSporglooAPIClient.ReceivedAPIMessage;
begin
  case FMsg.MessageID of
    2:
      onClientRegisterResponse(FMsg.Msg2DeviceID, FMsg.Msg2PlayerID);
    4:
      onClientLoginResponse(FMsg.Msg4DeviceID, FMsg.Msg4SessionID,
        FMsg.Msg4PlayerX, FMsg.Msg4PlayerY);
    6:
      onMapCell(FMsg.Msg6MapX, FMsg.Msg6MapY, FMsg.Msg6MapTileID);
    8:
      onPlayerMoveResponse;
    10:
      onPlayerPutAStarResponse(FMsg.Msg10NewStarX, FMsg.Msg10NewStarY);
    11:
      onOtherPlayerMove(FMsg.Msg11PlayerID, FMsg.Msg11PlayerX,
        FMsg.Msg11PlayerY);
  else
    raise Exception.Create('Message ' + FMsg.MessageID.Tostring +
      ' received by the game.');
  end;
end;

procedure TSporglooAPIClient.SendAPIMessage;
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

procedure TSporglooAPIClient.SendClientLogin(const DeviceID, PlayerID: string);
begin
  FMsg.Clear;
  FMsg.MessageID := 3;
  StringToAlpha16(DeviceID, FMsg.Msg3DeviceID);
  StringToAlpha16(PlayerID, FMsg.Msg3PlayerID);
  SendAPIMessage;
end;

procedure TSporglooAPIClient.SendClientRegister(const DeviceID: string);
begin
  FMsg.Clear;
  FMsg.MessageID := 1;
  StringToAlpha16(DeviceID, FMsg.Msg1DeviceID);
  SendAPIMessage;
end;

procedure TSporglooAPIClient.SendMapRefresh(const MapX, MapY, ColNumber,
  RowNumber: TSporglooAPINumber);
begin
  FMsg.Clear;
  FMsg.MessageID := 5;
  FMsg.Msg5MapX := MapX;
  FMsg.Msg5MapY := MapY;
  FMsg.Msg5ColNumber := ColNumber;
  FMsg.Msg5RowNumber := RowNumber;
  SendAPIMessage;
end;

procedure TSporglooAPIClient.SendPlayerMove(const SessionID, PlayerID: string;
  const PlayerX, PlayerY: TSporglooAPINumber);
begin
  FMsg.Clear;
  FMsg.MessageID := 7;
  StringToAlpha16(SessionID, FMsg.Msg7SessionID);
  StringToAlpha16(PlayerID, FMsg.Msg7PlayerID);
  FMsg.Msg7PlayerX := PlayerX;
  FMsg.Msg7Playery := PlayerY;
  SendAPIMessage;
end;

procedure TSporglooAPIClient.SendPlayerPutAStar(const SessionID,
  PlayerID: string; const NewStarX, NewStarY: TSporglooAPINumber);
begin
  FMsg.Clear;
  FMsg.MessageID := 9;
  StringToAlpha16(SessionID, FMsg.Msg9SessionID);
  StringToAlpha16(PlayerID, FMsg.Msg9PlayerID);
  FMsg.Msg9NewStarX := NewStarX;
  FMsg.Msg9NewStarY := NewStarY;
  SendAPIMessage;
end;

end.
