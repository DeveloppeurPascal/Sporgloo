unit uClientSocket;

interface

uses
  System.Classes,
  System.net.Socket,
  Sporgloo.API.Messages,
  Sporgloo.Types;

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
      SessionID: TSporglooAPIAlpha16; Const PlayerX, PlayerY, Score, StarsCount,
      LifeLevel: TSporglooAPINumber);
    procedure onMapCell(Const MapX, MapY: TSporglooAPINumber;
      Const MapTileID: TSporglooAPIShort);
    procedure onPlayerMoveResponse;
    procedure onPlayerPutAStarResponse(Const NewStarX,
      NewStarY: TSporglooAPINumber);
    procedure onOtherPlayerMove(Const PlayerID: TSporglooAPIAlpha16;
      Const PlayerX, PlayerY: TSporglooAPINumber);
  public
    constructor Create(AIP: string; APort: word);

    procedure SendClientRegister(Const DeviceID: string);
    procedure SendClientLogin(Const DeviceID, PlayerID: string);
    procedure SendMapRefresh(Const MapX, MapY, ColNumber,
      RowNumber: TSporglooAPINumber);
    procedure SendPlayerMove(Const SessionID, PlayerID: string;
      Const PlayerX, PlayerY: TSporglooAPINumber);
    procedure SendPlayerPutAStar(Const SessionID, PlayerID: string;
      Const NewStarX, NewStarY: TSporglooAPINumber);

    function isConnected: boolean;
  end;

implementation

uses
  System.SysUtils,
  System.Messaging,
  uConfig,
  uGameData,
  Sporgloo.Database,
  Sporgloo.Consts,
  Sporgloo.Messaging;

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
{$IFDEF DEBUG}
  NameThreadForDebugging('SporglooAPIClient');
{$ENDIF}
  FSocket := Tsocket.Create(tsockettype.tcp, tencoding.UTF8);
  try
    FSocket.Connect('', FIP, '', FPort);
    try
      FMsg.Reset;
      if (tsocketstate.connected in FSocket.State) then
      begin
        TThread.Queue(nil,
          procedure
          begin
            TMessageManager.DefaultManager.SendMessage(Self,
              TServerConnectedMessage.Create(Self));
          end);
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
          end
          else
            sleep(100);
        end;
      end
      else
        TThread.Queue(nil,
          procedure
          begin
            TMessageManager.DefaultManager.SendMessage(Self,
              TLostServerMessage.Create(Self));
          end);
    finally
      FSocket.Close;
    end;
  finally
    TThread.Queue(nil,
      procedure
      begin
        TMessageManager.DefaultManager.SendMessage(Self,
          TLostServerMessage.Create(Self));
      end);
    freeandnil(FSocket);
  end;
end;

function TSporglooAPIClient.isConnected: boolean;
begin
  result := assigned(FSocket) and (tsocketstate.connected in FSocket.State);
end;

procedure TSporglooAPIClient.onClientLoginResponse(const DeviceID,
  SessionID: TSporglooAPIAlpha16; const PlayerX, PlayerY, Score, StarsCount,
  LifeLevel: TSporglooAPINumber);
var
  LDeviceID, LSessionID: string;
  LGameData: TGameData;
begin
  Alpha16ToString(DeviceID, LDeviceID);
  if (tconfig.Current.DeviceID <> LDeviceID) then
    raise exception.Create('Wrong DeviceID sent from the server.');

  Alpha16ToString(SessionID, LSessionID);
  if LSessionID.IsEmpty then
    raise exception.Create('No SessionID returned by the server.');

  LGameData := TGameData.Current;
  LGameData.Session.SessionID := LSessionID;
  LGameData.Player.PlayerX := PlayerX;
  LGameData.Player.PlayerY := PlayerY;
  LGameData.Player.Score := Score;
  LGameData.Player.StarsCount := StarsCount;
  LGameData.Player.LifeLevel := LifeLevel;

  LGameData.RefreshMap;
end;

procedure TSporglooAPIClient.onClientRegisterResponse(const DeviceID,
  PlayerID: TSporglooAPIAlpha16);
var
  LDeviceID, LPlayerID: string;
begin
  Alpha16ToString(DeviceID, LDeviceID);
  if (tconfig.Current.DeviceID <> LDeviceID) then
    raise exception.Create('Wrong DeviceID sent from the server.');

  Alpha16ToString(PlayerID, LPlayerID);
  if LPlayerID.IsEmpty then
    raise exception.Create('No PlayerID returned by the server.');

  tconfig.Current.PlayerID := LPlayerID;
  TGameData.Current.Player.PlayerID := LPlayerID;
  TGameData.Current.Session.PlayerID := LPlayerID;

  SendClientLogin(LDeviceID, LPlayerID);
end;

procedure TSporglooAPIClient.onMapCell(const MapX, MapY: TSporglooAPINumber;
const MapTileID: TSporglooAPIShort);
begin
  TGameData.Current.Map.SetTileID(MapX, MapY, MapTileID);
  TMessageManager.DefaultManager.SendMessage(Self,
    TMapCellUpdateMessage.Create(TSporglooMapCell.Create(MapX, MapY,
    MapTileID)));
end;

procedure TSporglooAPIClient.onOtherPlayerMove(const PlayerID
  : TSporglooAPIAlpha16; const PlayerX, PlayerY: TSporglooAPINumber);
var
  Player: TSporglooPlayer;
  LPlayerID: string;
begin
  Alpha16ToString(PlayerID, LPlayerID);
  if not TGameData.Current.OtherPlayers.TryGetValue(LPlayerID, Player) then
  begin
    Player := TSporglooPlayer.Create;
    Player.PlayerID := LPlayerID;
    TGameData.Current.OtherPlayers.add(LPlayerID, Player);
  end;
  Player.PlayerX := PlayerX;
  Player.PlayerY := PlayerY;
  // TODO : refresh the map cell
end;

procedure TSporglooAPIClient.onPlayerMoveResponse;
begin
  // TODO : register the playerx,playerY coordinates have been send to the server
end;

procedure TSporglooAPIClient.onPlayerPutAStarResponse(const NewStarX,
  NewStarY: TSporglooAPINumber);
begin
  // TODO : check if X,Y correspond to a "new star" sent
end;

procedure TSporglooAPIClient.ReceivedAPIMessage;
begin
  case FMsg.MessageID of
    2:
      onClientRegisterResponse(FMsg.Msg2DeviceID, FMsg.Msg2PlayerID);
    4:
      onClientLoginResponse(FMsg.Msg4DeviceID, FMsg.Msg4SessionID,
        FMsg.Msg4PlayerX, FMsg.Msg4PlayerY, FMsg.Msg4Score, FMsg.Msg4StarsCount,
        FMsg.Msg4LifeLevel);
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
    raise exception.Create('Message ' + FMsg.MessageID.Tostring +
      ' received by the game.');
  end;
end;

procedure TSporglooAPIClient.SendAPIMessage;
var
  TerminatorPosition: integer;
  SentBytes: word;
begin
  if not assigned(FSocket) then
    exit;

  if not(tsocketstate.connected in FSocket.State) then
    raise exception.Create('Server is not connected.');

  TerminatorPosition := 0;
  while (TerminatorPosition < CSporglooAPIBufferLength) and
    (FMsg.Buffer[TerminatorPosition] <> CSporglooAPIMessageTerminator) do
    inc(TerminatorPosition);

  if not(TerminatorPosition < CSporglooAPIBufferLength) then
    raise exception.Create('Wrong buffer size. Please increase it.');

  SentBytes := FSocket.Send(FMsg.Buffer, 0, TerminatorPosition + 1);
  if (SentBytes <> TerminatorPosition + 1) then
    raise exception.Create('Sending message ' + FMsg.MessageID.Tostring +
      ' error (' + SentBytes.Tostring + '/' + (TerminatorPosition + 1)
      .Tostring + ').');
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
