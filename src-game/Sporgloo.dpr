program Sporgloo;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  fMain in 'fMain.pas' {frmMain},
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
  Sporgloo.Client in 'Sporgloo.Client.pas',
  Olf.Net.Socket.Messaging in '..\lib-externes\Socket-Messaging-Library\src\Olf.Net.Socket.Messaging.pas',
  Olf.FMX.TextImageFrame in '..\lib-externes\librairies\src\Olf.FMX.TextImageFrame.pas' {OlfFMXTextImageFrame: TFrame},
  Olf.RTL.Params in '..\lib-externes\librairies\src\Olf.RTL.Params.pas',
  u_urlOpen in '..\lib-externes\librairies\src\u_urlOpen.pas',
  Olf.RTL.Streams in '..\lib-externes\librairies\src\Olf.RTL.Streams.pas',
  udmAdobeStock_440583506 in '..\_PRIVATE\fontes\AdobeStock_440583506\udmAdobeStock_440583506.pas' {dmAdobeStock_440583506: TDataModule},
  udmAdobeStock_526775911 in '..\_PRIVATE\fontes\AdobeStock_526775911\udmAdobeStock_526775911.pas' {dmAdobeStock_526775911: TDataModule},
  cGrayBox in 'cGrayBox.pas' {cadGrayBox: TFrame},
  cYellowMenuButton in 'cYellowMenuButton.pas' {cadYellowMenuButton: TFrame},
  uBackgroundMusic in 'uBackgroundMusic.pas',
  cViseur in 'cViseur.pas' {cadViseur: TFrame},
  Olf.RTL.CryptDecrypt in '..\lib-externes\librairies\src\Olf.RTL.CryptDecrypt.pas',
  Olf.RTL.Maths.Conversions in '..\lib-externes\librairies\src\Olf.RTL.Maths.Conversions.pas',
  uDMAboutBoxLogo in 'uDMAboutBoxLogo.pas' {dmAboutBoxLogo: TDataModule},
  Olf.FMX.AboutDialog in '..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  udmAdobeStock_257147901 in '..\_PRIVATE\fontes\AdobeStock_257147901\udmAdobeStock_257147901.pas' {dmAdobeStock_257147901: TDataModule},
  cStarsCount in 'cStarsCount.pas' {cadStarsCount: TFrame},
  cScore in 'cScore.pas' {cadScore: TFrame},
  cLifeLevel in 'cLifeLevel.pas' {cadLifeLevel: TFrame};

{$R *.res}

begin
  SporglooProjectType := TSporglooProjectType.Client;
  GlobalUseSkia := True;
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TdmSporglooImages, dmSporglooImages);
  Application.CreateForm(TdmAdobeStock_440583506, dmAdobeStock_440583506);
  Application.CreateForm(TdmAdobeStock_526775911, dmAdobeStock_526775911);
  Application.CreateForm(TdmAboutBoxLogo, dmAboutBoxLogo);
  Application.CreateForm(TdmAdobeStock_257147901, dmAdobeStock_257147901);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
