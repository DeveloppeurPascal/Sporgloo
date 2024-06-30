unit uGameData;

interface

uses
  Sporgloo.Types,
  Sporgloo.Database,
  Sporgloo.Client,
  Olf.Net.Socket.Messaging;

type
  TGameData = class
  private
    FViewportX: TSporglooAPINumber;
    FViewportY: TSporglooAPINumber;
    FViewportNbCol: TSporglooAPINumber;
    FViewportNbRow: TSporglooAPINumber;
    FViewportXMax: TSporglooAPINumber;
    FViewportYMax: TSporglooAPINumber;
    procedure SetViewportNbCol(const Value: TSporglooAPINumber);
    procedure SetViewportNbRow(const Value: TSporglooAPINumber);
    procedure SetViewportX(const Value: TSporglooAPINumber);
    procedure SetViewportY(const Value: TSporglooAPINumber);
  protected
    constructor Create;
    destructor Destroy; override;
    procedure DoClientConnected(const AClient: TOlfSMSrvConnectedClient);
    procedure DoClientLostConnection(const AClient: TOlfSMSrvConnectedClient);
  public
    APIClient: tSporglooClient;

    Player: TSporglooPlayer;
    Session: TSporglooSession;
    Map: TSporglooMap;
    OtherPlayers: TSporglooPlayersList;
    // TODO : add a stars list (add/remove depending on MapCell updates and player moves)

    property ViewportX: TSporglooAPINumber read FViewportX write SetViewportX;
    property ViewportY: TSporglooAPINumber read FViewportY write SetViewportY;
    property ViewportXMax: TSporglooAPINumber read FViewportXMax;
    property ViewportYMax: TSporglooAPINumber read FViewportYMax;
    property ViewportNbCol: TSporglooAPINumber read FViewportNbCol
      write SetViewportNbCol;
    property ViewportNbRow: TSporglooAPINumber read FViewportNbRow
      write SetViewportNbRow;

    /// <summary>
    /// Get current GameData instance and create one if needed.
    /// </summary>
    class function Current: TGameData;
    /// <summary>
    /// Kill current GameData instance and create a new one
    /// </summary>
    class procedure Restart;

    function isServerConnected: boolean;

    procedure CenterViewPort;

    procedure RefreshMap;
    procedure GetInfosPlayer(const PlayerID: string);
  end;

implementation

uses
  FMX.Forms,
  system.SyncObjs,
  system.SysUtils,
  system.Generics.Collections,
  system.Messaging,
  uConfig,
  Sporgloo.Messaging,
  system.Classes,
  Sporgloo.Consts,
  cShowMessageBox;

var
  GameDataInstance: TGameData;
  Mutex: TMutex;

  { TGameData }

procedure TGameData.CenterViewPort;
begin
  if assigned(Player) then
  begin
    ViewportX := Player.PlayerX - (ViewportNbCol div 2);
    ViewportY := Player.PlayerY - (ViewportNbRow div 2);
  end
  else
  begin
    ViewportX := 0 - (ViewportNbCol div 2);
    ViewportY := 0 - (ViewportNbRow div 2);
  end;
end;

constructor TGameData.Create;
begin
  Player := TSporglooPlayer.Create;
  Player.DeviceID := TConfig.Current.DeviceID;
  Player.PlayerID := TConfig.Current.PlayerID;

  Session := TSporglooSession.Create;
  Session.Player := Player;

  Map := TSporglooMap.Create;

  OtherPlayers := TSporglooPlayersList.Create([doownsvalues]);

  APIClient := tSporglooClient.Create(TConfig.Current.ServerIPv4,
    TConfig.Current.ServerIPv4port);
  // TODO : add a connection on IPv6 if available
  APIClient.onConnected := DoClientConnected;
  APIClient.onLostConnection := DoClientLostConnection;

  try
    APIClient.Connect;
  except
    TThread.ForceQueue(nil,
      procedure
      begin
        TcadShowMessageBox.ShowModal(application.mainform as TForm,
          'Can''t connect to the server. The game will stop. Please try again later.',
          procedure
          begin
            (application.mainform as TForm).Close;
          end);
      end);
  end;
end;

class function TGameData.Current: TGameData;
begin
  if not assigned(GameDataInstance) then
  begin
    Mutex.Acquire;
    try
      GameDataInstance := TGameData.Create;
    finally
      Mutex.Release;
    end;
  end;
  result := GameDataInstance;
end;

destructor TGameData.Destroy;
begin
  // APIClient.Free;
  // APIClient is a TThread with "FreeOnTerminate", don't free it again !

  OtherPlayers.Free;
  OtherPlayers := nil;

  Map.Free;
  Map := nil;

  Session.Free;
  Session := nil;

  Player.Free;
  Player := nil;

  inherited;
end;

procedure TGameData.DoClientConnected(const AClient: TOlfSMSrvConnectedClient);
begin
  if not(AClient is tSporglooClient) then
    exit;

  TThread.ForceQueue(nil,
    procedure
    begin
      TMessageManager.DefaultManager.SendMessage(self,
        TServerConnectedMessage.Create(AClient as tSporglooClient));
    end);
end;

procedure TGameData.DoClientLostConnection(const AClient
  : TOlfSMSrvConnectedClient);
begin
  if not(AClient is tSporglooClient) then
    exit;

  TThread.ForceQueue(nil,
    procedure
    begin
      TMessageManager.DefaultManager.SendMessage(self,
        TLostServerMessage.Create(AClient as tSporglooClient));
    end);
end;

procedure TGameData.GetInfosPlayer(const PlayerID: string);
begin
  if not PlayerID.isempty then
    APIClient.SendAskForPlayerInfos(Session.SessionID, PlayerID);
end;

function TGameData.isServerConnected: boolean;
begin
  result := assigned(APIClient) and APIClient.isConnected;
end;

procedure TGameData.RefreshMap;
begin
  if not assigned(APIClient) then
    exit;

  TGameData.Current.CenterViewPort;

  TThread.queue(nil,
    procedure
    begin
      TMessageManager.DefaultManager.SendMessage(self,
        TMapUpdateMessage.Create);
    end);

  APIClient.SendMapRefresh(ViewportX - CColMargins, ViewportY - CRowMargins,
    ViewportNbCol + 2 * CColMargins, ViewportNbRow + 2 * CRowMargins,
    TGameData.Current.Session.SessionID);
end;

class procedure TGameData.Restart;
begin
  TThread.queue(nil,
    procedure
    begin
      if assigned(GameDataInstance) then
      begin
        Mutex.Acquire;
        try
          GameDataInstance.Free;
          GameDataInstance := nil;
        except
          Mutex.Release;
        end;
      end;
      Current;
    end);
end;

procedure TGameData.SetViewportNbCol(const Value: TSporglooAPINumber);
begin
  FViewportNbCol := Value;
  FViewportXMax := FViewportX + FViewportNbCol - 1;
end;

procedure TGameData.SetViewportNbRow(const Value: TSporglooAPINumber);
begin
  FViewportNbRow := Value;
  FViewportYMax := FViewportY + FViewportNbRow - 1;
end;

procedure TGameData.SetViewportX(const Value: TSporglooAPINumber);
begin
  FViewportX := Value;
  FViewportXMax := FViewportX + FViewportNbCol - 1;
end;

procedure TGameData.SetViewportY(const Value: TSporglooAPINumber);
begin
  FViewportY := Value;
  FViewportYMax := FViewportY + FViewportNbRow - 1;
end;

initialization

Mutex := TMutex.Create;
GameDataInstance := nil;

finalization

GameDataInstance.Free;
Mutex.Free;

end.
