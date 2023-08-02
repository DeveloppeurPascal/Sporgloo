program Sporgloo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Skia.FMX,
  fMain in 'fMain.pas' {frmMain},
  Olf.FMX.TextImageFrame in '..\lib-externes\librairies\Olf.FMX.TextImageFrame.pas' {OlfFMXTextImageFrame: TFrame},
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas',
  u_urlOpen in '..\lib-externes\librairies\u_urlOpen.pas',
  Gamolf.FMX.Joystick in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.Joystick.pas',
  Gamolf.FMX.MusicLoop in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.FMX.MusicLoop.pas',
  Gamolf.RTL.Joystick.DirectInput.Win in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.DirectInput.Win.pas',
  Gamolf.RTL.Joystick.Mac in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.Mac.pas',
  Gamolf.RTL.Joystick in '..\lib-externes\Delphi-Game-Engine\src\Gamolf.RTL.Joystick.pas',
  iOSapi.GameController in '..\lib-externes\Delphi-Game-Engine\src\iOSapi.GameController.pas',
  Macapi.GameController in '..\lib-externes\Delphi-Game-Engine\src\Macapi.GameController.pas',
  Sporgloo.API.Messages in '..\src-common-api\Sporgloo.API.Messages.pas',
  uGameData in 'uGameData.pas',
  uConfig in 'uConfig.pas',
  Sporgloo.Types in '..\src-common-api\Sporgloo.Types.pas',
  Sporgloo.Database in '..\src-common-api\Sporgloo.Database.pas',
  Sporgloo.Consts in '..\src-common-api\Sporgloo.Consts.pas',
  Sporgloo.Messaging in 'Sporgloo.Messaging.pas',
  Sporgloo.MapFrame in 'Sporgloo.MapFrame.pas' {MapFrame: TFrame},
  Sporgloo.Images in 'Sporgloo.Images.pas' {dmSporglooImages: TDataModule},
  Olf.Net.Socket.Messaging in '..\lib-externes\Socket-Messaging-Library\src-library\Olf.Net.Socket.Messaging.pas',
  Sporgloo.Client in 'Sporgloo.Client.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TdmSporglooImages, dmSporglooImages);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
