unit cYellowMenuButton;

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
  Olf.FMX.TextImageFrame;

type
  TcadYellowMenuButton = class(TFrame)
    rUp: TRectangle;
    rDown: TRectangle;
    txtImage: TOlfFMXTextImageFrame;
    procedure FrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FrameMouseLeave(Sender: TObject);
  private
    FisDown: boolean;
    procedure SetisDown(const Value: boolean);
  protected
    function GetImageIndexOfUnknowChar(Sender: TOlfFMXTextImageFrame;
      AChar: char): integer;
  public
    property isDown: boolean read FisDown write SetisDown;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  udmAdobeStock_440583506;

constructor TcadYellowMenuButton.Create(AOwner: TComponent);
begin
  inherited;
  isDown := false;
  txtImage.Font := dmAdobeStock_440583506.ImageList;
  txtImage.OnGetImageIndexOfUnknowChar := GetImageIndexOfUnknowChar;
end;

procedure TcadYellowMenuButton.FrameMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  isDown := true;
end;

procedure TcadYellowMenuButton.FrameMouseLeave(Sender: TObject);
begin
  isDown := false;
end;

procedure TcadYellowMenuButton.FrameMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  isDown := false;
end;

function TcadYellowMenuButton.GetImageIndexOfUnknowChar
  (Sender: TOlfFMXTextImageFrame; AChar: char): integer;
begin
  result := Sender.getImageIndexOfChar('_' + AChar);
end;

procedure TcadYellowMenuButton.SetisDown(const Value: boolean);
begin
  FisDown := Value;
  rDown.Visible := FisDown;
  rUp.Visible := not FisDown;
  txtImage.height := rDown.height - 10;
  if rDown.Visible then
    txtImage.Margins.top := 4
  else
    txtImage.Margins.top := 0;
end;

end.
