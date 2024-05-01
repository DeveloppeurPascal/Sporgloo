unit Sporgloo.Types;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  Sporgloo.Consts;

type
  TSporglooAPINumber = int64;
  TSporglooAPIShort = byte;

  TSporglooMapCell = class
  private const
    CVersion = 1;

  var
    FTileID: TSporglooAPIShort;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    FPlayerID: string;
    FHasChanged: boolean;
    procedure SetHasChanged(const Value: boolean);
    procedure SetTileID(const Value: TSporglooAPIShort);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
    procedure SetPlayerID(const Value: string);
  protected
  public
    property HasChanged: boolean read FHasChanged write SetHasChanged;
    property X: TSporglooAPINumber read FX write SetX;
    property Y: TSporglooAPINumber read FY write SetY;
    property TileID: TSporglooAPIShort read FTileID write SetTileID;
    property PlayerID: string read FPlayerID write SetPlayerID;
    constructor Create; overload;
    constructor Create(X: TSporglooAPINumber; Y: TSporglooAPINumber;
      TileID: TSporglooAPIShort; PlayerID: string); overload;
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TSporglooChangedMapCellList = Tqueue<TSporglooMapCell>;

  TSporglooException = class(exception)
  private
    FErrorCode: TSporglooErrorCode;
    function GetErrorText: string;
  protected
  public
    property ErrorCode: TSporglooErrorCode read FErrorCode;
    property ErrorText: string read GetErrorText;
    constructor Create(const AErrorCode: TSporglooErrorCode;
      const AErrorText: string);
  end;

  TSporglooProjectType = (Client, Serveur, Inconnu);

var
  SporglooProjectType: TSporglooProjectType;

function GetUniqID(ASizeID: byte = CSporglooIDSize): string;
function GetNextChangedMapCell: TSporglooMapCell;

implementation

uses
  Sporgloo.API.Messages,
  Olf.RTL.Streams,
  uGameData,
  Sporgloo.Database;

var
  ChangedMapCellList: TSporglooChangedMapCellList;

function GetUniqID(ASizeID: byte): string;
var
  i: integer;
  LGuid: string;
begin
  result := '';
  LGuid := TGUID.NewGuid.ToString;
  for i := 0 to length(LGuid) - 1 do
  begin
    if CharInSet(LGuid.Chars[i], ['0' .. '9', 'A' .. 'Z', 'a' .. 'z']) then
    begin
      result := result + LGuid.Chars[i];
      if result.length = ASizeID then
        break;
    end;
  end;
end;

function GetNextChangedMapCell: TSporglooMapCell;
begin
  if (ChangedMapCellList.Count > 0) then
  begin
    result := ChangedMapCellList.Dequeue;
    if not result.HasChanged then
      result := nil;
  end
  else
    result := nil;
end;

{ TSporglooMapCell }

constructor TSporglooMapCell.Create(X, Y: TSporglooAPINumber;
  TileID: TSporglooAPIShort; PlayerID: string);
begin
  Create;
  FX := X;
  FY := Y;
  TileID := TileID;
  PlayerID := PlayerID;
end;

procedure TSporglooMapCell.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
begin
  System.tmonitor.Enter(self);
  try
    if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
      VersionNum := -1; // pas d'info de version, fichier de sauvegarde foireux

    if not((VersionNum >= 0) and (sizeof(FTileID) = AStream.read(FTileID,
      sizeof(FTileID)))) then
      FTileID := CSporglooTileNone;

    if not((VersionNum >= 0) and (sizeof(FX) = AStream.read(FX, sizeof(FX))))
    then
      FX := 0;

    if not((VersionNum >= 0) and (sizeof(FY) = AStream.read(FY, sizeof(FY))))
    then
      FY := 0;

    if not(VersionNum >= 0) then
      FPlayerID := ''
    else
      PlayerID := LoadStringFromStream(AStream);
  finally
    System.tmonitor.Exit(self);
  end;
end;

constructor TSporglooMapCell.Create;
begin
  inherited;
  FX := 0;
  FY := 0;
  FTileID := 0;
  FPlayerID := '';
  FHasChanged := false;
end;

procedure TSporglooMapCell.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
begin
  System.tmonitor.Enter(self);
  try
    VersionNum := CVersion;
    AStream.Write(VersionNum, sizeof(VersionNum));
    AStream.Write(FTileID, sizeof(FTileID));
    AStream.Write(FX, sizeof(FX));
    AStream.Write(FY, sizeof(FY));
    SaveStringToStream(FPlayerID, AStream);
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooMapCell.SetHasChanged(const Value: boolean);
begin
  FHasChanged := Value;
  if SporglooProjectType = TSporglooProjectType.Serveur then
    ChangedMapCellList.enqueue(self);
end;

procedure TSporglooMapCell.SetPlayerID(const Value: string);
var
  player: TSporglooPlayer;
  Players: TSporglooPlayersList;
begin
  if (FPlayerID <> Value) then
  begin
    if SporglooProjectType = TSporglooProjectType.Client then
    begin
      Players := TGameData.Current.OtherPlayers;
      if assigned(Players) then
      begin
        player := Players.GetPlayer(Value);
        if assigned(player) then
        begin
          player.PlayerX := FX;
          player.Playery := FY;
        end
        else
        begin
          player := TSporglooPlayer.Create;
          player.PlayerID := Value;
          player.PlayerX := FX;
          player.Playery := FY;
          Players.add(Value, player);
        end;
      end;
    end;
    FPlayerID := Value;
    HasChanged := true;
  end;
end;

procedure TSporglooMapCell.SetTileID(const Value: TSporglooAPIShort);
begin
  if (FTileID <> Value) then
  begin
    FTileID := Value;
    HasChanged := true;
  end;
end;

procedure TSporglooMapCell.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TSporglooMapCell.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

{ TSporglooException }

constructor TSporglooException.Create(const AErrorCode: TSporglooErrorCode;
  const AErrorText: string);
begin
  inherited Create(AErrorText);
  FErrorCode := AErrorCode;
end;

function TSporglooException.GetErrorText: string;
begin
  result := Message;
end;

initialization

randomize;
SporglooProjectType := TSporglooProjectType.Inconnu;
ChangedMapCellList := TSporglooChangedMapCellList.Create;
// TODO : change Queue Capacity if needed

finalization

ChangedMapCellList.free;

end.
