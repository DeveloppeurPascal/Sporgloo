unit uBackgroundMusic;

interface

type
  TBackgroundMusic = class
  private
    class var FCurrent: TBackgroundMusic;
    class function GetCurrent: TBackgroundMusic; static;
  protected
  public
    class property Current: TBackgroundMusic read GetCurrent;
    constructor Create;
    procedure OnOff(aOn: boolean);
    procedure Volume(AVolume: integer);
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  uConfig,
  Gamolf.FMX.MusicLoop,
  System.Classes,
  System.Messaging,
  Sporgloo.Messaging;

{ TBackgroundMusic }

constructor TBackgroundMusic.Create;
var
  folder: string;
begin
  inherited;

{$IF defined(ANDROID)}
  // deploy in .\assets\internal\
  folder := System.IOUtils.tpath.GetDocumentsPath;
{$ELSEIF defined(MSWINDOWS)}
  // deploy in ;\
  folder := extractfilepath(paramstr(0));
{$ELSEIF defined(IOS)}
  // deploy in .\
  folder := extractfilepath(paramstr(0));
{$ELSEIF defined(MACOS)}
  // deploy in Contents\MacOS
  folder := extractfilepath(paramstr(0));
{$ELSEIF Defined(LINUX)}
  folder := extractfilepath(paramstr(0));
{$ELSE}
{$MESSAGE FATAL 'OS non supporté'}
{$ENDIF}
  TMusicLoop.Current.Load(tpath.combine(folder, 'Mysterious_Passage_126s.wav'));

  Volume(TConfig.Current.BackgroundMusicVolume);
end;

class function TBackgroundMusic.GetCurrent: TBackgroundMusic;
begin
  if not assigned(FCurrent) then
    FCurrent := TBackgroundMusic.Create;

  result := FCurrent;
end;

procedure TBackgroundMusic.OnOff(aOn: boolean);
begin
  if aOn then
    TMusicLoop.Current.Play
  else
    TMusicLoop.Current.Stop;

  if aOn <> TConfig.Current.BackgroundMusic then
    TConfig.Current.BackgroundMusic := aOn;

  tthread.ForceQueue(nil,
    procedure
    begin
      TMessageManager.DefaultManager.SendMessage(nil,
        TBackgroundMusicStatusMessage.Create(aOn));
    end);
end;

procedure TBackgroundMusic.Volume(AVolume: integer);
begin
  if AVolume in [0 .. 100] then
  begin
    TMusicLoop.Current.Volume := AVolume;
    if TConfig.Current.BackgroundMusicVolume <> AVolume then
      TConfig.Current.BackgroundMusicVolume := AVolume;
  end;
end;

initialization

TBackgroundMusic.FCurrent := nil;

finalization

TBackgroundMusic.FCurrent.free;

end.
