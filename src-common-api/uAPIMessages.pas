unit uAPIMessages;

interface

const
  CSportglooAPIMessageTerminator = 0;
  CSportglooBufferLength = 255;

type
  TSporglooAPINumber = int64;
  TSporglooAPIAlpha16 = array [0 .. 15] of byte;
  TSporglooAPIShort = byte;

  TSporglooAPIMessage = record
  private
    BufferPos: integer;
    procedure SetMessageID(const Value: TSporglooAPIShort);
    function GetMessageID: TSporglooAPIShort;
  public
    property MessageID: TSporglooAPIShort read GetMessageID write SetMessageID;
    procedure Reset;
    procedure Clear;
    procedure Push(O: byte);
    case byte of
      0:
        (Buffer: array [0 .. CSportglooBufferLength] of byte);
      1: // Client register
        (Msg1ID: TSporglooAPIShort; Msg1DeviceID: TSporglooAPIAlpha16);
      2: // Client register response
        (Msg2ID: TSporglooAPIShort;
          Msg2DeviceID, Msg2PlayerID: TSporglooAPIAlpha16);
      3: // Client login
        (Msg3ID: TSporglooAPIShort;
          Msg3DeviceID, Msg3PlayerID: TSporglooAPIAlpha16);
      4: // Client login response
        (Msg4ID: TSporglooAPIShort;
          Msg4DeviceID, Msg4SessionID: TSporglooAPIAlpha16;
          Msg4PlayerX, Msg4PlayerY: TSporglooAPINumber
          // TODO : add other player infos (score, etc)
        );
      5: // Map refresh
        (Msg5ID: TSporglooAPIShort;
          Msg5MapX, Msg5MapY, Msg5ColNumber, Msg5RowNumber: TSporglooAPINumber);
      6: // Map cell
        (Msg6ID: TSporglooAPIShort; Msg6MapX, Msg6MapY: TSporglooAPINumber;
          Msg6MapTileID: TSporglooAPIShort);
      7: // Player move
        (Msg7ID: TSporglooAPIShort;
          Msg7SessionID, Msg7PlayerID: TSporglooAPIAlpha16;
          Msg7PlayerX, Msg7PlayerY: TSporglooAPINumber);
      8: // Player move response
        (Msg8ID: TSporglooAPIShort;);
      9: // A player add a star
        (Msg9ID: TSporglooAPIShort;
          Msg9SessionID, Msg9PlayerID: TSporglooAPIAlpha16;
          Msg9NewStarX, Msg9NewStarY: TSporglooAPINumber);
      10: // Response to message 9
        (Msg10ID: TSporglooAPIShort;
          Msg10NewStarX, Msg10NewStarY: TSporglooAPINumber);
      11: // other player move
        (Msg11ID: TSporglooAPIShort; Msg11PlayerID: TSporglooAPIAlpha16;
          Msg11PlayerX, Msg11PlayerY: TSporglooAPINumber);
  end;

procedure Alpha16ToString(Const Source: TSporglooAPIAlpha16;
  var Destination: string);
procedure StringToAlpha16(Const Source: string;
  var Destination: TSporglooAPIAlpha16);

implementation

uses
  system.SysUtils;

{ TSporglooAPIMessage }

procedure TSporglooAPIMessage.Clear;
var
  i: integer;
begin
  for i := 0 to CSportglooBufferLength - 1 do
    Buffer[i] := 0;
end;

function TSporglooAPIMessage.GetMessageID: TSporglooAPIShort;
begin
  result := Buffer[0];
end;

procedure TSporglooAPIMessage.Push(O: byte);
begin
  inc(BufferPos);
  if (BufferPos >= SizeOf(Buffer)) then
    BufferPos := 0;
  Buffer[BufferPos] := O;
end;

procedure TSporglooAPIMessage.Reset;
begin
  BufferPos := 0;
end;

procedure TSporglooAPIMessage.SetMessageID(const Value: TSporglooAPIShort);
begin
  Buffer[0] := Value;
end;

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
    Destination[i] := 0;
    inc(i);
  end;
end;

end.
