unit Sporgloo.MapFrame;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  Sporgloo.Types,
  Sporgloo.Images,
  FMX.Objects,
  Sporgloo.Database;

type
  TMapFrame = class(TFrame)
    TimerMapRefresh: TTimer;
    MapImage: TImage;
    TimerPlayerMove: TTimer;
    procedure TimerMapRefreshTimer(Sender: TObject);
    procedure MapImageResized(Sender: TObject);
    procedure TimerPlayerMoveTimer(Sender: TObject);
  private
  protected
    procedure SubscribeToMapCellUpdateMessage;
    procedure SubscribeToMapUpdateMessage;
    procedure SubscribeToOtherPlayerMove;
    procedure DrawMapCell(AMapCell: TSporglooMapCell);
    procedure DrawAPlayer(APlayer: TSporglooPlayer);
    procedure DrawAStar(AX, AY: TSporglooAPINumber);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  System.Messaging,
  System.Math,
  uGameData,
  Sporgloo.Consts,
  Sporgloo.Messaging;

constructor TMapFrame.Create(AOwner: TComponent);
begin
  inherited;
  TimerMapRefresh.Enabled := false;
  SubscribeToMapCellUpdateMessage;
  SubscribeToMapUpdateMessage;
  SubscribeToOtherPlayerMove;
end;

procedure TMapFrame.DrawAPlayer(APlayer: TSporglooPlayer);
var
  x, y, w, h: single;
  BitmapScale: single;
  bmp: tbitmap;
  GameData: TGameData;
begin
  if not assigned(MapImage.Bitmap) then
    MapImage.Bitmap := tbitmap.Create;

  GameData := TGameData.Current;

  if (APlayer.PlayerX >= GameData.ViewportX) and
    (APlayer.PlayerY >= GameData.ViewportY) and
    (APlayer.PlayerX <= GameData.ViewportXMax) and
    (APlayer.PlayerY <= GameData.ViewportYMax) then
  begin
    w := 18 * 1.5;
    x := abs(GameData.ViewportX - APlayer.PlayerX) * CSporglooTileSize +
      (CSporglooTileSize - w) / 2;
    h := 25 * 1.5;
    y := abs(GameData.ViewportY - APlayer.PlayerY) * CSporglooTileSize +
      (CSporglooTileSize - h) / 2;

    BitmapScale := MapImage.Bitmap.BitmapScale;
    bmp := dmSporglooImages.MapImages.Bitmap(tsizef.Create(w * BitmapScale,
      h * BitmapScale), 3); // Image index 3 - player, original size (18x25)
    MapImage.Bitmap.Canvas.BeginScene;
    try
      MapImage.Bitmap.Canvas.DrawBitmap(bmp, bmp.BoundsF,
        rectf(x, y, x + w + 1 * BitmapScale, y + h + 1 * BitmapScale), 1);
    finally
      MapImage.Bitmap.Canvas.EndScene;
    end;
  end;
end;

procedure TMapFrame.DrawAStar(AX, AY: TSporglooAPINumber);
var
  x, y, w, h: single;
  BitmapScale: single;
  bmp: tbitmap;
  GameData: TGameData;
begin
  if not assigned(MapImage.Bitmap) then
    MapImage.Bitmap := tbitmap.Create;

  GameData := TGameData.Current;

  w := 58;
  x := abs(GameData.ViewportX - AX) * CSporglooTileSize +
    (CSporglooTileSize - w) / 2;
  h := 58;
  y := abs(GameData.ViewportY - AY) * CSporglooTileSize +
    (CSporglooTileSize - h) / 2;

  BitmapScale := MapImage.Bitmap.BitmapScale;
  bmp := dmSporglooImages.MapImages.Bitmap(tsizef.Create(w * BitmapScale,
    h * BitmapScale), 2); // Image index 2 - star, original size (113x113)
  MapImage.Bitmap.Canvas.BeginScene;
  try
    MapImage.Bitmap.Canvas.DrawBitmap(bmp, bmp.BoundsF,
      rectf(x, y, x + w + 1 * BitmapScale, y + h + 1 * BitmapScale), 1);
  finally
    MapImage.Bitmap.Canvas.EndScene;
  end;
end;

procedure TMapFrame.DrawMapCell(AMapCell: TSporglooMapCell);
var
  x, y: single;
  BitmapScale: single;
  bmp: tbitmap;
  TileImgIndex: integer;
  GameData: TGameData;
begin
  if not assigned(MapImage.Bitmap) then
    MapImage.Bitmap := tbitmap.Create;

  GameData := TGameData.Current;

  if (AMapCell.x >= GameData.ViewportX) and (AMapCell.y >= GameData.ViewportY)
    and (AMapCell.x <= GameData.ViewportXMax) and
    (AMapCell.y <= GameData.ViewportYMax) then
  begin
    x := abs(GameData.ViewportX - AMapCell.x) * CSporglooTileSize;
    y := abs(GameData.ViewportY - AMapCell.y) * CSporglooTileSize;

    case AMapCell.TileID of
      CSporglooTileForest:
        TileImgIndex := 1; // arbres
      CSporglooTilePath, CSporglooTileStar:
        TileImgIndex := 0; // chemin
    else
      raise exception.Create('Tile ID ' + AMapCell.TileID.ToString +
        ' non supported.');
    end;

    BitmapScale := MapImage.Bitmap.BitmapScale;
    bmp := dmSporglooImages.MapImages.Bitmap
      (tsizef.Create(CSporglooTileSize * BitmapScale,
      CSporglooTileSize * BitmapScale), TileImgIndex);
    MapImage.Bitmap.Canvas.BeginScene;
    try
      MapImage.Bitmap.Canvas.DrawBitmap(bmp, bmp.BoundsF,
        rectf(x, y, x + CSporglooTileSize + 1 * BitmapScale,
        y + CSporglooTileSize + 1 * BitmapScale), 1);
    finally
      MapImage.Bitmap.Canvas.EndScene;
    end;

    if AMapCell.TileID = CSporglooTileStar then
      DrawAStar(AMapCell.x, AMapCell.y);

    if not AMapCell.PlayerID.IsEmpty then
      if AMapCell.PlayerID = GameData.Player.PlayerID then
        DrawAPlayer(GameData.Player)
      else
        DrawAPlayer(GameData.OtherPlayers.GetPlayer(AMapCell.PlayerID));
  end;
end;

procedure TMapFrame.MapImageResized(Sender: TObject);
begin
  TimerMapRefresh.Enabled := true;
end;

procedure TMapFrame.SubscribeToMapCellUpdateMessage;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TMapCellUpdateMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      Msg: TMapCellUpdateMessage;
    begin
      if not(M is TMapCellUpdateMessage) then
        exit;
      Msg := M as TMapCellUpdateMessage;
      if not assigned(Msg.Value) then
        exit;

      if Msg.Value.TileID = CSporglooTileStar then
        TGameData.Current.Player.TestAndChangeTarget(Msg.Value.x, Msg.Value.y);

      DrawMapCell(Msg.Value);
    end);
end;

procedure TMapFrame.SubscribeToMapUpdateMessage;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TMapUpdateMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      GameData: TGameData;
      Map: TSporglooMap;
      x, y: TSporglooAPINumber;
    begin
      if not(M is TMapUpdateMessage) then
        exit;

      GameData := TGameData.Current;
      Map := GameData.Map;

      for x := GameData.ViewportX to GameData.ViewportXMax do
        for y := GameData.ViewportY to GameData.ViewportYMax do
          DrawMapCell(Map.GetCellAt(x, y));
    end);
end;

procedure TMapFrame.SubscribeToOtherPlayerMove;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TOtherPlayerUpdateMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      Msg: TOtherPlayerUpdateMessage;
    begin
      if not(M is TOtherPlayerUpdateMessage) then
        exit;
      Msg := M as TOtherPlayerUpdateMessage;
      if not assigned(Msg.Value) then
        exit;

      DrawAPlayer(Msg.Value);
    end);
end;

procedure TMapFrame.TimerMapRefreshTimer(Sender: TObject);
var
  GameData: TGameData;
  BitmapScale: single;
begin
  if not TimerMapRefresh.Enabled then
    exit;

  GameData := TGameData.Current;

  if GameData.isServerConnected then
  begin
    TimerMapRefresh.Enabled := false;

    if not assigned(MapImage.Bitmap) then
      MapImage.Bitmap := tbitmap.Create;

    BitmapScale := MapImage.Bitmap.BitmapScale;

    MapImage.Bitmap.setsize(ceil(MapImage.width * BitmapScale),
      ceil(MapImage.Height * BitmapScale));

    GameData.ViewportNbCol := ceil(MapImage.width / CSporglooTileSize);
    GameData.ViewportNbRow := ceil(MapImage.Height / CSporglooTileSize);

    GameData.refreshmap;
  end;
end;

procedure TMapFrame.TimerPlayerMoveTimer(Sender: TObject);
var
  Player: TSporglooPlayer;
  MapCell, PrevMapCell: TSporglooMapCell;
  x, y: TSporglooAPINumber;
  GameData: TGameData;
begin
  if TimerPlayerMove.Enabled then
  begin
    GameData := TGameData.Current;
    Player := GameData.Player;
    if assigned(Player) then
    begin
      PrevMapCell := GameData.Map.GetCellAt(Player.PlayerX, Player.PlayerY);

      if Player.PlayerX < Player.TargetX then
        Player.PlayerX := Player.PlayerX + 1
      else if Player.PlayerX > Player.TargetX then
        Player.PlayerX := Player.PlayerX - 1;
      if Player.PlayerY < Player.Targety then
        Player.PlayerY := Player.PlayerY + 1
      else if Player.PlayerY > Player.Targety then
        Player.PlayerY := Player.PlayerY - 1;

      MapCell := GameData.Map.GetCellAt(Player.PlayerX, Player.PlayerY);

      // TODO : add some controls on new cell (existing player, blocking element, ...) and rollback the player coordinates

      if (MapCell <> PrevMapCell) then
      begin
        PrevMapCell.PlayerID := '';
        MapCell.PlayerID := Player.PlayerID;

        if MapCell.TileID = CSporglooTileStar then
        begin
          MapCell.TileID := CSporglooTilePath;
          Player.StarsCount := Player.StarsCount + 1;

          // TODO : replace the coordinates loop by a loop in the starts list stored in GameData
          for x := GameData.ViewportX - CColMargins to GameData.ViewportXMax + 2
            * CColMargins do
            for y := GameData.ViewportY - CrowMargins to GameData.ViewportYMax +
              2 * CrowMargins do
              Player.TestAndChangeTarget(x, y);
        end;

        TGameData.Current.refreshmap;

        GameData.APIClient.SendPlayerMove(GameData.Session.SessionID,
          Player.PlayerID, Player.PlayerX, Player.PlayerY);
      end;
    end;
  end;
end;

end.
