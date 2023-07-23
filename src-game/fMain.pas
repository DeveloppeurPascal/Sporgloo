unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  Sporgloo.MapFrame;

type
  TfrmMain = class(TForm)
    MapFrame1: TMapFrame;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
  protected
    procedure SubscribeToServerConnectedMessage;
    procedure SubscribeToLostServerMessage;
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.Messaging,
  uConfig,
  uGameData,
  Sporgloo.Consts,
  Sporgloo.Messaging,
  uClientSocket;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{$IFDEF RELEASE}
  FullScreen := true;
{$ENDIF}
  //
  SubscribeToServerConnectedMessage;
  SubscribeToLostServerMessage;

  tthread.ForceQueue(nil,
    procedure
    begin
      TGameData.Current.APIClient := tSporglooAPIClient.Create
        (tconfig.Current.ServerIPv4, tconfig.Current.ServerIPv4port);
      // TODO : add a connection on IPv6 if available
    end);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if assigned(TGameData.Current.APIClient) then
    TGameData.Current.APIClient.Terminate;
end;

procedure TfrmMain.SubscribeToLostServerMessage;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TLostServerMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      Msg: TLostServerMessage;
      Client: tSporglooAPIClient;
      DeviceID, PlayerID: string;
      GameData: TGameData;
    begin
      if not(M is TLostServerMessage) then
        exit;
      Msg := M as TLostServerMessage;
      if not assigned(Msg.Value) then
        exit;
      Client := Msg.Value;

      // TODO : if connexion failed, retry after a user confirmation or close the program
    end);
end;

procedure TfrmMain.SubscribeToServerConnectedMessage;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TServerConnectedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      Msg: TServerConnectedMessage;
      Client: tSporglooAPIClient;
      DeviceID, PlayerID: string;
      GameData: TGameData;
    begin
      if not(M is TServerConnectedMessage) then
        exit;
      Msg := M as TServerConnectedMessage;
      if not assigned(Msg.Value) then
        exit;
      Client := Msg.Value;

      GameData := TGameData.Current;

      DeviceID := GameData.Player.DeviceID;
      if DeviceID.IsEmpty then
        raise Exception.Create('Unknow device ID !');

      PlayerID := GameData.Player.PlayerID;
      if PlayerID.IsEmpty then
        Client.SendClientRegister(DeviceID)
      else
        Client.SendClientLogin(DeviceID, PlayerID);
    end);
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
