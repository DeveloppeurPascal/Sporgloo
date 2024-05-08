unit cLifeLevel;

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
  Sporgloo.Images,
  FMX.ImgList,
  Olf.FMX.TextImageFrame,
  FMX.Objects;

type
  TcadLifeLevel = class(TFrame)
    Rectangle1: TRectangle;
    OlfFMXTextImageFrame1: TOlfFMXTextImageFrame;
    Glyph1: TGlyph;
    procedure FrameResized(Sender: TObject);
  private
    FLifeLevel: int64;
    procedure SetLifeLevel(const Value: int64);
  public
    property LifeLevel: int64 read FLifeLevel write SetLifeLevel;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  udmAdobeStock_257147901;

{ TFrame1 }

constructor TcadLifeLevel.Create(AOwner: TComponent);
begin
  inherited;
  OlfFMXTextImageFrame1.Font := dmAdobeStock_257147901.ImageList;
  LifeLevel := 0;
end;

procedure TcadLifeLevel.FrameResized(Sender: TObject);
begin
  Glyph1.height := height - Glyph1.margins.left - Glyph1.margins.Right;
  Glyph1.width := Glyph1.height;
end;

procedure TcadLifeLevel.SetLifeLevel(const Value: int64);
begin
  FLifeLevel := Value;
  OlfFMXTextImageFrame1.Text := FLifeLevel.ToString;
  width := Glyph1.margins.left + Glyph1.width + Glyph1.margins.Right +
    OlfFMXTextImageFrame1.margins.left + OlfFMXTextImageFrame1.width +
    OlfFMXTextImageFrame1.margins.Right;
end;

end.
