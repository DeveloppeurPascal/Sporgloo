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
  protected
    FSocket: Tsocket;
    procedure Execute; override;
    procedure ReceivedAPIMessage(Const Msg: TSporglooAPIMessage);
    procedure SendAPIMessage(Const Msg: TSporglooAPIMessage);

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

    procedure SendClientRegister(Const DeviceID: string;
      var Msg: TSporglooAPIMessage);
    procedure SendClientLogin(Const DeviceID, PlayerID: string;
      var Msg: TSporglooAPIMessage);
    procedure SendMapRefresh(Const MapX, MapY, ColNumber,
      RowNumber: TSporglooAPINumber; var Msg: TSporglooAPIMessage);
    procedure SendPlayerMove(Const SessionID, PlayerID: string;
      Const PlayerX, PlayerY: TSporglooAPINumber; var Msg: TSporglooAPIMessage);
    procedure SendPlayerPutAStar(Const SessionID, PlayerID: string;
      Const NewStarX, NewStarY: TSporglooAPINumber;
      var Msg: TSporglooAPIMessage);
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
  Msg: TSporglooAPIMessage;
  i: integer;
begin
  NameThreadForDebugging('SporglooAPIClient');
  FSocket := Tsocket.Create(tsockettype.tcp, tencoding.UTF8);
  try
    FSocket.Connect('', FIP, '', FPort);
    try
      Msg.Reset;
      if (tsocketstate.connected in FSocket.State) then
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

procedure TSporglooAPIClient.ReceivedAPIMessage(const Msg: TSporglooAPIMessage);
begin
  case Msg.MessageID of
    2:
      onClientRegisterResponse(Msg.Msg2DeviceID, Msg.Msg2PlayerID);
    4:
      onClientLoginResponse(Msg.Msg4DeviceID, Msg.Msg4SessionID,
        Msg.Msg4PlayerX, Msg.Msg4PlayerY);
    6:
      onMapCell(Msg.Msg6MapX, Msg.Msg6MapY, Msg.Msg6MapTileID);
    8:
      onPlayerMoveResponse;
    10:
      onPlayerPutAStarResponse(Msg.Msg10NewStarX, Msg.Msg10NewStarY);
    11:
      onOtherPlayerMove(Msg.Msg11PlayerID, Msg.Msg11PlayerX, Msg.Msg11PlayerY);
  else
    raise Exception.Create('Message ' + Msg.MessageID.Tostring +
      ' received by the game.');
  end;
end;

procedure TSporglooAPIClient.SendAPIMessage(const Msg: TSporglooAPIMessage);
begin
  // TODO : à compléter
end;

procedure TSporglooAPIClient.SendClientLogin(const DeviceID, PlayerID: string;
  var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 3;
  StringToAlpha16(DeviceID, Msg.Msg3DeviceID);
  StringToAlpha16(PlayerID, Msg.Msg3PlayerID);
  SendAPIMessage(Msg);
end;

procedure TSporglooAPIClient.SendClientRegister(const DeviceID: string;
  var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 1;
  StringToAlpha16(DeviceID, Msg.Msg1DeviceID);
  SendAPIMessage(Msg);
end;

procedure TSporglooAPIClient.SendMapRefresh(const MapX, MapY, ColNumber,
  RowNumber: TSporglooAPINumber; var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 5;
  Msg.Msg5MapX := MapX;
  Msg.Msg5MapY := MapY;
  Msg.Msg5ColNumber := ColNumber;
  Msg.Msg5RowNumber := RowNumber;
  SendAPIMessage(Msg);
end;

procedure TSporglooAPIClient.SendPlayerMove(const SessionID, PlayerID: string;
  const PlayerX, PlayerY: TSporglooAPINumber; var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 7;
  StringToAlpha16(SessionID, Msg.Msg7SessionID);
  StringToAlpha16(PlayerID, Msg.Msg7PlayerID);
  Msg.Msg7PlayerX := PlayerX;
  Msg.Msg7Playery := PlayerY;
  SendAPIMessage(Msg);
end;

procedure TSporglooAPIClient.SendPlayerPutAStar(const SessionID,
  PlayerID: string; const NewStarX, NewStarY: TSporglooAPINumber;
  var Msg: TSporglooAPIMessage);
begin
  Msg.Clear;
  Msg.MessageID := 9;
  StringToAlpha16(SessionID, Msg.Msg9SessionID);
  StringToAlpha16(PlayerID, Msg.Msg9PlayerID);
  Msg.Msg9NewStarX := NewStarX;
  Msg.Msg9NewStarY := NewStarY;
  SendAPIMessage(Msg);
end;

end.
