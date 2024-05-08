unit cYellowGameButtonMusicOnOff;

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
  FMX.ImgList,
  FMX.Objects;

type
  TcadYellowGameButtonMusicOnOff = class(TcadYellowGameButton)
  private
  protected
    procedure SetGlyphImage(Const MusicOnOff: boolean);
  public
    procedure AfterConstruction; override;
  end;

var
  cadYellowGameButtonMusicOnOff: TcadYellowGameButtonMusicOnOff;

implementation

{$R *.fmx}

uses
  System.Messaging,
  Sporgloo.Messaging,
  uConfig;

{ TcadYellowGameButtonMusicOnOff }

procedure TcadYellowGameButtonMusicOnOff.AfterConstruction;
begin
  inherited;

  SetGlyphImage(TConfig.Current.BackgroundMusic);

  TMessageManager.DefaultManager.SubscribeToMessage
    (TBackgroundMusicStatusMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if (M is TBackgroundMusicStatusMessage) then
        SetGlyphImage((M as TBackgroundMusicStatusMessage).Value);
    end);
end;

procedure TcadYellowGameButtonMusicOnOff.SetGlyphImage(const MusicOnOff
  : boolean);
begin
  if MusicOnOff then
    gUp.ImageIndex := 1
  else
    gUp.ImageIndex := 0;
  gdown.ImageIndex := gUp.ImageIndex;

end;

end.
