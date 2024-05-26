unit cViseur;

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
  FMX.Objects;

type
  TcadViseur = class(TFrame)
    Image1: TImage;
  private
  public
    procedure AfterConstruction; override;
  end;

implementation

{$R *.fmx}

uses
  Olf.Skia.SVGToBitmap,
  USVGUserInterface,
  uSVGRegister;

{ TcadViseur }

procedure TcadViseur.AfterConstruction;
begin
  inherited;

  tthread.forcequeue(nil,
    procedure
    begin
      Image1.Bitmap.Assign(TOlfSVGBitmapList.Bitmap(SVGUserInterfaceListIndex,
        CSVGTargetRoundB, round(Image1.Width), round(Image1.height),
        Image1.Bitmap.bitmapscale));
    end);
end;

end.
