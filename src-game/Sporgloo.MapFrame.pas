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
    procedure SubscribeToPlayerMoveDeniedByTheServerMessage;
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
  Sporgloo.Messaging,
  Olf.Skia.SVGToBitmap,
  USVGPersos,
  USVGItems,
  USVGTrees,
  USVGBackgrounds,
  uSVGRegister;

constructor TMapFrame.Create(AOwner: TComponent);
begin
  inherited;
  TimerMapRefresh.Enabled := false;
  SubscribeToMapCellUpdateMessage;
  SubscribeToMapUpdateMessage;
  SubscribeToPlayerMoveDeniedByTheServerMessage;
end;

procedure TMapFrame.DrawAPlayer(APlayer: TSporglooPlayer);
var
  x, y, w, h: single;
  BitmapScale: single;
  bmp: tbitmap;
  GameData: TGameData;
  CellPlayerImageID: Integer;
begin
  if not assigned(MapImage.Bitmap) then
    MapImage.Bitmap := tbitmap.Create;

  GameData := TGameData.Current;

  if (APlayer.PlayerX >= GameData.ViewportX) and
    (APlayer.PlayerY >= GameData.ViewportY) and
    (APlayer.PlayerX <= GameData.ViewportXMax) and
    (APlayer.PlayerY <= GameData.ViewportYMax) then
  begin
    CellPlayerImageID := GameData.Map.GetCellAt(APlayer.PlayerX,
      APlayer.PlayerY).PlayerImageID;

    w := 18 * 1.5;
    x := abs(GameData.ViewportX - APlayer.PlayerX) * CSporglooTileSize +
      (CSporglooTileSize - w) / 2;
    h := 25 * 1.5;
    y := abs(GameData.ViewportY - APlayer.PlayerY) * CSporglooTileSize +
      (CSporglooTileSize - h) / 2;

    BitmapScale := MapImage.Bitmap.BitmapScale;
    if (APlayer.ImageID >= 0) and (APlayer.ImageID < length(SVGPersos)) then
      bmp := TOlfSVGBitmapList.Bitmap(SVGPersosListIndex, APlayer.ImageID,
        Round(w), Round(h), BitmapScale)
    else if (CellPlayerImageID >= 0) and (CellPlayerImageID < length(SVGPersos))
    then
      bmp := TOlfSVGBitmapList.Bitmap(SVGPersosListIndex, CellPlayerImageID,
        Round(w), Round(h), BitmapScale)
    else
      bmp := TOlfSVGBitmapList.Bitmap(SVGPersosListIndex, CSVGPerso1, Round(w),
        Round(h), BitmapScale);
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
  bmp := TOlfSVGBitmapList.Bitmap(SVGItemsListIndex, CSVGStar, Round(w),
    Round(h), BitmapScale);
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

    BitmapScale := MapImage.Bitmap.BitmapScale;

    case AMapCell.TileID of
      CSporglooTileForest:
        bmp := TOlfSVGBitmapList.Bitmap(SVGTreesListIndex, CSVGArbres6,
          CSporglooTileSize, CSporglooTileSize, BitmapScale);
      CSporglooTilePath, CSporglooTileStar:
        bmp := TOlfSVGBitmapList.Bitmap(SVGBackgroundsListIndex, CSVGFond1,
          CSporglooTileSize, CSporglooTileSize, BitmapScale);
    else
      raise exception.Create('Tile ID ' + AMapCell.TileID.ToString +
        ' non supported.');
    end;

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
      Player: TSporglooPlayer;
    begin
      if not(M is TMapCellUpdateMessage) then
        exit;
      Msg := M as TMapCellUpdateMessage;
      if not assigned(Msg.Value) then
        exit;

      Player := TGameData.Current.Player;
      if (Msg.Value.PlayerID = Player.PlayerID) and
        ((Msg.Value.x <> Player.PlayerX) or (Msg.Value.y <> Player.PlayerY))
      then
      begin
        Player.PlayerX := Msg.Value.x;
        Player.PlayerY := Msg.Value.y;
        TGameData.Current.refreshmap;
      end
      else
        DrawMapCell(Msg.Value);
      TimerPlayerMove.Enabled := TimerPlayerMove.Enabled or
        (Msg.Value.PlayerID = Player.PlayerID);
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

procedure TMapFrame.SubscribeToPlayerMoveDeniedByTheServerMessage;
begin
  TMessageManager.DefaultManager.SubscribeToMessage
    (TPlayerMoveDeniedByTheServerMessage,
    procedure(const Sender: TObject; const M: TMessage)
    begin
      if not(M is TPlayerMoveDeniedByTheServerMessage) then
        exit;
      TimerPlayerMove.Enabled := true;
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

      for x := GameData.ViewportX - CColMargins to GameData.ViewportXMax + 2 *
        CColMargins do
        for y := GameData.ViewportY - CrowMargins to GameData.ViewportYMax + 2 *
          CrowMargins do
          if GameData.Map.GetCellAt(x, y).TileID = CSporglooTileStar then
            Player.TestAndChangeTarget(x, y);

      // TODO : Replace this code by a path finding algorithm
      if Player.PlayerX < Player.TargetX then
        x := Player.PlayerX + 1
      else if Player.PlayerX > Player.TargetX then
        x := Player.PlayerX - 1
      else
        x := Player.PlayerX;
      if Player.PlayerY < Player.Targety then
        y := Player.PlayerY + 1
      else if Player.PlayerY > Player.Targety then
        y := Player.PlayerY - 1
      else
        y := Player.PlayerY;

      MapCell := GameData.Map.GetCellAt(x, y);

      if (MapCell <> PrevMapCell) and (not(MapCell.TileID = CSporglooTileForest)
        ) and MapCell.PlayerID.IsEmpty then
      begin
        if MapCell.TileID = CSporglooTileStar then
          Player.StarsCount := Player.StarsCount + 1;

        TimerPlayerMove.Enabled := false;

        GameData.APIClient.SendPlayerMove(GameData.Session.SessionID,
          Player.PlayerID, x, y);
      end;
    end;
  end;
end;

end.
