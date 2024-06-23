unit cShowMessageBox;

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
  cGrayBox,
  FMX.Layouts,
  FMX.Objects,
  cYellowMenuButton;

type
  TcadShowMessageBox = class(TcadGrayBox)
    lButtons: TLayout;
    btnOk: TcadYellowMenuButton;
    Text1: TText;
    procedure btnOkClick(Sender: TObject);
  private
  protected
    FOnClick: TProc;
  public
    class procedure ShowModal(const ACurForm: TForm; const Text: string;
      const OnClick: TProc = nil);
  end;

implementation

{$R *.fmx}
{ TcadShowMessageBox }

procedure TcadShowMessageBox.btnOkClick(Sender: TObject);
begin
  if assigned(FOnClick) then
    FOnClick;
  tthread.ForceQueue(nil,
    procedure
    begin
      if assigned(TagObject) and (TagObject is trectangle) then
        TagObject.free;
      self.free;
    end);
end;

class procedure TcadShowMessageBox.ShowModal(const ACurForm: TForm;
const Text: string; const OnClick: TProc);
var
  smb: TcadShowMessageBox;
  r: trectangle;
begin
  if not assigned(ACurForm) then
    raise exception.Create('Specify the parent form !');
  // TODO : intercepter ESC / RETURN (ou Joystick/télécommande) de la fiche parente pour déclencher le clic sur ce bouton

  r := trectangle.Create(ACurForm);
  r.Parent := ACurForm;
  r.Align := TAlignLayout.contents;
  r.Opacity := 0.6;
  r.HitTest := true;
  r.Stroke.Kind := tbrushkind.None;
  r.fill.Kind := tbrushkind.Solid;
  r.fill.Color := talphacolors.Lightgray;

  smb := TcadShowMessageBox.Create(ACurForm);
  smb.TagObject := r;
  smb.Parent := ACurForm;
  smb.btnOk.txtImage.Text := 'Ok';
  smb.Text1.Text := Text;
  smb.FOnClick := OnClick;
  if smb.Width > ACurForm.ClientWidth then
    smb.Width := ACurForm.ClientWidth;
  if smb.Height > ACurForm.ClientHeight then
    smb.Height := ACurForm.ClientHeight;
end;

end.
