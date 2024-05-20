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
  FMX.ImgList,
  Olf.FMX.TextImageFrame,
  FMX.Objects;

type
  TcadLifeLevel = class(TFrame)
    Rectangle1: TRectangle;
    OlfFMXTextImageFrame1: TOlfFMXTextImageFrame;
    Image1: TImage;
    procedure FrameResized(Sender: TObject);
  private
    FLifeLevel: int64;
    procedure SetLifeLevel(const Value: int64);
  public
    procedure RefreshImage;
    procedure AfterConstruction; override;
    property LifeLevel: int64 read FLifeLevel write SetLifeLevel;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  udmAdobeStock_257147901,
  Olf.Skia.SVGToBitmap,
  USVGItems;

{ TFrame1 }

procedure TcadLifeLevel.AfterConstruction;
begin
  inherited;

  tthread.forcequeue(nil,
    procedure
    begin
      RefreshImage;
    end);
end;

constructor TcadLifeLevel.Create(AOwner: TComponent);
begin
  inherited;
  OlfFMXTextImageFrame1.Font := dmAdobeStock_257147901.ImageList;
  LifeLevel := 0;
end;

procedure TcadLifeLevel.FrameResized(Sender: TObject);
begin
  Image1.height := height - Image1.margins.left - Image1.margins.Right;
  Image1.Width := Image1.height;
  RefreshImage;
end;

procedure TcadLifeLevel.RefreshImage;
var
  bmp: tbitmap;
begin
  bmp := SVGToBitmap(round(Image1.Width), round(Image1.height),
    SVGItems[CSVGCoeur], Image1.Bitmap.bitmapscale);
  try
    Image1.Bitmap.Assign(bmp);
  finally
    bmp.free;
  end;
end;

procedure TcadLifeLevel.SetLifeLevel(const Value: int64);
begin
  FLifeLevel := Value;
  OlfFMXTextImageFrame1.Text := FLifeLevel.ToString;
  Width := Image1.margins.left + Image1.Width + Image1.margins.Right +
    OlfFMXTextImageFrame1.margins.left + OlfFMXTextImageFrame1.Width +
    OlfFMXTextImageFrame1.margins.Right;
end;

end.
