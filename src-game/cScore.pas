unit cScore;

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
  Sporgloo.Images,
  Olf.FMX.TextImageFrame,
  FMX.ImgList;

type
  TcadScore = class(TFrame)
    Rectangle1: TRectangle;
    Glyph1: TGlyph;
    OlfFMXTextImageFrame1: TOlfFMXTextImageFrame;
    procedure FrameResized(Sender: TObject);
  private
    FScore: int64;
    procedure SetScore(const Value: int64);
  public
    property Score: int64 read FScore write SetScore;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  udmAdobeStock_257147901;

{ TcadScore }

constructor TcadScore.Create(AOwner: TComponent);
begin
  inherited;
  OlfFMXTextImageFrame1.Font := dmAdobeStock_257147901.ImageList;
  Score := 0;
end;

procedure TcadScore.FrameResized(Sender: TObject);
begin
  Glyph1.height := height - Glyph1.margins.left - Glyph1.margins.Right;
  Glyph1.width := Glyph1.height;
end;

procedure TcadScore.SetScore(const Value: int64);
begin
  FScore := Value;
  OlfFMXTextImageFrame1.Text := FScore.ToString;
  width := Glyph1.margins.left + Glyph1.width + Glyph1.margins.Right +
    OlfFMXTextImageFrame1.margins.left + OlfFMXTextImageFrame1.width +
    OlfFMXTextImageFrame1.margins.Right;
end;

end.
