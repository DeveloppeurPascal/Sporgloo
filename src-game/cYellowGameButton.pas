unit cYellowGameButton;

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
  Sporgloo.Images,
  FMX.ImgList,
  FMX.Effects;

type
  TcadYellowGameButton = class(TFrame)
    rUp: TRectangle;
    rDown: TRectangle;
    gDown: TGlyph;
    gUp: TGlyph;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FrameMouseLeave(Sender: TObject);
    procedure FrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    FisDown: boolean;
    procedure SetisDown(const Value: boolean);
  protected
    procedure onButtonDown; virtual;
    procedure onButtonUp; virtual;
  public
    property isDown: boolean read FisDown write SetisDown;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

constructor TcadYellowGameButton.Create(AOwner: TComponent);
begin
  inherited;
  isDown := false;
end;

procedure TcadYellowGameButton.FrameMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  isDown := true;
end;

procedure TcadYellowGameButton.FrameMouseLeave(Sender: TObject);
begin
  isDown := false;
end;

procedure TcadYellowGameButton.FrameMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  isDown := false;
end;

procedure TcadYellowGameButton.onButtonDown;
begin
  // Nothing to do there
end;

procedure TcadYellowGameButton.onButtonUp;
begin
  // Nothing to do there
end;

procedure TcadYellowGameButton.SetisDown(const Value: boolean);
begin
  FisDown := Value;
  rDown.Visible := FisDown;
  rUp.Visible := not FisDown;
  if FisDown then
    onButtonDown
  else
    onButtonUp;
end;

end.
