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
  uConfig,
  Olf.Skia.SVGToBitmap,
  USVGUserInterface;

{ TcadYellowGameButtonMusicOnOff }

procedure TcadYellowGameButtonMusicOnOff.AfterConstruction;
begin
  inherited;

  tthread.ForceQueue(nil,
    procedure
    begin
      SetGlyphImage(TConfig.Current.BackgroundMusic);
    end);

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
var
  bmp: TBitmap;
begin
  if MusicOnOff then
    bmp := SVGToBitmap(round(imgUp.Width), round(imgUp.Height),
      SVGUserInterface[CSVGMusicOff], imgUp.bitmap.BitmapScale)
  else
    bmp := SVGToBitmap(round(imgUp.Width), round(imgUp.Height),
      SVGUserInterface[CSVGMusicOn], imgUp.bitmap.BitmapScale);
  try
    imgUp.bitmap.Assign(bmp);
    imgdown.bitmap.Assign(bmp);
  finally
    bmp.free;
  end;
end;

end.
