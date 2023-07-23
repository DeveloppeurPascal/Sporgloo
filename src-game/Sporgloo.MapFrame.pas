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
  Sporgloo.Types;

type
  TMapFrame = class(TFrame)
    TimerMapRefresh: TTimer;
    procedure FrameResized(Sender: TObject);
    procedure TimerMapRefreshTimer(Sender: TObject);
  private
  protected
    procedure SubscribeToMapCellUpdateMessage;
    procedure DrawMapCell(X: TSporglooAPINumber; Y: TSporglooAPINumber;
      TileID: TSporglooAPIShort);
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
end;

procedure TMapFrame.DrawMapCell(X, Y: TSporglooAPINumber;
  TileID: TSporglooAPIShort);
begin
  // TODO : draw the cell on screen
end;

procedure TMapFrame.FrameResized(Sender: TObject);
var
  GameData: TGameData;
  W, H: single;
begin
  GameData := TGameData.Current;
  W := width / CSporglootilesize;
  H := Height / CSporglootilesize;
  GameData.Session.MapRangeX := GameData.Player.PlayerX - ceil(W);
  GameData.Session.MapRangey := GameData.Player.Playery - ceil(H);
  GameData.Session.MapRangeColNumber := ceil(W);
  GameData.Session.MapRangeRowNumber := ceil(H);
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

      if (MapCell.X >= GameData.Session.MapRangeX) and
        (MapCell.Y >= GameData.Session.MapRangey) and
        (MapCell.X <= GameData.Session.MapRangeXMax) and
        (MapCell.Y <= GameData.Session.MapRangeYMax) then
        DrawMapCell(MapCell.X, MapCell.Y, MapCell.TileID);
    end);
end;

procedure TMapFrame.TimerMapRefreshTimer(Sender: TObject);
begin
  if not Enabled then
    exit;

  if TGameData.Current.isServerConnected then
  begin
    Enabled := false;
    TGameData.Current.refreshmap;
  end;
end;

end.
