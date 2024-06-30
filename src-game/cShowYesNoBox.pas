unit cShowYesNoBox;

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
  cYellowMenuButton,
  FMX.Layouts,
  FMX.Objects;

type
  TcadShowYesNoBox = class(TcadGrayBox)
    GridPanelLayout1: TGridPanelLayout;
    btnYes: TcadYellowMenuButton;
    btnNo: TcadYellowMenuButton;
    Text1: TText;
    procedure btnNoClick(Sender: TObject);
    procedure btnYesClick(Sender: TObject);
  private
  protected
    FOnYesClick, FOnNoClick: TProc;
    procedure SelfDestroy;
  public
    class procedure ShowModal(const ACurForm: TForm; const Text: string;
      const OnYesClick: TProc = nil; const OnNoClick: TProc = nil);
  end;

implementation

{$R *.fmx}

procedure TcadShowYesNoBox.btnNoClick(Sender: TObject);
begin
  if assigned(FOnNoClick) then
    FOnNoClick;
  SelfDestroy;
end;

procedure TcadShowYesNoBox.btnYesClick(Sender: TObject);
begin
  if assigned(FOnYesClick) then
    FOnYesClick;
  SelfDestroy;
end;

procedure TcadShowYesNoBox.SelfDestroy;
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      if assigned(TagObject) and (TagObject is trectangle) then
        TagObject.free;
      self.free;
    end);
end;

class procedure TcadShowYesNoBox.ShowModal(const ACurForm: TForm;
const Text: string; const OnYesClick, OnNoClick: TProc);
var
  smb: TcadShowYesNoBox;
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

  smb := TcadShowYesNoBox.Create(ACurForm);
  smb.name := '';
  smb.TagObject := r;
  smb.Parent := ACurForm;
  smb.btnYes.txtImage.Text := 'Yes'; // TODO : traduire le texte
  smb.FOnYesClick := OnYesClick;
  smb.btnNo.txtImage.Text := 'No';
  smb.FOnNoClick := OnNoClick;
  smb.Text1.Text := Text;

  smb.AutoHeight;
end;

end.
