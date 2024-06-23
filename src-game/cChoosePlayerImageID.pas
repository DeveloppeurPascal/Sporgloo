unit cChoosePlayerImageID;

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
  Olf.FMX.TextImageFrame,
  FMX.Objects;

type
  TcadChoosePlayerImageID = class(TcadGrayBox)
    OlfFMXTextImageFrame1: TOlfFMXTextImageFrame;
    Layout1: TLayout;
    FlowLayout1: TFlowLayout;
  private
  protected
    procedure SelfDestroy;
    procedure CharacterClick(Sender: TObject);
  public
    class procedure Execute(const ACurForm: TForm);
  end;

implementation

{$R *.fmx}

uses
  udmAdobeStock_257147901,
  USVGPersos,
  Olf.Skia.SVGToBitmap,
  uSVGRegister,
  Sporgloo.Consts,
  cYellowGameButton,
  uGameData;

{ TcadChoosePlayerImageID }

procedure TcadChoosePlayerImageID.CharacterClick(Sender: TObject);
begin
  if Sender is Timage then
  begin
    tgamedata.Current.player.ImageID := (Sender as Timage).tag;
    tgamedata.Current.APIClient.SendPlayerImageChanged
      (tgamedata.Current.session.SessionID, tgamedata.Current.player.ImageID);
    SelfDestroy;
  end;
end;

class procedure TcadChoosePlayerImageID.Execute(const ACurForm: TForm);
var
  smb: TcadChoosePlayerImageID;
  r: trectangle;
  i, ImageID: integer;
  bmp: TBitmap;
  img: Timage;
  h: single;
  c: tcontrol;
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

  smb := TcadChoosePlayerImageID.Create(ACurForm);
  smb.TagObject := r;
  smb.Parent := ACurForm;

  smb.OlfFMXTextImageFrame1.Font := dmAdobeStock_257147901.ImageList;
  smb.OlfFMXTextImageFrame1.Text := 'Choose your look'.ToUpper;
  // TODO : à traduire
  // TODO : changer la fonte pour une avec majuscules et minuscules

  for ImageID := 0 to length(SVGPersos) - 1 do
  begin
    img := Timage.Create(smb);
    img.Parent := smb.FlowLayout1;
    img.Width := CSporglooTileSize;
    img.height := CSporglooTileSize;
    img.margins.top := 5;
    img.margins.Right := 5;
    img.margins.Bottom := 5;
    img.margins.Left := 5;
    bmp := TOlfSVGBitmapList.Bitmap(SVGPersosListIndex, ImageID,
      CSporglooTileSize, CSporglooTileSize, img.Bitmap.bitmapscale);
    img.Bitmap.Assign(bmp);
    img.HitTest := true;
    img.tag := ImageID;
    img.OnClick := smb.CharacterClick;
  end;

  h := 0;
  for i := 0 to smb.FlowLayout1.ChildrenCount - 1 do
    if smb.FlowLayout1.Children[i] is tcontrol then
    begin
      c := smb.FlowLayout1.Children[i] as tcontrol;
      if h < c.Position.y + c.height + c.margins.Bottom then
        h := c.Position.y + c.height + c.margins.Bottom;
    end;
  smb.FlowLayout1.height := h;

  smb.AutoHeight;
end;

procedure TcadChoosePlayerImageID.SelfDestroy;
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      if assigned(TagObject) and (TagObject is trectangle) then
        TagObject.free;
      self.free;
    end);
end;

end.
