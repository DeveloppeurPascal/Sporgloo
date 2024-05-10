unit Sporgloo.Database;

interface

uses
  System.Classes,
  System.Generics.Collections,
  Sporgloo.Types,
  Olf.Net.Socket.Messaging;

type
  TSporglooPlayer = class
  private const
    CVersion = 1;

  var
    FLifesCount: TSporglooAPINumber;
    FCoinsCount: TSporglooAPINumber;
    FPlayerID: string;
    FPlayerX: TSporglooAPINumber;
    FPlayerY: TSporglooAPINumber;
    FStarsCount: TSporglooAPINumber;
    FDeviceID: string;
    FTargetX: TSporglooAPINumber;
    FTargety: TSporglooAPINumber;
    procedure SetTargetX(const Value: TSporglooAPINumber);
    procedure SetTargety(const Value: TSporglooAPINumber);
    procedure SetDeviceID(const Value: string);
    procedure SetLifesCount(const Value: TSporglooAPINumber);
    procedure SetPlayerID(const Value: string);
    procedure SetPlayerX(const Value: TSporglooAPINumber);
    procedure SetPlayerY(const Value: TSporglooAPINumber);
    procedure SetCoinsCount(const Value: TSporglooAPINumber);
    procedure SetStarsCount(const Value: TSporglooAPINumber);
  protected
  public
    property DeviceID: string read FDeviceID write SetDeviceID;
    property PlayerID: string read FPlayerID write SetPlayerID;
    property PlayerX: TSporglooAPINumber read FPlayerX write SetPlayerX;
    property PlayerY: TSporglooAPINumber read FPlayerY write SetPlayerY;
    property TargetX: TSporglooAPINumber read FTargetX write SetTargetX;
    property Targety: TSporglooAPINumber read FTargety write SetTargety;
    Property CoinsCount: TSporglooAPINumber read FCoinsCount
      write SetCoinsCount;
    property StarsCount: TSporglooAPINumber read FStarsCount
      write SetStarsCount;
    property LifesCount: TSporglooAPINumber read FLifesCount
      write SetLifesCount;

    procedure TestAndChangeTarget(AX, AY: TSporglooAPINumber);

    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);

    constructor Create;
  end;

  TSporglooPlayersList = class(TObjectDictionary<string, TSporglooPlayer>)
  private const
    CVersion = 1;
  protected
  public
    function GetPlayerByDevice(ADeviceID: string): TSporglooPlayer;
    function GetPlayer(APlayerID: string): TSporglooPlayer;

    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TSporglooMapRow = class(TObjectDictionary<TSporglooAPINumber,
    TSporglooMapCell>)
  private const
    CVersion = 2;
  protected
    FRowKey: TSporglooAPINumber;
  public
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    constructor Create(ARowKey: TSporglooAPINumber);
  end;

  TSporglooMapCol = class(TObjectDictionary<TSporglooAPINumber,
    TSporglooMapRow>)
  private const
    CVersion = 1;
  protected
  public
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TSporglooMap = class
  private const
    CVersion = 2;

  var
    FCell: TSporglooMapCol;
  protected
  public
    function GetCellAt(AX, AY: TSporglooAPINumber): TSporglooMapCell;

    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);

    constructor Create;
    destructor Destroy; override;
  end;

  TSporglooSession = class
  private
    FSessionID: string;
    FSocketClient: TOlfSocketMessagingServerConnectedClient;
    FPlayer: TSporglooPlayer;
    procedure SetSessionID(const Value: string);
    procedure SetSocketClient(const Value
      : TOlfSocketMessagingServerConnectedClient);
    procedure SetPlayer(const Value: TSporglooPlayer);
  protected
  public
    property SessionID: string read FSessionID write SetSessionID;
    property SocketClient: TOlfSocketMessagingServerConnectedClient
      read FSocketClient write SetSocketClient;
    property Player: TSporglooPlayer read FPlayer write SetPlayer;
    constructor Create;
    destructor Destroy; override;
  end;

  TSporglooSessionsList = class(TObjectDictionary<string, TSporglooSession>)
  private
  protected
  public
  end;

implementation

{ TSporglooPlayer }

uses
  Olf.RTL.Streams,
  Sporgloo.API.Messages,
  Sporgloo.Consts,
  Sporgloo.Messaging,
  System.Messaging;

constructor TSporglooPlayer.Create;
begin
  inherited;
  FLifesCount := 0;
  FCoinsCount := 0;
  FPlayerID := '';
  FPlayerX := 0;
  FPlayerY := 0;
  FStarsCount := 0;
  FDeviceID := '';

  FTargetX := 0;
  FTargety := 0;
end;

procedure TSporglooPlayer.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
begin
  System.tmonitor.Enter(self);
  try
    if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
      VersionNum := -1; // pas d'info de version, fichier de sauvegarde foireux

    if not((VersionNum >= 0) and (sizeof(FLifesCount) = AStream.
      read(FLifesCount, sizeof(FLifesCount)))) then
      FLifesCount := 0;

    if not((VersionNum >= 0) and (sizeof(FCoinsCount) = AStream.
      read(FCoinsCount, sizeof(FCoinsCount)))) then
      FCoinsCount := 0;

    if not(VersionNum >= 0) then
      FPlayerID := ''
    else
      FPlayerID := LoadStringFromStream(AStream);

    if not((VersionNum >= 0) and (sizeof(FPlayerX) = AStream.read(FPlayerX,
      sizeof(FPlayerX)))) then
      FPlayerX := 0;

    if not((VersionNum >= 0) and (sizeof(FPlayerY) = AStream.read(FPlayerY,
      sizeof(FPlayerY)))) then
      FPlayerY := 0;

    if not((VersionNum >= 0) and (sizeof(FStarsCount) = AStream.
      read(FStarsCount, sizeof(FStarsCount)))) then
      FStarsCount := 0;

    if not(VersionNum >= 0) then
      FDeviceID := ''
    else
      FDeviceID := LoadStringFromStream(AStream);
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooPlayer.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
begin
  System.tmonitor.Enter(self);
  try
    VersionNum := CVersion;
    AStream.Write(VersionNum, sizeof(VersionNum));
    AStream.Write(FLifesCount, sizeof(FLifesCount));
    AStream.Write(FCoinsCount, sizeof(FCoinsCount));
    SaveStringToStream(FPlayerID, AStream);
    AStream.Write(FPlayerX, sizeof(FPlayerX));
    AStream.Write(FPlayerY, sizeof(FPlayerY));
    AStream.Write(FStarsCount, sizeof(FStarsCount));
    SaveStringToStream(FDeviceID, AStream);
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooPlayer.SetDeviceID(const Value: string);
begin
  System.tmonitor.Enter(self);
  try
    FDeviceID := Value;
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooPlayer.SetLifesCount(const Value: TSporglooAPINumber);
begin
  System.tmonitor.Enter(self);
  try
    FLifesCount := Value;
  finally
    System.tmonitor.Exit(self);
  end;
  if SporglooProjectType = TSporglooProjectType.Client then
    tthread.ForceQueue(nil,
      procedure
      begin
        TMessageManager.DefaultManager.SendMessage(nil,
          TPlayerLifesCountUpdatedMessage.Create(Value));
      end);
end;

procedure TSporglooPlayer.SetPlayerID(const Value: string);
begin
  System.tmonitor.Enter(self);
  try
    FPlayerID := Value;
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooPlayer.SetPlayerX(const Value: TSporglooAPINumber);
begin
  System.tmonitor.Enter(self);
  try
    FPlayerX := Value;
    // TODO : si pas d'étoile dans la map affichée, positionner la target sur les coordonnées du joueur
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooPlayer.SetPlayerY(const Value: TSporglooAPINumber);
begin
  System.tmonitor.Enter(self);
  try
    FPlayerY := Value;
    // TODO : si pas d'étoile dans la map affichée, positionner la target sur les coordonnées du joueur
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooPlayer.SetCoinsCount(const Value: TSporglooAPINumber);
begin
  System.tmonitor.Enter(self);
  try
    FCoinsCount := Value;
  finally
    System.tmonitor.Exit(self);
  end;
  if SporglooProjectType = TSporglooProjectType.Client then
    tthread.ForceQueue(nil,
      procedure
      begin
        TMessageManager.DefaultManager.SendMessage(nil,
          TPlayerCoinsCountUpdatedMessage.Create(Value));
      end);
end;

procedure TSporglooPlayer.SetStarsCount(const Value: TSporglooAPINumber);
begin
  System.tmonitor.Enter(self);
  try
    FStarsCount := Value;
  finally
    System.tmonitor.Exit(self);
  end;
  if SporglooProjectType = TSporglooProjectType.Client then
    tthread.ForceQueue(nil,
      procedure
      begin
        TMessageManager.DefaultManager.SendMessage(nil,
          TPlayerStarsCountUpdatedMessage.Create(Value));
      end);
end;

procedure TSporglooPlayer.SetTargetX(const Value: TSporglooAPINumber);
begin
  FTargetX := Value;
end;

procedure TSporglooPlayer.SetTargety(const Value: TSporglooAPINumber);
begin
  FTargety := Value;
end;

procedure TSporglooPlayer.TestAndChangeTarget(AX, AY: TSporglooAPINumber);
var
  DistanceTarget, DistanceStar: extended;
begin
  DistanceStar := sqrt(sqr(abs(PlayerX - AX)) + sqr(abs(PlayerY - AY)));

  // TODO : calculer distance à la target uniquement après changement de la target, pas à chaque comparaison
  if (TargetX = PlayerX) and (Targety = PlayerY) then
    DistanceTarget := DistanceStar + 1
  else
    DistanceTarget := sqrt(sqr(abs(PlayerX - TargetX)) +
      sqr(abs(PlayerY - Targety)));

  if DistanceStar < DistanceTarget then
  begin
    TargetX := AX;
    Targety := AY;
  end;
end;

{ TSporglooPlayersList }

function TSporglooPlayersList.GetPlayer(APlayerID: string): TSporglooPlayer;
begin
  System.tmonitor.Enter(self);
  try
    if not TryGetValue(APlayerID, result) then
      result := nil;
  finally
    System.tmonitor.Exit(self);
  end;
end;

function TSporglooPlayersList.GetPlayerByDevice(ADeviceID: string)
  : TSporglooPlayer;
var
  key: string;
begin
  System.tmonitor.Enter(self);
  try
    result := nil;
    if (Count > 0) then
      for key in keys do
        if items[key].DeviceID = ADeviceID then
        begin
          result := items[key];
          break;
        end;
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooPlayersList.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  Player: TSporglooPlayer;
begin
  System.tmonitor.Enter(self);
  try
    if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
      VersionNum := -1;
    // pas d'info de version, fichier de sauvegarde foireux

    if not((VersionNum >= 0) and (sizeof(nb) = AStream.read(nb, sizeof(nb))))
    then
      nb := 0;

    while (nb > 0) do
    begin
      Player := TSporglooPlayer.Create;
      Player.LoadFromStream(AStream);
      add(Player.PlayerID, Player);
      dec(nb);
    end;
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooPlayersList.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  LKey: string;
begin
  System.tmonitor.Enter(self);
  try
    VersionNum := CVersion;
    AStream.Write(VersionNum, sizeof(VersionNum));
    nb := Count;
    AStream.Write(nb, sizeof(nb));
    for LKey in keys do
      items[LKey].SaveToStream(AStream);
  finally
    System.tmonitor.Exit(self);
  end;
end;

{ TSporglooMap }

constructor TSporglooMap.Create;
begin
  inherited;
  FCell := TSporglooMapCol.Create([doOwnsValues]);
end;

destructor TSporglooMap.Destroy;
begin
  FCell.Free;
  inherited;
end;

function TSporglooMap.GetCellAt(AX, AY: TSporglooAPINumber): TSporglooMapCell;
var
  LRow: TSporglooMapRow;
begin
  System.tmonitor.Enter(self);
  try
    if (not FCell.TryGetValue(AX, LRow)) then
    begin
      LRow := TSporglooMapRow.Create(AX);
      FCell.add(AX, LRow);
    end;
    if (not LRow.TryGetValue(AY, result)) then
    begin
      result := TSporglooMapCell.Create(AX, AY, CSporglooTileForest, '');
      LRow.add(AY, result);
    end;
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooMap.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
begin
  System.tmonitor.Enter(self);
  try
    if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
      VersionNum := -1; // pas d'info de version, fichier de sauvegarde foireux

    if not(VersionNum >= 0) then
      FCell.Clear
    else
      FCell.LoadFromStream(AStream);
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooMap.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
begin
  System.tmonitor.Enter(self);
  try
    VersionNum := CVersion;
    AStream.Write(VersionNum, sizeof(VersionNum));
    FCell.SaveToStream(AStream);
  finally
    System.tmonitor.Exit(self);
  end;
end;

{ TSporglooSession }

constructor TSporglooSession.Create;
begin
  inherited;
  FSessionID := '';
  FSocketClient := nil;
  FPlayer := nil;
end;

destructor TSporglooSession.Destroy;
var
  msg: TLogoffMessage;
begin
  if assigned(FSocketClient) then
  begin
    msg := TLogoffMessage.Create;
    try
      FSocketClient.SendMessage(msg);
    finally
      msg.Free;
    end;
  end;
  inherited;
end;

procedure TSporglooSession.SetPlayer(const Value: TSporglooPlayer);
begin
  System.tmonitor.Enter(self);
  try
    FPlayer := Value;
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooSession.SetSessionID(const Value: string);
begin
  System.tmonitor.Enter(self);
  try
    FSessionID := Value;
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooSession.SetSocketClient(const Value
  : TOlfSocketMessagingServerConnectedClient);
begin
  System.tmonitor.Enter(self);
  try
    FSocketClient := Value;
  finally
    System.tmonitor.Exit(self);
  end;
end;

{ TSporglooMapRow }

constructor TSporglooMapRow.Create(ARowKey: TSporglooAPINumber);
begin
  inherited Create([doOwnsValues]);
  FRowKey := ARowKey;
end;

procedure TSporglooMapRow.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  LKey: TSporglooAPINumber;
  LValueOldVersion1: TSporglooAPIShort;
  LValue: TSporglooMapCell;
begin
  System.tmonitor.Enter(self);
  try
    if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
      VersionNum := -1;
    // pas d'info de version, fichier de sauvegarde foireux

    if not((VersionNum >= 0) and (sizeof(nb) = AStream.read(nb, sizeof(nb))))
    then
      nb := 0;

    Clear;
    while (nb > 0) do
    begin
      if not((VersionNum >= 0) and (sizeof(LKey) = AStream.read(LKey,
        sizeof(LKey)))) then
        LKey := 0;
      if VersionNum = 1 then
      begin
        // deprecated, only for compatibility with previous storage
        if not((sizeof(LValueOldVersion1) = AStream.read(LValueOldVersion1,
          sizeof(LValueOldVersion1)))) then
          LValueOldVersion1 := 0;
        LValue := TSporglooMapCell.Create(FRowKey, LKey, LValueOldVersion1, '');
      end
      else
      begin
        LValue := TSporglooMapCell.Create;
        LValue.LoadFromStream(AStream);
      end;
      AddOrSetValue(LKey, LValue);
      dec(nb);
    end;
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooMapRow.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  LKey: TSporglooAPINumber;
begin
  System.tmonitor.Enter(self);
  try
    VersionNum := CVersion;
    AStream.Write(VersionNum, sizeof(VersionNum));
    nb := Count;
    AStream.Write(nb, sizeof(nb));
    for LKey in keys do
    begin
      AStream.Write(LKey, sizeof(LKey));
      items[LKey].SaveToStream(AStream);
    end;
  finally
    System.tmonitor.Exit(self);
  end;
end;

{ TSporglooMapCol }

procedure TSporglooMapCol.LoadFromStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  LKey: TSporglooAPINumber;
  LValue: TSporglooMapRow;
begin
  System.tmonitor.Enter(self);
  try
    if (sizeof(VersionNum) <> AStream.read(VersionNum, sizeof(VersionNum))) then
      VersionNum := -1; // pas d'info de version, fichier de sauvegarde foireux

    if not((VersionNum >= 0) and (sizeof(nb) = AStream.read(nb, sizeof(nb))))
    then
      nb := 0;

    Clear;
    while (nb > 0) do
    begin
      if not((VersionNum >= 0) and (sizeof(LKey) = AStream.read(LKey,
        sizeof(LKey)))) then
        LKey := 0;
      LValue := TSporglooMapRow.Create(LKey);
      LValue.LoadFromStream(AStream);
      AddOrSetValue(LKey, LValue);
      dec(nb);
    end;
  finally
    System.tmonitor.Exit(self);
  end;
end;

procedure TSporglooMapCol.SaveToStream(AStream: TStream);
var
  VersionNum: integer;
  nb: int64;
  LKey: TSporglooAPINumber;
begin
  System.tmonitor.Enter(self);
  try
    VersionNum := CVersion;
    AStream.Write(VersionNum, sizeof(VersionNum));
    nb := Count;
    AStream.Write(nb, sizeof(nb));
    for LKey in keys do
    begin
      AStream.Write(LKey, sizeof(LKey));
      items[LKey].SaveToStream(AStream);
    end;
  finally
    System.tmonitor.Exit(self);
  end;
end;

end.
