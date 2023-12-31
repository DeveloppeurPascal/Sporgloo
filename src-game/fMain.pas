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
  Sporgloo.MapFrame,
  FMX.Layouts,
  Sporgloo.Types,
  Olf.Net.Socket.Messaging;

type
{$SCOPEDENUMS ON}
  TPageType = (None, Home, Game, NewGame, Credits, Scores, Options);

  TfrmMain = class(TForm)
    MapFrame1: TMapFrame;
    HomePage: TLayout;
    GamePage: TLayout;
    NewGamePage: TLayout;
    CreditsPage: TLayout;
    ScorePage: TLayout;
    OptionsPage: TLayout;
    WaitPage: TLayout;
    WaitAnimation: TAniIndicator;
    btnNewGame: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNewGameClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure GamePageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  private
    FActivePage: TPageType;
    procedure SetActivePage(const Value: TPageType);
    procedure SetLifeLevel(const Value: TSporglooAPINumber);
    procedure SetScore(const Value: TSporglooAPINumber);
    procedure SetStarsCount(const Value: TSporglooAPINumber);
    function GetLifeLevel: TSporglooAPINumber;
    function GetScore: TSporglooAPINumber;
    function GetStarsCount: TSporglooAPINumber;
    property ActivePage: TPageType read FActivePage write SetActivePage;
    procedure ShowGameTitle(isVisible: boolean = true);
    procedure InitializeGamePage;
    procedure DoClientConnected(AClient: TOlfSMSrvConnectedClient);
    procedure DoClientLostConnection(AClient: TOlfSMSrvConnectedClient);
  protected
    procedure SubscribeToServerConnectedMessage;
    procedure SubscribeToLostServerMessage;
  public
    { D�clarations publiques }
    property Score: TSporglooAPINumber read GetScore write SetScore;
    property LifeLevel: TSporglooAPINumber read GetLifeLevel write SetLifeLevel;
    property StarsCount: TSporglooAPINumber read GetStarsCount
      write SetStarsCount;
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
  Sporgloo.Client;

procedure TfrmMain.btnNewGameClick(Sender: TObject);
begin
  ActivePage := TPageType.Game;
end;

procedure TfrmMain.DoClientConnected(AClient: TOlfSMSrvConnectedClient);
begin
  if not(AClient is tsporglooclient) then
    exit;

  TThread.ForceQueue(nil,
    procedure
    begin
      TMessageManager.DefaultManager.SendMessage(self,
        TServerConnectedMessage.Create(AClient as tsporglooclient));
    end);
end;

procedure TfrmMain.DoClientLostConnection(AClient: TOlfSMSrvConnectedClient);
begin
  if not(AClient is tsporglooclient) then
    exit;

  TThread.ForceQueue(nil,
    procedure
    begin
      TMessageManager.DefaultManager.SendMessage(self,
        TLostServerMessage.Create(AClient as tsporglooclient));
    end);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ActivePage := TPageType.None;

{$IFDEF RELEASE}
  FullScreen := true;
{$ENDIF}
  //
  SubscribeToServerConnectedMessage;
  SubscribeToLostServerMessage;

  TThread.ForceQueue(nil,
    procedure
    begin
      TGameData.Current.APIClient := tsporglooclient.Create
        (tconfig.Current.ServerIPv4, tconfig.Current.ServerIPv4port);
      // TODO : add a connection on IPv6 if available
      TGameData.Current.APIClient.onConnected := DoClientConnected;
      TGameData.Current.APIClient.onLostConnection := DoClientLostConnection;
      TGameData.Current.APIClient.Connect;
      ActivePage := TPageType.Home;
    end);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if assigned(TGameData.Current.APIClient) then
    TGameData.Current.APIClient.Free;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkEscape) or (Key = vkHardwareBack) then
  begin
    if ActivePage = TPageType.Game then
    begin
      // TODO : d�clencher l'enregistrement des donn�es
      ActivePage := TPageType.Home;
    end
    else
      close;
  end;
end;

procedure TfrmMain.GamePageMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
var
  MapX, MapY: TSporglooAPINumber;
  GameData: TGameData;
begin
  GameData := TGameData.Current;
  MapX := trunc(X / CSporglooTileSize) + GameData.Session.MapRangeX;
  MapY := trunc(Y / CSporglooTileSize) + GameData.Session.MapRangeY;
  if (GameData.Map.GetTileID(MapX, MapY) <> CSporglooTileStar) and
    (StarsCount > 0) then
  begin
    StarsCount := StarsCount - 1;
    GameData.APIClient.SendPlayerPutAStar(GameData.Session.SessionID,
      GameData.Session.PlayerID, MapX, MapY);
    // TODO : Add the star in a waiting list of server's ACK
    GameData.Map.SetTileID(MapX, MapY, CSporglooTileStar);
    TMessageManager.DefaultManager.SendMessage(self,
      TMapCellUpdateMessage.Create(TSporglooMapCell.Create(MapX, MapY,
      CSporglooTileStar)));
  end;
end;

function TfrmMain.GetLifeLevel: TSporglooAPINumber;
begin
  result := TGameData.Current.Player.LifeLevel;
end;

function TfrmMain.GetScore: TSporglooAPINumber;
begin
  result := TGameData.Current.Player.Score;
end;

function TfrmMain.GetStarsCount: TSporglooAPINumber;
begin
  result := TGameData.Current.Player.StarsCount;
end;

procedure TfrmMain.InitializeGamePage;
begin
  // TODO : initialize the "new game" screen
end;

procedure TfrmMain.SetActivePage(const Value: TPageType);
  procedure ShowPage(Const Page: TLayout);
  begin
    Page.Visible := true;
    Page.BringToFront;
  end;
  procedure HidePage(Const Page: TLayout);
  begin
    Page.Visible := false;
  end;

begin
  ShowGameTitle(false);
  if Value = TPageType.None then
  begin
    ShowGameTitle;
    ShowPage(WaitPage);
    WaitAnimation.Enabled := true;
  end
  else
  begin
    WaitAnimation.Enabled := false;
    HidePage(WaitPage);
  end;

  if Value = TPageType.Home then
  begin
    ShowGameTitle;
    ShowPage(HomePage);
  end
  else
    HidePage(HomePage);

  if Value = TPageType.Game then
  begin
    InitializeGamePage;
    ShowPage(GamePage);
  end
  else
    HidePage(GamePage);

  if Value = TPageType.NewGame then
  begin
    // TODO : initialize the "new game" screen
    ShowPage(NewGamePage);
  end
  else
    HidePage(NewGamePage);

  if Value = TPageType.Credits then
    ShowPage(CreditsPage)
  else
    HidePage(CreditsPage);

  if Value = TPageType.Scores then
  begin
    // TODO : load scores from the server (or the local cache)
    ShowPage(ScorePage);
  end
  else
    HidePage(ScorePage);

  if Value = TPageType.Options then
  begin
    // TODO : Initialize the options page from config settings
    ShowPage(OptionsPage);
  end
  else
    HidePage(OptionsPage);

  FActivePage := Value;
end;

procedure TfrmMain.SetLifeLevel(const Value: TSporglooAPINumber);
begin
  TGameData.Current.Player.LifeLevel := Value;
  // TODO : refresh screen if displayed
end;

procedure TfrmMain.SetScore(const Value: TSporglooAPINumber);
begin
  TGameData.Current.Player.Score := Value;
  // TODO : refresh screen if displayed
end;

procedure TfrmMain.SetStarsCount(const Value: TSporglooAPINumber);
begin
  TGameData.Current.Player.StarsCount := Value;
  // TODO : refresh screen if displayed
end;

procedure TfrmMain.ShowGameTitle(isVisible: boolean);
begin
  // TODO : add the game title
end;

procedure TfrmMain.SubscribeToLostServerMessage;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TLostServerMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      Msg: TLostServerMessage;
      Client: tsporglooclient;
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
      Client: tsporglooclient;
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
