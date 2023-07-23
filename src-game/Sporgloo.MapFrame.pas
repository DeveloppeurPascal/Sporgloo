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
  FMX.Objects;

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
    procedure DrawMapCell(AX, AY: TSporglooAPINumber;
      ATileID: TSporglooAPIShort);
    procedure DrawAPlayer(AX, AY: TSporglooAPINumber);
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
  Sporgloo.Database;

constructor TMapFrame.Create(AOwner: TComponent);
begin
  inherited;
  TimerMapRefresh.Enabled := false;
  SubscribeToMapCellUpdateMessage;
  SubscribeToMapUpdateMessage;
end;

procedure TMapFrame.DrawAPlayer(AX, AY: TSporglooAPINumber);
var
  x, y, w, h: single;
  BitmapScale: single;
  bmp: tbitmap;
  Session: TSporglooSession;
begin
  BitmapScale := MapImage.Bitmap.BitmapScale;

  Session := TGameData.Current.Session;

  w := 18 * 1.5;
  x := abs(Session.MapRangeX - AX) * CSporglooTileSize +
    (CSporglooTileSize - w) / 2;
  h := 25 * 1.5;
  y := abs(Session.MapRangey - AY) * CSporglooTileSize +
    (CSporglooTileSize - h) / 2;

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

procedure TMapFrame.DrawMapCell(AX, AY: TSporglooAPINumber;
  ATileID: TSporglooAPIShort);
var
  x, y: single;
  BitmapScale: single;
  Session: TSporglooSession;
  Player: TSporglooPlayer;
  bmp: tbitmap;
  TileImgIndex: integer;
begin
  if not assigned(MapImage.Bitmap) then
    MapImage.Bitmap := tbitmap.Create;

  BitmapScale := MapImage.Bitmap.BitmapScale;

  Session := TGameData.Current.Session;

  x := abs(Session.MapRangeX - AX) * CSporglooTileSize;
  y := abs(Session.MapRangey - AY) * CSporglooTileSize;

  case ATileID of
    CSporglooTileNone:
      TileImgIndex := 1;
    CSporglooTilePath:
      TileImgIndex := 0;
    CSporglooTileStar:
      TileImgIndex := 2;
  else
    raise exception.Create('Tile ID ' + ATileID.ToString + ' non supported.');
  end;

  Player := TGameData.Current.Player;

  bmp := dmSporglooImages.MapImages.Bitmap
    (tsizef.Create(CSporglooTileSize * BitmapScale,
    CSporglooTileSize * BitmapScale), TileImgIndex);
  MapImage.Bitmap.Canvas.BeginScene;
  try
    MapImage.Bitmap.Canvas.DrawBitmap(bmp, bmp.BoundsF,
      rectf(x, y, x + CSporglooTileSize + 1 * BitmapScale,
      y + CSporglooTileSize + 1 * BitmapScale), 1);
    // TODO : check is a player is on the cell and draw it

    if (AX = Player.PlayerX) and (AY = Player.PlayerY) then
      DrawAPlayer(AX, AY);

  finally
    MapImage.Bitmap.Canvas.EndScene;
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
      GameData: TGameData;
      MapCell: TSporglooMapCell;
    begin
      if not(M is TMapCellUpdateMessage) then
        exit;
      Msg := M as TMapCellUpdateMessage;
      if not assigned(Msg.Value) then
        exit;
      MapCell := Msg.Value;

      GameData := TGameData.Current;

      if (MapCell.x >= GameData.Session.MapRangeX) and
        (MapCell.y >= GameData.Session.MapRangey) and
        (MapCell.x <= GameData.Session.MapRangeXMax) and
        (MapCell.y <= GameData.Session.MapRangeYMax) then
        DrawMapCell(MapCell.x, MapCell.y, MapCell.TileID);
    end);
end;

procedure TMapFrame.SubscribeToMapUpdateMessage;
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TMapUpdateMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      Msg: TMapUpdateMessage;
      Session: TSporglooSession;
      Map: TSporglooMap;
      x, y: TSporglooAPINumber;
    begin
      if not(M is TMapUpdateMessage) then
        exit;
      Msg := M as TMapUpdateMessage;

      Session := TGameData.Current.Session;
      Map := TGameData.Current.Map;

      for x := Session.MapRangeX to Session.MapRangeXMax do
        for y := Session.MapRangey to Session.MapRangeYMax do
          DrawMapCell(x, y, Map.GetTileID(x, y));
    end);
end;

procedure TMapFrame.TimerMapRefreshTimer(Sender: TObject);
var
  GameData: TGameData;
  // w, h: single;
  BitmapScale: single;
  // bmp: tbitmap;
  // r: trectf;
begin
  if not TimerMapRefresh.Enabled then
    exit;

  if TGameData.Current.isServerConnected then
  begin
    TimerMapRefresh.Enabled := false;

    if not assigned(MapImage.Bitmap) then
      MapImage.Bitmap := tbitmap.Create;

    BitmapScale := MapImage.Bitmap.BitmapScale;

    // bmp := tbitmap.Create(ceil(MapImage.width * BitmapScale),
    // ceil(MapImage.Height * BitmapScale));
    // r := rectf(0, 0, min(MapImage.Bitmap.BoundsF.Right, bmp.BoundsF.Right),
    // min(MapImage.Bitmap.BoundsF.bottom, bmp.BoundsF.bottom));
    // bmp.Canvas.BeginScene;
    // try
    // bmp.Canvas.DrawBitmap(MapImage.Bitmap, r, r, 1);
    // finally
    // bmp.Canvas.EndScene;
    // end;
    // MapImage.Bitmap.assign(bmp);

    MapImage.Bitmap.setsize(ceil(MapImage.width * BitmapScale),
      ceil(MapImage.Height * BitmapScale));

    GameData := TGameData.Current;
    GameData.Session.MapRangeColNumber :=
      ceil(MapImage.width / CSporglooTileSize);
    GameData.Session.MapRangeRowNumber :=
      ceil(MapImage.Height / CSporglooTileSize);
    GameData.Session.MapRangeX := GameData.Player.PlayerX -
      (GameData.Session.MapRangeColNumber div 2);
    GameData.Session.MapRangey := GameData.Player.PlayerY -
      (GameData.Session.MapRangeRowNumber div 2);

    TGameData.Current.refreshmap;
  end;
end;

end.
