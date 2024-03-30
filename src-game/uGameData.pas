unit uGameData;

interface

uses
  Sporgloo.Types,
  Sporgloo.Database,
  Sporgloo.Client;

type
  TGameData = class
  private
  protected
  public
    APIClient: tSporglooClient;

    Player: TSporglooPlayer;
    Session: TSporglooSession;
    Map: TSporglooMap;
    OtherPlayers: TSporglooPlayersList;

    class function Current: TGameData;
    constructor Create;
    destructor Destroy; override;

    function isServerConnected: boolean;

    procedure RefreshMap;
  end;

implementation

uses
  System.Generics.Collections,
  System.Messaging,
  uConfig,
  Sporgloo.Messaging;

var
  GameDataInstance: TGameData;

  { TGameData }

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

  APIClient.SendMapRefresh(Session.MapRangeX, Session.MapRangeY,
    Session.MapRangeColNumber, Session.MapRangeRowNumber);

  TMessageManager.DefaultManager.SendMessage(Self, TMapUpdateMessage.Create);
end;

initialization

GameDataInstance := nil;

finalization

GameDataInstance.Free;

end.
