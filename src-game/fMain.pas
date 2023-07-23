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
    procedure FormResize(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.Math,
  uConfig,
  uGameData, Sporgloo.Consts;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{$IFDEF RELEASE}
  FullScreen := true;
{$ENDIF}
  //
  tthread.ForceQueue(nil,
    procedure
    var
      DeviceID, PlayerID: string;
      GameData: TGameData;
    begin
      GameData := TGameData.Current;
      GameData.APIClient := tSporglooAPIClient.Create
        (tconfig.Current.ServerIPv4, tconfig.Current.ServerIPv4port);

      // TODO : if connexion failed, retry after a user confirmation or close the program
      DeviceID := GameData.Player.DeviceID;
      if DeviceID.IsEmpty then
        raise Exception.Create('Unknow device ID !');

      PlayerID := GameData.Player.PlayerID;
      if PlayerID.IsEmpty then
        GameData.APIClient.SendClientRegister(DeviceID)
      else
        GameData.APIClient.SendClientLogin(DeviceID, PlayerID);
    end);
end;

procedure TfrmMain.FormResize(Sender: TObject);
var
  GameData: TGameData;
  W, H: single;
begin
  GameData := TGameData.Current;
  W := clientwidth / CSporglootilesize;
  H := ClientHeight / CSporglootilesize;
  GameData.Session.MapRangeX := GameData.Player.PlayerX - ceil(W);
  GameData.Session.MapRangey := GameData.Player.Playery - ceil(H);
  GameData.Session.MapRangeColNumber := ceil(W);
  GameData.Session.MapRangeRowNumber := ceil(H);
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
