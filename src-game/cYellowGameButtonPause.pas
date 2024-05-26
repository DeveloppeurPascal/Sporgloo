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
  USVGUserInterface,
  uSVGRegister;

{ TcadYellowGameButtonPause }

procedure TcadYellowGameButtonPause.AfterConstruction;
begin
  inherited;

  tthread.ForceQueue(nil,
    procedure
    var
      bmp: TBitmap;
    begin
      bmp := TOlfSVGBitmapList.Bitmap(SVGUserInterfaceListIndex, CSVGPause,
        round(imgUp.Width), round(imgUp.height), imgUp.Bitmap.bitmapscale);
      imgUp.Bitmap.Assign(bmp);
      imgdown.Bitmap.Assign(bmp);
    end);
end;

end.
