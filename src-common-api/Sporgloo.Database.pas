unit Sporgloo.Database;

interface

uses
  System.Classes,
  System.Generics.Collections,
  Sporgloo.Types;

type
  TSporglooPlayer = class
  private
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
  private
  protected
  public
    function GetPlayerByDevice(ADeviceID: string): TSporglooPlayer;
    function GetPlayer(APlayerID: string): TSporglooPlayer;

    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TSporglooMapRow = TDictionary<TSporglooAPINumber, TSporglooAPIshort>;
  TSporglooMapCol = TObjectDictionary<TSporglooAPINumber, TSporglooMapRow>;

  TSporglooMap = class
  private
  protected
    FCell: TSporglooMapCol;
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
    FPlayerID: string;
    FMapRangeRowNumber: TSporglooAPINumber;
    FMapRangeX: TSporglooAPINumber;
    FMapRangeY: TSporglooAPINumber;
    FDeviceID: string;
    FMapRangeXMax: TSporglooAPINumber;
    FMapRangeYMax: TSporglooAPINumber;
    procedure SetDeviceID(const Value: string);
    procedure SetMapRangeColNumber(const Value: TSporglooAPINumber);
    procedure SetMapRangeRowNumber(const Value: TSporglooAPINumber);
    procedure SetMapRangeX(const Value: TSporglooAPINumber);
    procedure SetMapRangeY(const Value: TSporglooAPINumber);
    procedure SetPlayerID(const Value: string);
    procedure SetSessionID(const Value: string);
  protected
  public
    property DeviceID: string read FDeviceID write SetDeviceID;
    property PlayerID: string read FPlayerID write SetPlayerID;
    property SessionID: string read FSessionID write SetSessionID;
    property MapRangeX: TSporglooAPINumber read FMapRangeX write SetMapRangeX;
    property MapRangeY: TSporglooAPINumber read FMapRangeY write SetMapRangeY;
    property MapRangeColNumber: TSporglooAPINumber read FMapRangeColNumber
      write SetMapRangeColNumber;
    property MapRangeRowNumber: TSporglooAPINumber read FMapRangeRowNumber
      write SetMapRangeRowNumber;
    property MapRangeXMax: TSporglooAPINumber read FMapRangeXMax;
    property MapRangeYMax: TSporglooAPINumber read FMapRangeYMax;
    constructor Create;
  end;

  TSporglooSessionsList = class(TObjectDictionary<string, TSporglooSession>)
  private
  protected
  public
  end;

implementation

{ TSporglooPlayer }

procedure TSporglooPlayer.LoadFromStream(AStream: TStream);
begin
  // TODO : à compléter
end;

procedure TSporglooPlayer.SaveToStream(AStream: TStream);
begin
  // TODO : à compléter
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
begin
  // TODO : à compléter
end;

procedure TSporglooPlayersList.SaveToStream(AStream: TStream);
begin
  // TODO : à compléter
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
begin
  // TODO : à compléter
end;

procedure TSporglooMap.SaveToStream(AStream: TStream);
begin
  // TODO : à compléter
end;

procedure TSporglooMap.SetTileID(X, Y: TSporglooAPINumber;
  TileID: TSporglooAPIshort);
var
  LRow: TSporglooMapRow;
begin
  if (not FCell.TryGetValue(X, LRow)) then
  begin
    LRow := TSporglooMapRow.Create;
    FCell.Add(X, LRow);
  end;
  LRow.AddOrSetValue(Y, TileID);
end;

{ TSporglooSession }

constructor TSporglooSession.Create;
begin
  FDeviceID := '';
  FPlayerID := '';
  FSessionID := '';
  FMapRangeX := 0;
  FMapRangeY := 0;
  FMapRangeColNumber := 0;
  FMapRangeRowNumber := 0;
  FMapRangeXMax := 0;
  FMapRangeYMax := 0;
end;

procedure TSporglooSession.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
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

procedure TSporglooSession.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TSporglooSession.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

end.
