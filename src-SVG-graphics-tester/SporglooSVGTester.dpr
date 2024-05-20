program SporglooSVGTester;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  fMain in 'fMain.pas' {Form1},
  USVGBackgrounds in '..\assets\graphics\Backgrounds\USVGBackgrounds.pas',
  USVGItems in '..\assets\graphics\Items\USVGItems.pas',
  USVGPersos in '..\assets\graphics\Persos\USVGPersos.pas',
  USVGTrees in '..\assets\graphics\Trees\USVGTrees.pas',
  USVGUserInterface in '..\assets\graphics\UserInterface\USVGUserInterface.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
