unit Sporgloo.Database;

interface

uses
  System.Classes,
  System.Generics.Collections,
  Sporgloo.Types,
  Olf.Net.Socket.Messaging;

type
  TSporglooPlayer = class
  private const
    CVersion = 1;

  var
    FLifeLevel: TSporglooAPINumber;
    FScore: TSporglooAPINumber;
    FPlayerID: string;
    FPlayerX: TSporglooAPINumber;
    FPlayerY: TSporglooAPINumber;
    FStarsCount: TSporglooAPINumber;
    FDeviceID: string;
    procedure SetDeviceID(const Value: string);
    procedure SetLifeLevel(const Value: TSporglooAPINumber);
    procedure SetPlayerID(const Value: string);
    procedure SetPlayerX(const Value: TSporglooAPINumber);
    procedure SetPlayerY(const Value: TSporglooAPINumber);
    procedure SetScore(const Value: TSporglooAPINumber);
    procedure SetStarsCount(const Value: TSporglooAPINumber);
  protected
  public
    property DeviceID: string read FDeviceID write SetDeviceID;
    property PlayerID: string read FPlayerID write SetPlayerID;
    property PlayerX: TSporglooAPINumber read FPlayerX write SetPlayerX;
    property PlayerY: TSporglooAPINumber read FPlayerY write SetPlayerY;
    Property Score: TSporglooAPINumber read FScore write SetScore;
    property StarsCount: TSporglooAPINumber read FStarsCount
      write SetStarsCount;
    property LifeLevel: TSporglooAPINumber read FLifeLevel write SetLifeLevel;

    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TSporglooPlayersList = class(TObjectDictionary<string, TSporglooPlayer>)
  private const
    CVersion = 1;
  protected
  public
    function GetPlayerByDevice(ADeviceID: string): TSporglooPlayer;
    function GetPlayer(APlayerID: string): TSporglooPlayer;

    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TSporglooMapRow = class(TDictionary<TSporglooAPINumber, TSporglooAPIshort>)
  private const
    CVersion = 1;
  protected
  public
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TSporglooMapCol = class(TObjectDictionary<TSporglooAPINumber,
    TSporglooMapRow>)
  private const
    CVersion = 1;
  protected
  public
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TSporglooMap = class
  private const
    CVersion = 1;

  var
    FCell: TSporglooMapCol;
  protected
  public
    function GetTileID(X, Y: TSporglooAPINumber): TSporglooAPIshort;
    procedure SetTileID(X, Y: TSporglooAPINumber; TileID: TSporglooAPIshort);

    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);

    constructor Create;
    destructor Destroy; override;
  end;

  TSporglooSession = class
  private
    FMapRangeColNumber: TSporglooAPINumber;
    FSessionID: string;
    FMapRangeRowNumber: TSporglooAPINumber;
    FMapRangeX: TSporglooAPINumber;
    FMapRangeY: TSporglooAPINumber;
    FMapRangeXMax: TSporglooAPINumber;
    FMapRangeYMax: TSporglooAPINumber;
    FSocketClient: TOlfSocketMessagingServerConnectedClient;
    FPlayer: TSporglooPlayer;
    procedure SetMapRangeColNumber(const Value: TSporglooAPINumber);
    procedure SetMapRangeRowNumber(const Value: TSporglooAPINumber);
    procedure SetMapRangeX(const Value: TSporglooAPINumber);
    procedure SetMapRangeY(const Value: TSporglooAPINumber);
    procedure SetSessionID(const Value: string);
    procedure SetSocketClient(const Value
      : TOlfSocketMessagingServerConnectedClient);
    procedure SetPlayer(const Value: TSporglooPlayer);
  protected
  public
    property SessionID: string read FSessionID write SetSessionID;
    property SocketClient: TOlfSocketMessagingServerConnectedClient
      read FSocketClient write SetSocketClient;
    property MapRangeX: TSporglooAPINumber read FMapRangeX write SetMapRangeX;
    property MapRangeY: TSporglooAPINumber read FMapRangeY write SetMapRangeY;
    property MapRangeColNumber: TSporglooAPINumber read FMapRangeColNumber
      write SetMapRangeColNumber;
    property MapRangeRowNumber: TSporglooAPINumber read FMapRangeRowNumber
      write SetMapRangeRowNumber;
    property MapRangeXMax: TSporglooAPINumber read FMapRangeXMax;
    property MapRangeYMax: TSporglooAPINumber read FMapRangeYMax;
    property Player: TSporglooPlayer read FPlayer write SetPlayer;
    constructor Create;
    destructor Destroy; override;
  end;

  TSporglooSessionsList = class(TObjectDictionary<string, TSporglooSession>)
  private
  protected
  public
  end;

implementation

{ TSporglooPlayer }

uses
  Olf.RTL.Streams,
  Sporgloo.API.Messages;

procedure TSporglooPlayer.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
begin
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1; // pas d'info de version, fichier de sauvegarde foireux

  if not((VersionNum >= 0) and (sizeof(FLifeLevel) = AStream.read(FLifeLevel,
    sizeof(FLifeLevel)))) then
    FLifeLevel := 0;

  if not((VersionNum >= 0) and (sizeof(FScore) = AStream.read(FScore,
    sizeof(FScore)))) then
    FScore := 0;

  if not(VersionNum >= 0) then
    FPlayerID := ''
  else
    FPlayerID := LoadStringFromStream(AStream);

  if not((VersionNum >= 0) and (sizeof(FPlayerX) = AStream.read(FPlayerX,
    sizeof(FPlayerX)))) then
    FPlayerX := 0;

  if not((VersionNum >= 0) and (sizeof(FPlayerY) = AStream.read(FPlayerY,
    sizeof(FPlayerY)))) then
    FPlayerY := 0;

  if not((VersionNum >= 0) and (sizeof(FStarsCount) = AStream.read(FStarsCount,
    sizeof(FStarsCount)))) then
    FStarsCount := 0;

  if not(VersionNum >= 0) then
    FDeviceID := ''
  else
    FDeviceID := LoadStringFromStream(AStream);
end;

procedure TSporglooPlayer.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  AStream.Write(FLifeLevel, sizeof(FLifeLevel));
  AStream.Write(FScore, sizeof(FScore));
  SaveStringToStream(FPlayerID, AStream);
  AStream.Write(FPlayerX, sizeof(FPlayerX));
  AStream.Write(FPlayerY, sizeof(FPlayerY));
  AStream.Write(FStarsCount, sizeof(FStarsCount));
  SaveStringToStream(FDeviceID, AStream);
end;

procedure TSporglooPlayer.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TSporglooPlayer.SetLifeLevel(const Value: TSporglooAPINumber);
begin
  FLifeLevel := Value;
end;

procedure TSporglooPlayer.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TSporglooPlayer.SetPlayerX(const Value: TSporglooAPINumber);
begin
  FPlayerX := Value;
end;

procedure TSporglooPlayer.SetPlayerY(const Value: TSporglooAPINumber);
begin
  FPlayerY := Value;
end;

procedure TSporglooPlayer.SetScore(const Value: TSporglooAPINumber);
begin
  FScore := Value;
end;

procedure TSporglooPlayer.SetStarsCount(const Value: TSporglooAPINumber);
begin
  FStarsCount := Value;
end;

{ TSporglooPlayersList }

function TSporglooPlayersList.GetPlayer(APlayerID: string): TSporglooPlayer;
begin
  if not TryGetValue(APlayerID, result) then
    result := nil;
end;

function TSporglooPlayersList.GetPlayerByDevice(ADeviceID: string)
  : TSporglooPlayer;
var
  key: string;
begin
  result := nil;
  if (Count > 0) then
    for key in keys do
      if items[key].DeviceID = ADeviceID then
      begin
        result := items[key];
        break;
      end;
end;

procedure TSporglooPlayersList.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  Player: TSporglooPlayer;
begin
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1; // pas d'info de version, fichier de sauvegarde foireux

  if not((VersionNum >= 0) and (sizeof(nb) = AStream.read(nb, sizeof(nb)))) then
    nb := 0;

  while (nb > 0) do
  begin
    Player := TSporglooPlayer.Create;
    Player.LoadFromStream(AStream);
    add(Player.PlayerID, Player);
    dec(nb);
  end;
end;

procedure TSporglooPlayersList.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  LKey: string;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  nb := Count;
  AStream.Write(nb, sizeof(nb));
  for LKey in keys do
    items[LKey].SaveToStream(AStream);
end;

{ TSporglooMap }

constructor TSporglooMap.Create;
begin
  FCell := TSporglooMapCol.Create([doOwnsValues]);
end;

destructor TSporglooMap.Destroy;
begin
  FCell.Free;
  inherited;
end;

function TSporglooMap.GetTileID(X, Y: TSporglooAPINumber): TSporglooAPIshort;
var
  FRow: TSporglooMapRow;
begin
  if (not FCell.TryGetValue(X, FRow)) or (not FRow.TryGetValue(Y, result)) then
    result := 0;
end;

procedure TSporglooMap.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
begin
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1; // pas d'info de version, fichier de sauvegarde foireux

  if not(VersionNum >= 0) then
    FCell.Clear
  else
    FCell.LoadFromStream(AStream);
end;

procedure TSporglooMap.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  FCell.SaveToStream(AStream);
end;

procedure TSporglooMap.SetTileID(X, Y: TSporglooAPINumber;
  TileID: TSporglooAPIshort);
var
  LRow: TSporglooMapRow;
begin
  if (not FCell.TryGetValue(X, LRow)) then
  begin
    LRow := TSporglooMapRow.Create;
    FCell.add(X, LRow);
  end;
  LRow.AddOrSetValue(Y, TileID);
end;

{ TSporglooSession }

constructor TSporglooSession.Create;
begin
  FSessionID := '';
  FMapRangeX := 0;
  FMapRangeY := 0;
  FMapRangeColNumber := 0;
  FMapRangeRowNumber := 0;
  FMapRangeXMax := 0;
  FMapRangeYMax := 0;
  FSocketClient := nil;
  FPlayer := nil;
end;

destructor TSporglooSession.Destroy;
var
  msg: TLogoffMessage;
begin
  if assigned(FSocketClient) then
  begin
    msg := TLogoffMessage.Create;
    try
      FSocketClient.SendMessage(msg);
    finally
      msg.Free;
    end;
  end;
  inherited;
end;

procedure TSporglooSession.SetMapRangeColNumber(const Value
  : TSporglooAPINumber);
begin
  FMapRangeColNumber := Value;
  if FMapRangeColNumber > 0 then
    FMapRangeXMax := FMapRangeX + FMapRangeColNumber - 1
  else
    FMapRangeXMax := FMapRangeX;
end;

procedure TSporglooSession.SetMapRangeRowNumber(const Value
  : TSporglooAPINumber);
begin
  FMapRangeRowNumber := Value;
  if FMapRangeRowNumber > 0 then
    FMapRangeYMax := FMapRangeY + FMapRangeRowNumber - 1
  else
    FMapRangeYMax := FMapRangeY;
end;

procedure TSporglooSession.SetMapRangeX(const Value: TSporglooAPINumber);
begin
  FMapRangeX := Value;
  if FMapRangeColNumber > 0 then
    FMapRangeXMax := FMapRangeX + FMapRangeColNumber - 1
  else
    FMapRangeXMax := FMapRangeX;
end;

procedure TSporglooSession.SetMapRangeY(const Value: TSporglooAPINumber);
begin
  FMapRangeY := Value;
  if FMapRangeRowNumber > 0 then
    FMapRangeYMax := FMapRangeY + FMapRangeRowNumber - 1
  else
    FMapRangeYMax := FMapRangeY;
end;

procedure TSporglooSession.SetPlayer(const Value: TSporglooPlayer);
begin
  FPlayer := Value;
end;

procedure TSporglooSession.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TSporglooSession.SetSocketClient(const Value
  : TOlfSocketMessagingServerConnectedClient);
begin
  FSocketClient := Value;
end;

{ TSporglooMapRow }

procedure TSporglooMapRow.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  LKey: TSporglooAPINumber;
  LValue: TSporglooAPIshort;
begin
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1; // pas d'info de version, fichier de sauvegarde foireux

  if not((VersionNum >= 0) and (sizeof(nb) = AStream.read(nb, sizeof(nb)))) then
    nb := 0;

  Clear;
  while (nb > 0) do
  begin
    if not((VersionNum >= 0) and (sizeof(LKey) = AStream.read(LKey,
      sizeof(LKey)))) then
      LKey := 0;
    if not((VersionNum >= 0) and (sizeof(LValue) = AStream.read(LValue,
      sizeof(LValue)))) then
      LValue := 0;
    AddOrSetValue(LKey, LValue);
    dec(nb);
  end;
end;

procedure TSporglooMapRow.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  LKey: TSporglooAPINumber;
  LValue: TSporglooAPIshort;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  nb := Count;
  AStream.Write(nb, sizeof(nb));
  for LKey in keys do
  begin
    AStream.Write(LKey, sizeof(LKey));
    LValue := items[LKey];
    AStream.Write(LValue, sizeof(LValue));
  end;
end;

{ TSporglooMapCol }

procedure TSporglooMapCol.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  LKey: TSporglooAPINumber;
  LValue: TSporglooMapRow;
begin
  if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
    VersionNum := -1; // pas d'info de version, fichier de sauvegarde foireux

  if not((VersionNum >= 0) and (sizeof(nb) = AStream.read(nb, sizeof(nb)))) then
    nb := 0;

  Clear;
  while (nb > 0) do
  begin
    if not((VersionNum >= 0) and (sizeof(LKey) = AStream.read(LKey,
      sizeof(LKey)))) then
      LKey := 0;
    LValue := TSporglooMapRow.Create;
    LValue.LoadFromStream(AStream);
    AddOrSetValue(LKey, LValue);
    dec(nb);
  end;
end;

procedure TSporglooMapCol.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  LKey: TSporglooAPINumber;
begin
  VersionNum := CVersion;
  AStream.Write(VersionNum, sizeof(VersionNum));
  nb := Count;
  AStream.Write(nb, sizeof(nb));
  for LKey in keys do
  begin
    AStream.Write(LKey, sizeof(LKey));
    items[LKey].SaveToStream(AStream);
  end;
end;

end.
