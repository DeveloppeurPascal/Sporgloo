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
  cYellowGameButtonMusicOnOff,
  FMX.Effects;

type
{$SCOPEDENUMS ON}
  TPageType = (None, Home, Game, NewGame, Credits, Scores, Options);

  TfrmMain = class(TForm)
    MapFrame1: TMapFrame;
    HomePage: TLayout;
    GamePage: TLayout;
    WaitPage: TLayout;
    WaitAnimation: TAniIndicator;
    txtImgTitre: TOlfFMXTextImageFrame;
    lGameTitle: TLayout;
    Layout1: TLayout;
    gbHomeMenuButtons: TcadGrayBox;
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
    btnNewGame: TcadYellowMenuButton;
    btnCredits: TcadYellowMenuButton;
    btnHallOfFame: TcadYellowMenuButton;
    btnOptions: TcadYellowMenuButton;
    Label1: TLabel;
    GlowEffect1: TGlowEffect;
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
    procedure OlfAboutDialog1URLClick(const AURL: string);
    procedure btnNewGameClick(Sender: TObject);
    procedure btnCreditsClick(Sender: TObject);
    procedure btnHallOfFameClick(Sender: TObject);
    procedure btnOptionsClick(Sender: TObject);
    procedure MapFrame1TimerPlayerMoveTimer(Sender: TObject);
  private
    FActivePage: TPageType;
    FPreviousGamePadKey: Word;
    FPreviousGamePadKeyChar: widechar;
    FPreviousGamePadTempo: int64;
    procedure SetActivePage(const Value: TPageType);
    property ActivePage: TPageType read FActivePage write SetActivePage;
    procedure ShowGameTitle(isVisible: boolean = true);
    procedure InitializeGamePage;
    procedure ShowNewGamePage;
    procedure ShowCreditsPage;
    procedure ShowHallOfFamePage;
    procedure ShowOptionsPage;
    procedure InitializeHomePage;
    procedure InitMainFormCaption;
    procedure MiseEnPause;
    procedure InitAboutDialogBox;
  protected
    procedure SubscribeToServerConnectedMessage;
    procedure SubscribeToLostServerMessage;
    procedure SubscribeToDisconnect;
    procedure SubscribeToPlayerLevelsUpdates;
    procedure SubscribeToLoginOkMessage;
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
  Olf.FMX.AboutDialogForm,
  u_urlOpen,
  cShowMessageBox,
  cShowYesNoBox,
  USVGPersos,
  cChoosePlayerImageID;

procedure TfrmMain.btnCreditsClick(Sender: TObject);
begin
  ActivePage := TPageType.Credits;
end;

procedure TfrmMain.btnHallOfFameClick(Sender: TObject);
begin
  ActivePage := TPageType.Scores;
end;

procedure TfrmMain.btnNewGameClick(Sender: TObject);
begin
  ActivePage := TPageType.NewGame;
end;

procedure TfrmMain.btnOptionsClick(Sender: TObject);
begin
  ActivePage := TPageType.Options;
end;

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
  TBackgroundMusic.current.OnOff(not tconfig.current.BackgroundMusic);
end;

procedure TfrmMain.cadYellowGameButtonPause1Click(Sender: TObject);
begin
  MiseEnPause;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  msg: TLogoffMessage;
begin
  if assigned(tgamedata.current.APIClient) then
    try
      msg := TLogoffMessage.Create;
      try
        try
          tgamedata.current.APIClient.SendMessage(msg);
        except
        end;
      finally
        msg.free;
      end;
      tgamedata.current.APIClient.free;
    finally
      tgamedata.current.APIClient := nil;
    end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitMainFormCaption;
  InitAboutDialogBox;

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
  SubscribeToLoginOkMessage;

  TThread.ForceQueue(nil,
    procedure
    begin
      tgamedata.restart;
      ActivePage := TPageType.Home;
    end);

  TBackgroundMusic.current.OnOff(tconfig.current.BackgroundMusic);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkF1) then
  begin
    OlfAboutDialog1.Execute;
    Key := 0;
    KeyChar := #0;
  end
  else if ((Key = vkReturn) or (KeyChar = ' ')) and (ActivePage = TPageType.Home)
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
  GameData: tgamedata;
  MapCell: TSporglooMapCell;
begin
  Viseur.Position.X := trunc(X / CSporglooTileSize) * CSporglooTileSize;
  Viseur.Position.Y := trunc(Y / CSporglooTileSize) * CSporglooTileSize;

  GameData := tgamedata.current;
  if (GameData.Player.StarsCount > 0) then
  begin
    MapX := trunc(X / CSporglooTileSize) + GameData.ViewportX;
    MapY := trunc(Y / CSporglooTileSize) + GameData.ViewportY;

    MapCell := GameData.Map.GetCellAt(MapX, MapY);

    if (MapCell.TileID in [CSporglooTileForest, CSporglooTilePath]) and
      MapCell.PlayerID.IsEmpty then
    begin
      GameData.APIClient.SendPlayerPutAStar(GameData.Session.SessionID,
        GameData.Player.PlayerID, MapX, MapY);

      GameData.Player.StarsCount := GameData.Player.StarsCount - 1;
    end;
  end;
end;

procedure TfrmMain.GamePageMouseMove(Sender: TObject; Shift: TShiftState;
X, Y: Single);
begin
  Viseur.Position.X := trunc(X / CSporglooTileSize) * CSporglooTileSize;
  Viseur.Position.Y := trunc(Y / CSporglooTileSize) * CSporglooTileSize;
end;

procedure TfrmMain.InitAboutDialogBox;
begin
  // TODO : traduire texte(s)
  OlfAboutDialog1.Licence.Text :=
    'This program is distributed as shareware. If you use it (especially for ' +
    'commercial or income-generating purposes), please remember the author and '
    + 'contribute to its development by purchasing a license.' + slinebreak +
    slinebreak +
    'This software is supplied as is, with or without bugs. No warranty is offered '
    + 'as to its operation or the data processed. Make backups!';
  OlfAboutDialog1.Description.Text := 'Sporgloo is an online multi player game.'
    + slinebreak + slinebreak + '*****************' + slinebreak +
    '* Publisher info' + slinebreak + slinebreak +
    'This application was developed by Patrick Pr�martin.' + slinebreak +
    slinebreak +
    'It is published by OLF SOFTWARE, a company registered in Paris (France) under the reference 439521725.'
    + slinebreak + slinebreak + '****************' + slinebreak +
    '* Personal data' + slinebreak + slinebreak +
    'This program is autonomous in its current version. It does not depend on the Internet and communicates nothing to the outside world.'
    + slinebreak + slinebreak + 'We have no knowledge of what you do with it.' +
    slinebreak + slinebreak +
    'No information about you is transmitted to us or to any third party.' +
    slinebreak + slinebreak +
    'We use no cookies, no tracking, no stats on your use of the application.' +
    slinebreak + slinebreak + '***************' + slinebreak + '* User support'
    + slinebreak + slinebreak +
    'If you have any questions or require additional functionality, please leave us a message on the application''s website or on its code repository.'
    + slinebreak + slinebreak + 'To find out more, visit ' +
    OlfAboutDialog1.URL;
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

  lblScore.Score := tgamedata.current.Player.CoinsCount;
  lblLifeLevel.LifeLevel := tgamedata.current.Player.LivesCount;
  lblStarsCount.StarsCount := tgamedata.current.Player.StarsCount;

  if (tgamedata.current.Player.ImageID < 0) or
    (tgamedata.current.Player.ImageID >= length(SVGPersos)) then
    TThread.ForceQueue(nil,
      procedure
      begin
        TcadChoosePlayerImageID.Execute(self);
      end);
end;

procedure TfrmMain.InitializeHomePage;
begin
  // TODO : traduire textes
  btnPlay.txtImage.Text := 'PLAY';
  btnPlay.Visible := tgamedata.current.isServerConnected;
  btnNewGame.txtImage.Text := 'NEW GAME';
  btnNewGame.Visible := (tconfig.current.PlayerID <> '');
  btnOptions.txtImage.Text := 'OPTIONS';
  btnOptions.Visible := false; // TODO : r�activer l'�cran des options
  btnHallOfFame.txtImage.Text := 'HALL OF FAME';
  btnHallOfFame.Visible := false; // TODO : r�activer l'�cran des scores
  btnCredits.txtImage.Text := 'CREDITS';
  btnQuit.txtImage.Text := 'QUIT';
{$IF Defined(IOS) or Defined(ANDROID)}
  btnQuit.Visible := false;
{$ENDIF}
  gbHomeMenuButtons.AutoHeight;
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

procedure TfrmMain.MapFrame1TimerPlayerMoveTimer(Sender: TObject);
begin
  MapFrame1.TimerPlayerMoveTimer(Sender);
  Label1.Text := tgamedata.current.Player.PlayerX.ToString + ',' +
    tgamedata.current.Player.Playery.ToString + ' ' +
    tgamedata.current.ViewportX.ToString + ',' +
    tgamedata.current.ViewportY.ToString + ' ' +
    tgamedata.current.ViewportXMax.ToString + ',' +
    tgamedata.current.ViewportYMax.ToString;
  // TODO : retirer Label 1 (info de d�bogage pour versions alpha)
end;

procedure TfrmMain.MiseEnPause;
begin
  ActivePage := TPageType.Home;
end;

procedure TfrmMain.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
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
    ShowNewGamePage;

  if Value = TPageType.Credits then
    ShowCreditsPage;

  if Value = TPageType.Scores then
    ShowHallOfFamePage;

  if Value = TPageType.Options then
    ShowOptionsPage;

  FActivePage := Value;
end;

procedure TfrmMain.ShowCreditsPage;
var
  Text: string;
begin
  Text := OlfAboutDialog1.Description.Text.trim + slinebreak + slinebreak +
    '**********' + slinebreak + '* License' + slinebreak + slinebreak +
    OlfAboutDialog1.Licence.Text.trim + slinebreak + slinebreak + 'v' +
    OlfAboutDialog1.VersionNumero + '-' + OlfAboutDialog1.VersionDate;

  TcadShowMessageBox.ShowModal(self, Text,
    procedure
    begin
      ActivePage := TPageType.Home;
    end);
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

procedure TfrmMain.ShowHallOfFamePage;
begin
  // TODO : � compl�ter
  ActivePage := TPageType.Home;
end;

procedure TfrmMain.ShowNewGamePage;
begin
  // TODO : traduire texte
  TcadShowYesNoBox.ShowModal(self, 'Starting a new game will erase current one.'
    + slinebreak + 'Are you sure you want to loose your current game ?',
    procedure
    begin
      btnPlay.Visible := false;
      tgamedata.current.APIClient.SendKillCurrentPlayer
        (tgamedata.current.Session.SessionID,
        tgamedata.current.Player.PlayerID);
      // TODO : remplacer cette fen�tre par un �cran d'attente, lancer le jeu une fos le TLoginOKMesage re�u et fermer cette fen�tre
      TcadShowMessageBox.ShowModal(self, 'Current game will be destroyed.' +
        slinebreak + 'A new game will restart soon.',
        procedure
        begin
          ActivePage := TPageType.Home;
        end);
    end,
    procedure
    begin
      TcadShowMessageBox.ShowModal(self,
        'Use "Play" button to continue your current game.',
        procedure
        begin
          ActivePage := TPageType.Home;
        end);
    end);
end;

procedure TfrmMain.ShowOptionsPage;
begin
  // TODO : � compl�ter
  ActivePage := TPageType.Home;
end;

procedure TfrmMain.SubscribeToDisconnect;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TDisconnectMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if not(M is TDisconnectMessage) then
        exit;
      if assigned(tgamedata.current.APIClient) then
      begin
        tgamedata.current.APIClient.free;
        tgamedata.current.APIClient := nil;
      end;
      TcadShowMessageBox.ShowModal(self,
        'The server is down. The game will close. Please retry later.',
        procedure
        begin
          Close;
        end);
    end);
end;

procedure TfrmMain.SubscribeToLoginOkMessage;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TLoginOKMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      btnPlay.Visible := true;
      MapFrame1.TimerMapRefresh.Enabled := true;
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

      TcadShowMessageBox.ShowModal(self,
        'Server lost. The game will close. Please retry later.',
        procedure
        begin
          Close;
        end);
    end);
end;

procedure TfrmMain.SubscribeToPlayerLevelsUpdates;
begin
  TMessageManager.DefaultManager.SubscribeToMessage
    (TPlayerCoinsCountUpdatedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if M is TPlayerCoinsCountUpdatedMessage then
        lblScore.Score := (M as TPlayerCoinsCountUpdatedMessage).Value;
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
    (TPlayerLivesCountUpdatedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if M is TPlayerLivesCountUpdatedMessage then
        lblLifeLevel.LifeLevel := (M as TPlayerLivesCountUpdatedMessage).Value;
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
      GameData: tgamedata;
    begin
      if not(M is TServerConnectedMessage) then
        exit;
      msg := M as TServerConnectedMessage;
      if not assigned(msg.Value) then
        exit;
      Client := msg.Value;

      GameData := tgamedata.current;

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

procedure TfrmMain.TimerGamePadTimer(Sender: TObject);
var
  GamePadService: IGamolfJoystickService;
  JoystickInfo: TJoystickInfo;
  GameControllerDetected: boolean;
begin
  GameControllerDetected := false;

  if TPlatformServices.current.SupportsPlatformService(IGamolfJoystickService,
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

          if (DPad < 360) then // angle between 0 and 359�
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
            // TODO : ajouter une tempo entre deux actions ou voir lesquelles temporiser (exemple boutons mais pas d�placements)
            FPreviousGamePadKey := Key;
            FPreviousGamePadKeyChar := KeyChar;
            FPreviousGamePadTempo := 300; // en millisecondes
            // TODO : param�trer le temps entre deux actions au joystick

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
    // TODO : changer de visuel quand un joystick n'est plus d�tect� et qu'il y en avait avant
  end;
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
