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
    procedure TimerMapRefreshTimer(Sender: TObject);
    procedure MapImageResized(Sender: TObject);
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
      CSporglooTileNone:
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

end.
