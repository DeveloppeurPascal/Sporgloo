unit uGameData;

interface

uses
  Sporgloo.Types,
  Sporgloo.Database,
  Sporgloo.Client;

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
  public
    APIClient: tSporglooClient;

    Player: TSporglooPlayer;
    Session: TSporglooSession;
    Map: TSporglooMap;
    OtherPlayers: TSporglooPlayersList;

    property ViewportX: TSporglooAPINumber read FViewportX write SetViewportX;
    property ViewportY: TSporglooAPINumber read FViewportY write SetViewportY;
    property ViewportXMax: TSporglooAPINumber read FViewportXMax;
    property ViewportYMax: TSporglooAPINumber read FViewportYMax;
    property ViewportNbCol: TSporglooAPINumber read FViewportNbCol
      write SetViewportNbCol;
    property ViewportNbRow: TSporglooAPINumber read FViewportNbRow
      write SetViewportNbRow;

    class function Current: TGameData;

    function isServerConnected: boolean;

    procedure CenterViewPort;

    procedure RefreshMap;
  end;

implementation

uses
  System.Generics.Collections,
  System.Messaging,
  uConfig,
  Sporgloo.Messaging,
  System.Classes;

var
  GameDataInstance: TGameData;

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

  APIClient := nil;
end;

class function TGameData.Current: TGameData;
begin
  if not assigned(GameDataInstance) then
    GameDataInstance := TGameData.Create;
  result := GameDataInstance;
end;

destructor TGameData.Destroy;
begin
  // APIClient.Free;
  // APIClient is a TThread with "FreeOnTerminate", don't free it again !
  OtherPlayers.Free;
  Map.Free;
  Session.Free;
  Player.Free;
  inherited;
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

  tthread.queue(nil,
    procedure
    begin
      TMessageManager.DefaultManager.SendMessage(Self,
        TMapUpdateMessage.Create);
    end);

  APIClient.SendMapRefresh(ViewportX, ViewportY, ViewportNbCol, ViewportNbRow);
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

GameDataInstance := nil;

finalization

GameDataInstance.Free;

end.
