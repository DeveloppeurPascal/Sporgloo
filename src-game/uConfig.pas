unit uConfig;

interface

uses
  Olf.RTL.Params;

type
  TConfig = class
  private
    FParams: TParamsFile;
    procedure SetDeviceID(const Value: string);
    procedure SetPlayerID(const Value: string);
    function GetDeviceID: string;
    function GetPlayerID: string;
  protected
  public
    property DeviceID: string read GetDeviceID write SetDeviceID;
    property PlayerID: string read GetPlayerID write SetPlayerID;
    // TODO : add music on/off
    // TODO : add music volume
    // TODO : add Server IP
    // TODO : add Server Port
    class function Current: TConfig;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  Sporgloo.Types,
  System.SysUtils,
  System.IOUtils;

var
  ConfigInstance: TConfig;
  Params: TParamsFile;

  { TConfig }

constructor TConfig.Create;
var
  AppName, Folder, FileName: string;
begin
  AppName := tpath.GetFileNameWithoutExtension(paramstr(0));
{$IFDEF DEBUG}
  AppName := AppName + '-debug';
  Folder := tpath.combine(tpath.combine(tpath.GetDocumentsPath,
    'Gamolf-debug'), AppName);
{$ELSE}
  Folder := tpath.combine(tpath.combine(tpath.GetHomePath, 'Gamolf'), AppName);
{$ENDIF}
  FileName := AppName + '.par';

  if not tdirectory.Exists(Folder) then
    tdirectory.CreateDirectory(Folder);

  FParams := TParamsFile.Create(tpath.combine(Folder, FileName));
  FParams.Load;
end;

class function TConfig.Current: TConfig;
begin
  if not assigned(ConfigInstance) then
    ConfigInstance := TConfig.Create;
  result := ConfigInstance;
end;

destructor TConfig.Destroy;
begin
  FParams.Free;
  inherited;
end;

function TConfig.GetDeviceID: string;
begin
  result := FParams.getValue('DeviceID', '');
  if result.IsEmpty then
  begin
    result := GetUniqID;
    SetDeviceID(result);
  end;
end;

function TConfig.GetPlayerID: string;
begin
  result := FParams.getValue('PlayerID', '');
end;

procedure TConfig.SetDeviceID(const Value: string);
begin
  FParams.setValue('DeviceID', Value);
  FParams.Save;
end;

procedure TConfig.SetPlayerID(const Value: string);
begin
  FParams.setValue('PlayerID', Value);
  FParams.Save;
end;

initialization

ConfigInstance := nil;

finalization

ConfigInstance.Free;

end.
