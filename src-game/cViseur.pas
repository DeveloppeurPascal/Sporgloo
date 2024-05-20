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
  USVGUserInterface;

{ TcadViseur }

procedure TcadViseur.AfterConstruction;
begin
  inherited;

  tthread.forcequeue(nil,
    procedure
    var
      bmp: tbitmap;
    begin
      bmp := SVGToBitmap(round(Image1.Width), round(Image1.height),
        SVGUserInterface[CSVGTargetRoundB], Image1.Bitmap.bitmapscale);
      try
        Image1.Bitmap.Assign(bmp);
      finally
        bmp.free;
      end;
    end);
end;

end.
