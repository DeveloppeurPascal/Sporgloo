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
  FMX.ImgList,
  FMX.Objects, FMX.Effects;

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
{ TcadYellowGameButtonPause }

procedure TcadYellowGameButtonPause.AfterConstruction;
begin
  inherited;
  gUp.ImageIndex := 2;
  gDown.ImageIndex := gUp.ImageIndex;
end;

end.
