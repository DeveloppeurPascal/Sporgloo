program SporglooServer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  uListeningServer in 'uListeningServer.pas',
  uConnectedClient in 'uConnectedClient.pas',
  Sporgloo.API.Messages in '..\src-common-api\Sporgloo.API.Messages.pas',
  Sporgloo.Types in '..\src-common-api\Sporgloo.Types.pas',
  Sporgloo.Database in '..\src-common-api\Sporgloo.Database.pas',
  uServerData in 'uServerData.pas',
  Sporgloo.Consts in '..\src-common-api\Sporgloo.Consts.pas';

var
  GameServer: TListeningServer;

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
  try
    // LocalHost
    // GameServer := TListeningServer.Create('127.0.0.1', 80);
    // Sporgloo VPS (temporary address)
//    GameServer := TListeningServer.Create('141.94.221.190', 80);
        GameServer := TListeningServer.Create('0.0.0.0', 8080);
    try
      // TODO : change IP and port depending on the server
      // TODO : check if IPv6 is available and open a listening server for it too
      readln;
    finally
      GameServer.Terminate;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
