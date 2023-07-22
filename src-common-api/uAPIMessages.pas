unit uAPIMessages;

interface

const
  CSportglooAPIMessageTerminator = 0;

type
  TSporglooAPINumber = int64;
  TSporglooAPIAlpha16 = array [0 .. 15] of byte;
  TSporglooAPIShort = byte;

  TSporglooAPIMessage = record
  private
    BufferPos: integer;
  public
    function MessageID: TSporglooAPIShort;
    procedure Reset;
    procedure Push(O: byte);
    case byte of
      0:
        (Buffer: array [0 .. 255] of byte);
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

implementation

{ TSporglooAPIMessage }

function TSporglooAPIMessage.MessageID: TSporglooAPIShort;
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

end.
