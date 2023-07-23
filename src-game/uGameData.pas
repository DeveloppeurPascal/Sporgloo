unit uGameData;

interface

uses
  Sporgloo.Types,
  Sporgloo.Database,
  uClientSocket;

type
  TGameData = class
  private
  protected
  public
    APIClient: tSporglooAPIClient;

    Player: TSporglooPlayer;
    Session: TSporglooSession;
    Map: TSporglooMap;
    OtherPlayers: TSporglooPlayersList;

    class function Current: TGameData;
    constructor Create;
    destructor Destroy; override;

    procedure RefreshMap;
  end;

implementation

uses
  System.Generics.Collections,
  uConfig;

var
  GameDataInstance: TGameData;

  { TGameData }

constructor TGameData.Create;
begin
  Player := TSporglooPlayer.Create;
  Player.DeviceID := TConfig.Current.DeviceID;
  Player.PlayerID := TConfig.Current.PlayerID;

  Session := TSporglooSession.Create;
  Session.DeviceID := TConfig.Current.DeviceID;
  Session.PlayerID := TConfig.Current.PlayerID;

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

procedure TGameData.RefreshMap;
begin
  if not assigned(APIClient) then
    exit;

  APIClient.SendMapRefresh(Session.MapRangeX, Session.MapRangeY,
    Session.MapRangeColNumber, Session.MapRangeRowNumber);
end;

initialization

GameDataInstance := nil;

finalization

GameDataInstance.Free;

end.
