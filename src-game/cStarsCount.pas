unit cStarsCount;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects,
  Olf.FMX.TextImageFrame,
  Sporgloo.Images,
  FMX.ImgList;

type
  TcadStarsCount = class(TFrame)
    Rectangle1: TRectangle;
    OlfFMXTextImageFrame1: TOlfFMXTextImageFrame;
    Glyph1: TGlyph;
    procedure FrameResized(Sender: TObject);
  private
    FStarsCount: int64;
    procedure SetStarsCount(const Value: int64);
  public
    property StarsCount: int64 read FStarsCount write SetStarsCount;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  udmAdobeStock_257147901;

{ TcadStarsCount }

constructor TcadStarsCount.Create(AOwner: TComponent);
begin
  inherited;
  OlfFMXTextImageFrame1.Font := dmAdobeStock_257147901.ImageList;
  StarsCount := 0;
end;

procedure TcadStarsCount.FrameResized(Sender: TObject);
begin
  Glyph1.height := height - Glyph1.margins.left - Glyph1.margins.Right;
  Glyph1.width := Glyph1.height;
end;

procedure TcadStarsCount.SetStarsCount(const Value: int64);
begin
  FStarsCount := Value;
  OlfFMXTextImageFrame1.Text := FStarsCount.ToString;
  width := Glyph1.margins.left + Glyph1.width + Glyph1.margins.Right +
    OlfFMXTextImageFrame1.margins.left + OlfFMXTextImageFrame1.width +
    OlfFMXTextImageFrame1.margins.Right;
end;

end.
