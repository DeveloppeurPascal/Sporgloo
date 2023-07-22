unit Sporgloo.Types;

interface

type
  TSporglooAPINumber = int64;
  TSporglooAPIAlpha16 = array [0 .. 15] of byte;
  TSporglooAPIShort = byte;

procedure Alpha16ToString(Const Source: TSporglooAPIAlpha16;
  var Destination: string);
procedure StringToAlpha16(Const Source: string;
  var Destination: TSporglooAPIAlpha16);

function GetUniqID: string;

implementation

uses
  System.SysUtils,
  Sporgloo.API.Messages,
  Sporgloo.Consts;

procedure Alpha16ToString(Const Source: TSporglooAPIAlpha16;
  var Destination: string);
var
  i: integer;
begin
  Destination := '';
  for i := 0 to SizeOf(TSporglooAPIAlpha16) - 1 do
    Destination := Destination + chr(Source[i]);
end;

procedure StringToAlpha16(Const Source: string;
  var Destination: TSporglooAPIAlpha16);
var
  i: integer;
begin
  i := 0;
  while (i < Source.length) and (i < SizeOf(TSporglooAPIAlpha16)) do
  begin
    Destination[i] := ord(Source.Chars[i]);
    inc(i);
  end;
  while (i < SizeOf(TSporglooAPIAlpha16)) do
  begin
    Destination[i] := CSporglooAPIMessageTerminator;
    inc(i);
  end;
end;

function GetUniqID: string;
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
      if result.length = SizeOf(TSporglooAPIAlpha16) then
        break;
    end;
  end;
end;

initialization

randomize;

finalization

end.
