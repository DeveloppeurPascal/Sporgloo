unit uServerData;

interface

uses
  Sporgloo.Types,
  Sporgloo.Database;

type
  TServerData = class
  private
  protected
  public
    Players: TSporglooPlayersList;
    Map: TSporglooMap;
    Sessions: TSporglooSessionsList;

    class function Current: TServerData;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.Generics.Collections;

var
  ServerDataInstance: TServerData;

  { TServerData }

constructor TServerData.Create;
begin
  Players := TSporglooPlayersList.Create([doownsvalues]);
  Map := TSporglooMap.Create;
  Sessions := TSporglooSessionsList.Create([doownsvalues]);
end;

class function TServerData.Current: TServerData;
begin
  if not assigned(ServerDataInstance) then
    ServerDataInstance := TServerData.Create;
  result := ServerDataInstance;
end;

destructor TServerData.Destroy;
begin
  Sessions.Free;
  Map.Free;
  Players.Free;
  inherited;
end;

initialization

ServerDataInstance := nil;

finalization

ServerDataInstance.Free;

end.
