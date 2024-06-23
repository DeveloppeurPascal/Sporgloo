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
    CVersion = 3;

  var
    FTileID: TSporglooAPIShort;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    FPlayerID: string;
    FHasChanged: boolean;
    FLivesCount: TSporglooAPINumber;
    FCoinsCount: TSporglooAPINumber;
    FStarsCount: TSporglooAPINumber;
    FPlayerImageID: integer;
    procedure SetCoinsCount(const Value: TSporglooAPINumber);
    procedure SetLivesCount(const Value: TSporglooAPINumber);
    procedure SetPlayerImageID(const Value: integer);
    procedure SetStarsCount(const Value: TSporglooAPINumber);
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
    property PlayerImageID: integer read FPlayerImageID write SetPlayerImageID;
    property CoinsCount: TSporglooAPINumber read FCoinsCount
      write SetCoinsCount;
    property LivesCount: TSporglooAPINumber read FLivesCount
      write SetLivesCount;
    property StarsCount: TSporglooAPINumber read FStarsCount
      write SetStarsCount;
    constructor Create; overload;
    constructor Create(AX: TSporglooAPINumber; AY: TSporglooAPINumber;
      ATileID: TSporglooAPIShort; APlayerID: string); overload;
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

constructor TSporglooMapCell.Create(AX, AY: TSporglooAPINumber;
  ATileID: TSporglooAPIShort; APlayerID: string);
begin
  Create;
  FX := AX;
  FY := AY;
  TileID := ATileID;
  PlayerID := APlayerID;
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
      FTileID := CSporglooTileForest;

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

    if not((VersionNum >= 3) and (sizeof(FLivesCount) = AStream.
      read(FLivesCount, sizeof(FLivesCount)))) then
      FLivesCount := 0;

    if not((VersionNum >= 3) and (sizeof(FCoinsCount) = AStream.
      read(FCoinsCount, sizeof(FCoinsCount)))) then
      FCoinsCount := 0;

    if not((VersionNum >= 3) and (sizeof(FStarsCount) = AStream.
      read(FStarsCount, sizeof(FStarsCount)))) then
      FStarsCount := 0;

    if not((VersionNum >= 3) and (sizeof(FPlayerImageID) = AStream.
      read(FPlayerImageID, sizeof(FPlayerImageID)))) then
      FPlayerImageID := -1;
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
  FLivesCount := 0;
  FCoinsCount := 0;
  FStarsCount := 0;
  FPlayerImageID := -1;
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
    AStream.Write(FLivesCount, sizeof(FLivesCount));
    AStream.Write(FCoinsCount, sizeof(FCoinsCount));
    AStream.Write(FStarsCount, sizeof(FStarsCount));
    AStream.Write(FPlayerImageID, sizeof(FPlayerImageID));
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooMapCell.SetCoinsCount(const Value: TSporglooAPINumber);
begin
  if (FCoinsCount <> Value) then
  begin
    FCoinsCount := Value;
    HasChanged := true;
  end;
end;

procedure TSporglooMapCell.SetHasChanged(const Value: boolean);
begin
  FHasChanged := Value;
  if SporglooProjectType = TSporglooProjectType.Serveur then
    ChangedMapCellList.enqueue(self);
end;

procedure TSporglooMapCell.SetLivesCount(const Value: TSporglooAPINumber);
begin
  if (FLivesCount <> Value) then
  begin
    FLivesCount := Value;
    HasChanged := true;
  end;
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
          TGameData.Current.GetInfosPlayer(player.PlayerID);
        end;
      end;
    end;
    FPlayerID := Value;
    HasChanged := true;
  end;
end;

procedure TSporglooMapCell.SetPlayerImageID(const Value: integer);
begin
  if (FPlayerImageID <> Value) then
  begin
    FPlayerImageID := Value;
    HasChanged := true;
  end;
end;

procedure TSporglooMapCell.SetStarsCount(const Value: TSporglooAPINumber);
begin
  if (FStarsCount <> Value) then
  begin
    FStarsCount := Value;
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
