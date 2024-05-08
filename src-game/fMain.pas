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
  Olf.Net.Socket.Messaging,
  Olf.FMX.TextImageFrame,
  cGrayBox,
  cYellowMenuButton,
  cViseur,
  FMX.Objects,
  Olf.FMX.AboutDialog,
  uDMAboutBoxLogo,
  cStarsCount,
  cScore,
  cLifeLevel,
  cYellowGameButton,
  cYellowGameButtonPause,
  cYellowGameButtonMusicOnOff;

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
    txtImgTitre: TOlfFMXTextImageFrame;
    lGameTitle: TLayout;
    Layout1: TLayout;
    cadGrayBox1: TcadGrayBox;
    btnPlay: TcadYellowMenuButton;
    btnQuit: TcadYellowMenuButton;
    Viseur: TcadViseur;
    TimerGamePad: TTimer;
    GameControllerPicture: TPath;
    OlfAboutDialog1: TOlfAboutDialog;
    lblStarsCount: TcadStarsCount;
    lDisplayScoreAndLevels: TLayout;
    lblScore: TcadScore;
    lblLifeLevel: TcadLifeLevel;
    lRightButtons: TLayout;
    cadYellowGameButtonPause1: TcadYellowGameButtonPause;
    cadYellowGameButtonMusicOnOff1: TcadYellowGameButtonMusicOnOff;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure GamePageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPlayClick(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure GamePageMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure TimerGamePadTimer(Sender: TObject);
    procedure cadYellowGameButtonPause1Click(Sender: TObject);
    procedure cadYellowGameButtonMusicOnOff1Click(Sender: TObject);
  private
    FActivePage: TPageType;
    FPreviousGamePadKey: Word;
    FPreviousGamePadKeyChar: widechar;
    FPreviousGamePadTempo: int64;
    procedure SetActivePage(const Value: TPageType);
    property ActivePage: TPageType read FActivePage write SetActivePage;
    procedure ShowGameTitle(isVisible: boolean = true);
    procedure InitializeGamePage;
    procedure InitializeHomePage;
    procedure DoClientConnected(const AClient: TOlfSMSrvConnectedClient);
    procedure DoClientLostConnection(const AClient: TOlfSMSrvConnectedClient);
    procedure InitMainFormCaption;
    procedure MiseEnPause;
  protected
    procedure SubscribeToServerConnectedMessage;
    procedure SubscribeToLostServerMessage;
    procedure SubscribeToDisconnect;
    procedure SubscribeToPlayerLevelsUpdates;
  public
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
  Sporgloo.Client,
  Sporgloo.API.Messages,
  udmAdobeStock_526775911,
  uBackgroundMusic,
  Gamolf.RTL.Joystick,
  FMX.Platform,
  Olf.FMX.AboutDialogForm;

procedure TfrmMain.btnPlayClick(Sender: TObject);
begin
  ActivePage := TPageType.Game;
end;

procedure TfrmMain.btnQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.cadYellowGameButtonMusicOnOff1Click(Sender: TObject);
begin
  TBackgroundMusic.Current.OnOff(not tconfig.Current.BackgroundMusic);
end;

procedure TfrmMain.cadYellowGameButtonPause1Click(Sender: TObject);
begin
  MiseEnPause;
end;

procedure TfrmMain.DoClientConnected(const AClient: TOlfSMSrvConnectedClient);
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

procedure TfrmMain.DoClientLostConnection(const AClient
  : TOlfSMSrvConnectedClient);
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

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  msg: TLogoffMessage;
begin
  if assigned(TGameData.Current.APIClient) then
    try
      msg := TLogoffMessage.Create;
      try
        try
          TGameData.Current.APIClient.SendMessage(msg);
        except
        end;
      finally
        msg.free;
      end;
      TGameData.Current.APIClient.free;
    finally
      TGameData.Current.APIClient := nil;
    end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitMainFormCaption;

  ActivePage := TPageType.None;

  FPreviousGamePadKey := 0;
  FPreviousGamePadKeyChar := #0;
  FPreviousGamePadTempo := 0;
  GameControllerPicture.Visible := false;

{$IFDEF RELEASE}
  FullScreen := true;
{$ENDIF}
  //
  SubscribeToServerConnectedMessage;
  SubscribeToLostServerMessage;
  SubscribeToDisconnect;
  SubscribeToPlayerLevelsUpdates;

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

  TBackgroundMusic.Current.OnOff(tconfig.Current.BackgroundMusic);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if ((Key = vkReturn) or (KeyChar = ' ')) and (ActivePage = TPageType.Home)
  then
  begin
    btnPlayClick(Sender);
    Key := 0;
    KeyChar := #0;
  end
  else if (Key = vkEscape) or (Key = vkHardwareBack) then
  begin
    if ActivePage = TPageType.Game then
      MiseEnPause
    else
      Close;
    Key := 0;
  end
  else if ((Key in [vkLeft, vkRight, vkUp, vkDown]) or charinset(KeyChar,
    ['W', 'w', 'Z', 'z', 'A', 'a', 'Q', 'q', 'S', 's', 'D', 'd'])) and
    (ActivePage = TPageType.Game) then
  begin
    if ((Key = vkLeft) or charinset(KeyChar, ['A', 'a', 'Q', 'q'])) and
      (Viseur.Position.X - CSporglooTileSize >= 0) then
      Viseur.Position.X := Viseur.Position.X - CSporglooTileSize
    else if ((Key = vkRight) or charinset(KeyChar, ['D', 'd'])) and
      (Viseur.Position.X + CSporglooTileSize < GamePage.Width) then
      Viseur.Position.X := Viseur.Position.X + CSporglooTileSize
    else if ((Key = vkUp) or charinset(KeyChar, ['W', 'w', 'Z', 'z'])) and
      (Viseur.Position.Y - CSporglooTileSize >= 0) then
      Viseur.Position.Y := Viseur.Position.Y - CSporglooTileSize
    else if ((Key = vkDown) or charinset(KeyChar, ['S', 's'])) and
      (Viseur.Position.Y + CSporglooTileSize < GamePage.height) then
      Viseur.Position.Y := Viseur.Position.Y + CSporglooTileSize;

    Key := 0;
    KeyChar := #0;
  end
  else if ((Key = vkReturn) or (KeyChar = ' ')) and (ActivePage = TPageType.Game)
  then
  begin
    GamePageMouseDown(Sender, TMouseButton.mbLeft, [],
      Viseur.Position.X + CSporglooTileSize / 2,
      Viseur.Position.Y + CSporglooTileSize / 2);
    Key := 0;
    KeyChar := #0;
  end;
end;

procedure TfrmMain.GamePageMouseDown(Sender: TObject; Button: TMouseButton;
Shift: TShiftState; X, Y: Single);
var
  MapX, MapY: TSporglooAPINumber;
  GameData: TGameData;
  MapCell: TSporglooMapCell;
begin
  Viseur.Position.X := trunc(X / CSporglooTileSize) * CSporglooTileSize;
  Viseur.Position.Y := trunc(Y / CSporglooTileSize) * CSporglooTileSize;

  GameData := TGameData.Current;
  if (GameData.player.StarsCount > 0) then
  begin
    MapX := trunc(X / CSporglooTileSize) + GameData.ViewportX;
    MapY := trunc(Y / CSporglooTileSize) + GameData.ViewportY;

    MapCell := GameData.Map.GetCellAt(MapX, MapY);

    if (MapCell.TileID in [CSporglooTileForest, CSporglooTilePath]) and
      MapCell.PlayerID.IsEmpty then
    begin
      GameData.APIClient.SendPlayerPutAStar(GameData.Session.SessionID,
        GameData.player.PlayerID, MapX, MapY);

      GameData.player.StarsCount := GameData.player.StarsCount - 1;
    end;
  end;
end;

procedure TfrmMain.GamePageMouseMove(Sender: TObject; Shift: TShiftState;
X, Y: Single);
begin
  Viseur.Position.X := trunc(X / CSporglooTileSize) * CSporglooTileSize;
  Viseur.Position.Y := trunc(Y / CSporglooTileSize) * CSporglooTileSize;
end;

procedure TfrmMain.InitializeGamePage;
begin
  MapFrame1.TimerPlayerMove.Enabled := true;

  Viseur.Width := CSporglooTileSize;
  Viseur.height := CSporglooTileSize;
  Viseur.Position.X := CSporglooTileSize *
    (trunc(MapFrame1.Width / CSporglooTileSize) div 2);
  Viseur.Position.Y := CSporglooTileSize *
    (trunc(MapFrame1.height / CSporglooTileSize) div 2);

  lDisplayScoreAndLevels.height := CSporglooTileSize * 0.8;

  lblScore.Score := TGameData.Current.player.Score;
  lblLifeLevel.LifeLevel := TGameData.Current.player.LifeLevel;
  lblStarsCount.StarsCount := TGameData.Current.player.StarsCount;
end;

procedure TfrmMain.InitializeHomePage;
begin
  // TODO : traduire textes
  btnPlay.txtImage.Text := 'PLAY';
  btnQuit.txtImage.Text := 'QUIT';
end;

procedure TfrmMain.InitMainFormCaption;
begin
{$IFDEF DEBUG}
  caption := '[DEBUG] ';
{$ELSE}
  caption := '';
{$ENDIF}
  caption := caption + OlfAboutDialog1.Titre + ' v' +
    OlfAboutDialog1.VersionNumero;
end;

procedure TfrmMain.MiseEnPause;
begin
  ActivePage := TPageType.Home;
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
  MapFrame1.TimerPlayerMove.Enabled := false;

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
    InitializeHomePage;
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

procedure TfrmMain.ShowGameTitle(isVisible: boolean);
begin
  lGameTitle.Visible := isVisible;
  if lGameTitle.Visible then
  begin
    lGameTitle.BringToFront;
    txtImgTitre.Font := dmAdobeStock_526775911.ImageList;
    txtImgTitre.Text := 'SPORGLOO';
  end;
end;

procedure TfrmMain.SubscribeToDisconnect;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TDisconnectMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if not(M is TDisconnectMessage) then
        exit;
      if assigned(TGameData.Current.APIClient) then
      begin
        TGameData.Current.APIClient.free;
        TGameData.Current.APIClient := nil;
      end;
{$IFDEF DEBUG}
      ShowMessage('Serveur disconnected');
{$ENDIF}
      // TODO : afficher un message à l'utilisateur pour lui indiquer que le serveur a demandé la déconnexion
    end);
end;

procedure TfrmMain.SubscribeToLostServerMessage;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TLostServerMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      msg: TLostServerMessage;
      // Client: tsporglooclient;
    begin
      if not(M is TLostServerMessage) then
        exit;
      msg := M as TLostServerMessage;
      if not assigned(msg.Value) then
        exit;
      // Client := Msg.Value;

      // TODO : if connexion failed, retry after a user confirmation or close the program
{$IFDEF DEBUG}
      ShowMessage('Serveur lost');
{$ENDIF}
    end);
end;

procedure TfrmMain.SubscribeToPlayerLevelsUpdates;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TPlayerScoreUpdatedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if M is TPlayerScoreUpdatedMessage then
        lblScore.Score := (M as TPlayerScoreUpdatedMessage).Value;
    end);
  TMessageManager.DefaultManager.SubscribeToMessage
    (TPlayerStarsCountUpdatedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if M is TPlayerStarsCountUpdatedMessage then
        lblStarsCount.StarsCount :=
          (M as TPlayerStarsCountUpdatedMessage).Value;
    end);
  TMessageManager.DefaultManager.SubscribeToMessage
    (TPlayerLifeLevelUpdatedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if M is TPlayerLifeLevelUpdatedMessage then
        lblLifeLevel.LifeLevel := (M as TPlayerLifeLevelUpdatedMessage).Value;
    end);
end;

procedure TfrmMain.SubscribeToServerConnectedMessage;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TServerConnectedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      msg: TServerConnectedMessage;
      Client: tsporglooclient;
      DeviceID, PlayerID: string;
      GameData: TGameData;
    begin
      if not(M is TServerConnectedMessage) then
        exit;
      msg := M as TServerConnectedMessage;
      if not assigned(msg.Value) then
        exit;
      Client := msg.Value;

      GameData := TGameData.Current;

      DeviceID := GameData.player.DeviceID;
      if DeviceID.IsEmpty then
        raise Exception.Create('Unknow device ID !');

      PlayerID := GameData.player.PlayerID;
      if PlayerID.IsEmpty then
        Client.SendClientRegister(DeviceID)
      else
        Client.SendClientLogin(DeviceID, PlayerID);
    end);
end;

procedure TfrmMain.TimerGamePadTimer(Sender: TObject);
var
  GamePadService: IGamolfJoystickService;
  JoystickInfo: TJoystickInfo;
  GameControllerDetected: boolean;
begin
  GameControllerDetected := false;

  if TPlatformServices.Current.SupportsPlatformService(IGamolfJoystickService,
    GamePadService) then
    GamePadService.ForEachConnectedDevice(JoystickInfo,
      procedure(JoystickID: TJoystickID; var JoystickInfo: TJoystickInfo)
      var
        Key: Word;
        KeyChar: widechar;
        DPad: Word;
      begin
        Key := 0;
        KeyChar := #0;
        GameControllerDetected := true;

        if length(JoystickInfo.PressedButtons) > 0 then
        begin
          if ActivePage = TPageType.Game then
            KeyChar := ' '
          else
            Key := vkReturn;
        end
        else
        begin
          DPad := JoystickInfo.DPad;

          if (DPad >= 360) and (length(JoystickInfo.Axes) >= 2) then
            DPad := GamePadService.getDPadFromXY(JoystickInfo.Axes[0],
              JoystickInfo.Axes[1]);

          if (DPad < 360) then // angle between 0 and 359°
          begin
            if GamePadService.isDPad(DPad, [TJoystickDPad.LeftTop,
              TJoystickDPad.Left, TJoystickDPad.LeftBottom]) then
              Key := vkLeft
            else if GamePadService.isDPad(DPad, [TJoystickDPad.RightTop,
              TJoystickDPad.Right, TJoystickDPad.RightBottom]) then
              Key := vkRight
            else if GamePadService.isDPad(DPad, [TJoystickDPad.TopLeft,
              TJoystickDPad.Top, TJoystickDPad.TopRight]) then
              Key := vkUp
            else if GamePadService.isDPad(DPad, [TJoystickDPad.BottomLeft,
              TJoystickDPad.Bottom, TJoystickDPad.BottomRight]) then
              Key := vkDown;
          end;
        end;

        if ((Key <> 0) or (KeyChar <> #0)) then
        begin
          if ((Key <> FPreviousGamePadKey) or
            (KeyChar <> FPreviousGamePadKeyChar)) then
          begin
            // TODO : ajouter une tempo entre deux actions ou voir lesquelles temporiser (exemple boutons mais pas déplacements)
            FPreviousGamePadKey := Key;
            FPreviousGamePadKeyChar := KeyChar;
            FPreviousGamePadTempo := 300; // en millisecondes
            // TODO : paramétrer le temps entre deux actions au joystick

            FormKeyDown(Sender, Key, KeyChar, []);
          end
          else
          begin
            FPreviousGamePadTempo := FPreviousGamePadTempo -
              TimerGamePad.Interval;
            if FPreviousGamePadTempo < 0 then
            begin
              FPreviousGamePadKey := 0;
              FPreviousGamePadKeyChar := #0;
            end;
          end;
        end
        else
        begin
          FPreviousGamePadKey := 0;
          FPreviousGamePadKeyChar := #0;
        end;
      end)
  else
    TimerGamePad.Enabled := false;

  if (GameControllerDetected <> GameControllerPicture.Visible) then
  begin
    GameControllerPicture.Position.X := ClientWidth -
      GameControllerPicture.Width - 5;
    GameControllerPicture.Position.Y := 5;
    GameControllerPicture.BringToFront;
    GameControllerPicture.Visible := GameControllerDetected;
    GameControllerPicture.Anchors := [TAnchorKind.akTop, TAnchorKind.akright];
    // TODO : faire une tempo sur l'affichage
    // TODO : changer de visuel quand un joystick n'est plus détecté et qu'il y en avait avant
  end;
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
