unit Sporgloo.Types;

interface

uses
  Sporgloo.Consts;

type
  TSporglooAPINumber = int64;
  TSporglooAPIShort = byte;

  TSporglooMapCell = class
  private
    FTileID: TSporglooAPIShort;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    procedure SetTileID(const Value: TSporglooAPIShort);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
  protected
  public
    property X: TSporglooAPINumber read FX write SetX;
    property Y: TSporglooAPINumber read FY write SetY;
    property TileID: TSporglooAPIShort read FTileID write SetTileID;
    constructor Create(X: TSporglooAPINumber; Y: TSporglooAPINumber;
      TileID: TSporglooAPIShort);
  end;

function GetUniqID(ASizeID: byte = CSporglooIDSize): string;

implementation

uses
  System.SysUtils,
  Sporgloo.API.Messages;

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

{ TSporglooMapCell }

constructor TSporglooMapCell.Create(X, Y: TSporglooAPINumber;
  TileID: TSporglooAPIShort);
begin
  FX := X;
  FY := Y;
  FTileID := TileID;
end;

procedure TSporglooMapCell.SetTileID(const Value: TSporglooAPIShort);
begin
  FTileID := Value;
end;

procedure TSporglooMapCell.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TSporglooMapCell.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

initialization

randomize;

finalization

end.
