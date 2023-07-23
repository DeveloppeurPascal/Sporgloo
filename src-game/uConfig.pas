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
    procedure SetServerIPv4(const Value: string);
    procedure SetServerIPv4Port(const Value: word);
    procedure SetServerIPv6(const Value: string);
    procedure SetServerIPv6Port(const Value: word);
    function GetServerIPv4: string;
    function GetServerIPv4Port: word;
    function GetServerIPv6: string;
    function GetServerIPv6Port: word;
  protected
  public
    property DeviceID: string read GetDeviceID write SetDeviceID;
    property PlayerID: string read GetPlayerID write SetPlayerID;
    // TODO : add music on/off
    // TODO : add music volume
    property ServerIPv4: string read GetServerIPv4 write SetServerIPv4;
    property ServerIPv4Port: word read GetServerIPv4Port
      write SetServerIPv4Port;
    property ServerIPv6: string read GetServerIPv6 write SetServerIPv6;
    property ServerIPv6Port: word read GetServerIPv6Port
      write SetServerIPv6Port;
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
  begin
    ConfigInstance := TConfig.Create;

    // pprem
    // TODO : à supprimer
    ConfigInstance.SetDeviceID('');
    ConfigInstance.SetPlayerID('');
  end;
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

function TConfig.GetServerIPv4: string;
begin
{$IFDEF RELEASE}
  result := FParams.getValue('ServerIPv4', '141.94.221.190');
  // VPS Sporgloo (temporary address)
{$ELSE}
  // TODO : for local tests
  // result := FParams.getValue('ServerIPv4', '127.0.0.1');
  result := FParams.getValue('ServerIPv4', '141.94.221.190');
{$ENDIF}
end;

function TConfig.GetServerIPv4Port: word;
begin
  result := FParams.getValue('ServerIPv4Port', 8080);
end;

function TConfig.GetServerIPv6: string;
begin
  raise Exception.Create('No IPv6 server available.');
  // TODO : add IPv6 setup for the server
  result := FParams.getValue('ServerIPv6', '');
end;

function TConfig.GetServerIPv6Port: word;
begin
  raise Exception.Create('No IPv6 server available.');
  // TODO : add IPv6 setup for the server
  result := FParams.getValue('ServerIPv6Port', 8080);
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

procedure TConfig.SetServerIPv4(const Value: string);
begin
  FParams.setValue('ServerIPv4', Value);
  FParams.Save;
end;

procedure TConfig.SetServerIPv4Port(const Value: word);
begin
  FParams.setValue('ServerIPv4Port', Value);
  FParams.Save;
end;

procedure TConfig.SetServerIPv6(const Value: string);
begin
  FParams.setValue('ServerIPv6', Value);
  FParams.Save;
end;

procedure TConfig.SetServerIPv6Port(const Value: word);
begin
  FParams.setValue('ServerIPv6Port', Value);
  FParams.Save;
end;

initialization

ConfigInstance := nil;

finalization

ConfigInstance.Free;

end.
