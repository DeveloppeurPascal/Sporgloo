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
  public
    // PTabSVG: PTabString;
    ListIndex, ItemIndex, MaxItemIndex: word;
    lstBackground, lstItems, lstPersos, lstTrees, lstUserInterface: word;
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
  USVGUserInterface,
  Olf.skia.SVGToBitmap;

procedure TForm1.btnBackgroundsClick(Sender: TObject);
begin
  // PTabSVG := @SVGBackgrounds;
  if (lstBackground = 0) then
  begin
    lstBackground := TOlfSVGBitmapList.AddAList;
    for var i := 0 to length(SVGBackgrounds) - 1 do
      TOlfSVGBitmapList.AddItemAt(lstBackground, i, SVGBackgrounds[i]);
  end;

  ListIndex := lstBackground;
  MaxItemIndex := length(SVGBackgrounds);
  Timer1.Enabled := true;
end;

procedure TForm1.btnItemsClick(Sender: TObject);
begin
  // PTabSVG := @SVGItems;
  if (lstItems = 0) then
  begin
    lstItems := TOlfSVGBitmapList.AddAList;
    for var i := 0 to length(SVGitems) - 1 do
      TOlfSVGBitmapList.AddItemAt(lstItems, i, SVGitems[i]);
  end;

  ListIndex := lstItems;
  MaxItemIndex := length(SVGitems);
  Timer1.Enabled := true;
end;

procedure TForm1.btnPersosClick(Sender: TObject);
begin
  // PTabSVG := @SVGPersos;
  if (lstPersos = 0) then
  begin
    lstPersos := TOlfSVGBitmapList.AddAList;
    for var i := 0 to length(SVGPersos) - 1 do
      TOlfSVGBitmapList.AddItemAt(lstPersos, i, SVGPersos[i]);
  end;

  ListIndex := lstPersos;
  MaxItemIndex := length(SVGPersos);
  Timer1.Enabled := true;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TForm1.btnTreesClick(Sender: TObject);
begin
  // PTabSVG := @SVGTrees;
  if (lstTrees = 0) then
  begin
    lstTrees := TOlfSVGBitmapList.AddAList;
    for var i := 0 to length(SVGtrees) - 1 do
      TOlfSVGBitmapList.AddItemAt(lstTrees, i, SVGtrees[i]);
  end;

  ListIndex := lstTrees;
  MaxItemIndex := length(SVGtrees);
  Timer1.Enabled := true;
end;

procedure TForm1.btnUserInterfaceClick(Sender: TObject);
begin
  // PTabSVG := @SVGUserInterface;
  if (lstUserInterface = 0) then
  begin
    lstUserInterface := TOlfSVGBitmapList.AddAList;
    for var i := 0 to length(SVGUserInterface) - 1 do
      TOlfSVGBitmapList.AddItemAt(lstUserInterface, i, SVGUserInterface[i]);
  end;

  ListIndex := lstUserInterface;
  MaxItemIndex := length(SVGUserInterface);
  Timer1.Enabled := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ListIndex := 0;
  ItemIndex := 0;
  MaxItemIndex := 0;
  lstBackground := 0;
  lstItems := 0;
  lstPersos := 0;
  lstTrees := 0;
  lstUserInterface := 0;

  Timer1.Enabled := false;
end;

procedure TForm1.Image1Resize(Sender: TObject);
begin
  // Image1.Bitmap.SetSize(trunc(Image1.Width * Image1.Bitmap.bitmapscale),
  // trunc(Image1.Height * Image1.Bitmap.bitmapscale));

  TOlfSVGBitmapList.ClearCache;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
// var
// bmp: tbitmap;
begin
  ItemIndex := ItemIndex + 1;
  // if (ItemIndex >= length(PTabSVG^)) then
  if (ItemIndex >= MaxItemIndex) then
    ItemIndex := 0;

  Label1.Text := ItemIndex.tostring;

  // if Image1.Bitmap.IsEmpty then
  // Image1.Bitmap.SetSize(trunc(Image1.Width * Image1.Bitmap.bitmapscale),
  // trunc(Image1.Height * Image1.Bitmap.bitmapscale));

  Image1.Bitmap.Assign(TOlfSVGBitmapList.Bitmap(ListIndex, ItemIndex,
    round(Image1.Width), round(Image1.Height), Image1.Bitmap.bitmapscale));

  // bmp := SVGToBitmap(Image1.Bitmap.Width, Image1.Bitmap.Height,
  // PTabSVG^[ItemIndex], Image1.Bitmap.bitmapscale);
  // try
  // Image1.Bitmap.Assign(bmp);
  // finally
  // bmp.free;
  // end;
end;

initialization

ReportMemoryLeaksOnShutdown := true;

end.
