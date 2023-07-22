unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uClientSocket,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    FAPIClient: tSporglooAPIClient;
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  tthread.ForceQueue(nil,
    procedure
    begin
      FAPIClient := tSporglooAPIClient.Create('127.0.0.1', 80);
      // TODO : update IP+Port depending on server infos
      // TODO : if connexion failed, retry after a user confirmation or close the program
    end);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FAPIClient.Free;
end;

end.
