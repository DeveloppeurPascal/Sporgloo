unit uGameData;

interface

uses
  Sporgloo.Database;

type
  /// <summary>
  /// This TGameData in server project is empty.
  /// It's only there to compile common units.
  /// </summary>
  TGameData = class
  private
  protected
  public
    OtherPlayers: TSporglooPlayersList;
    class function Current: TGameData;
    procedure GetInfosPlayer(const PlayerID: string);
  end;

implementation

{ TGameData }

class function TGameData.Current: TGameData;
begin
  result := nil;
end;

procedure TGameData.GetInfosPlayer(const PlayerID: string);
begin
  //
end;

end.
