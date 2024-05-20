unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Objects;

type
  TTabString = array of string;
  PTabString = ^TTabString;

  TForm1 = class(TForm)
    Layout1: TLayout;
    btnUserInterface: TButton;
    btnBackgrounds: TButton;
    btnTrees: TButton;
    btnPersos: TButton;
    btnItems: TButton;
    Timer1: TTimer;
    Image1: TImage;
    btnStop: TButton;
    Layout2: TLayout;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBackgroundsClick(Sender: TObject);
    procedure btnItemsClick(Sender: TObject);
    procedure btnPersosClick(Sender: TObject);
    procedure btnTreesClick(Sender: TObject);
    procedure btnUserInterfaceClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure Image1Resize(Sender: TObject);
  private
    { Déclarations privées }
  public
    PTabSVG: PTabString;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.skia,
  FMX.skia,
  USVGBackgrounds,
  USVGItems,
  USVGPersos,
  USVGTrees,
  USVGUserInterface;

procedure TForm1.btnBackgroundsClick(Sender: TObject);
begin
  PTabSVG := @SVGBackgrounds;
  Timer1.Enabled := true;
end;

procedure TForm1.btnItemsClick(Sender: TObject);
begin
  PTabSVG := @SVGItems;
  Timer1.Enabled := true;
end;

procedure TForm1.btnPersosClick(Sender: TObject);
begin
  PTabSVG := @SVGPersos;
  Timer1.Enabled := true;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TForm1.btnTreesClick(Sender: TObject);
begin
  PTabSVG := @SVGTrees;
  Timer1.Enabled := true;
end;

procedure TForm1.btnUserInterfaceClick(Sender: TObject);
begin
  PTabSVG := @SVGUserInterface;
  Timer1.Enabled := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := false;
  Timer1.Tag := -1;
end;

procedure TForm1.Image1Resize(Sender: TObject);
begin
  Image1.Bitmap.SetSize(trunc(Image1.Width * Image1.Bitmap.bitmapscale),
    trunc(Image1.Height * Image1.Bitmap.bitmapscale));
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Tag := Timer1.Tag + 1;
  if (Timer1.Tag >= length(PTabSVG^)) then
    Timer1.Tag := 0;

  Label1.Text := Timer1.Tag.tostring;

  if Image1.Bitmap.IsEmpty then
    Image1.Bitmap.SetSize(trunc(Image1.Width * Image1.Bitmap.bitmapscale),
      trunc(Image1.Height * Image1.Bitmap.bitmapscale));

  Image1.Bitmap.SkiaDraw(
    procedure(const ACanvas: ISKCanvas)
    var
      LSvgBrush: TSkSvgBrush;
    begin
      LSvgBrush := TSkSvgBrush.Create;
      try
        LSvgBrush.Source := PTabSVG^[Timer1.Tag];
        LSvgBrush.Render(ACanvas, RectF(0, 0, Image1.Bitmap.Width /
          Image1.Bitmap.bitmapscale, Image1.Bitmap.Height /
          Image1.Bitmap.bitmapscale), 1);
      finally
        LSvgBrush.Free;
      end;
    end);
end;

end.
