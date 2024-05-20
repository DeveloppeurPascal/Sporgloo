unit cYellowGameButtonPause;

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
  cYellowGameButton,
  FMX.Effects,
  FMX.Objects;

type
  TcadYellowGameButtonPause = class(TcadYellowGameButton)
  private
  protected
  public
    procedure AfterConstruction; override;
  end;

var
  cadYellowGameButtonPause: TcadYellowGameButtonPause;

implementation

{$R *.fmx}

uses
  Olf.Skia.SVGToBitmap,
  USVGUserInterface;

{ TcadYellowGameButtonPause }

procedure TcadYellowGameButtonPause.AfterConstruction;
begin
  inherited;

  tthread.ForceQueue(nil,
    procedure
    var
      bmp: TBitmap;
    begin
      bmp := SVGToBitmap(round(imgUp.Width), round(imgUp.Height),
        SVGUserInterface[CSVGPause], imgUp.bitmap.BitmapScale);
      try
        imgUp.bitmap.Assign(bmp);
        imgdown.bitmap.Assign(bmp);
      finally
        bmp.free;
      end;
    end);
end;

end.
