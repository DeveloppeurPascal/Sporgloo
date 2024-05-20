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
  Olf.FMX.TextImageFrame,
  FMX.ImgList;

type
  TcadScore = class(TFrame)
    Rectangle1: TRectangle;
    OlfFMXTextImageFrame1: TOlfFMXTextImageFrame;
    Image1: TImage;
    procedure FrameResized(Sender: TObject);
  private
    FScore: int64;
    procedure SetScore(const Value: int64);
  public
    procedure RefreshImage;
    procedure AfterConstruction; override;
    property Score: int64 read FScore write SetScore;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  udmAdobeStock_257147901,
  Olf.Skia.SVGToBitmap,
  USVGItems;

{ TcadScore }

procedure TcadScore.AfterConstruction;
begin
  inherited;

  tthread.forcequeue(nil,
    procedure
    begin
      RefreshImage;
    end);
end;

constructor TcadScore.Create(AOwner: TComponent);
begin
  inherited;
  OlfFMXTextImageFrame1.Font := dmAdobeStock_257147901.ImageList;
  Score := 0;
end;

procedure TcadScore.FrameResized(Sender: TObject);
begin
  Image1.height := height - Image1.margins.left - Image1.margins.Right;
  Image1.Width := Image1.height;
  RefreshImage;
end;

procedure TcadScore.RefreshImage;
var
  bmp: tbitmap;
begin
  bmp := SVGToBitmap(round(Image1.Width), round(Image1.height),
    SVGItems[CSVGJeton1], Image1.Bitmap.bitmapscale);
  try
    Image1.Bitmap.Assign(bmp);
  finally
    bmp.free;
  end;
end;

procedure TcadScore.SetScore(const Value: int64);
begin
  FScore := Value;
  OlfFMXTextImageFrame1.Text := FScore.ToString;
  Width := Image1.margins.left + Image1.Width + Image1.margins.Right +
    OlfFMXTextImageFrame1.margins.left + OlfFMXTextImageFrame1.Width +
    OlfFMXTextImageFrame1.margins.Right;
end;

end.
