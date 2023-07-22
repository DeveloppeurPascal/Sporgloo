program SporglooServer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  uListeningServer in 'uListeningServer.pas',
  uConnectedClient in 'uConnectedClient.pas',
  uAPIMessages in '..\src-common-api\uAPIMessages.pas';

var
  GameServer: TListeningServer;

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
  try
    GameServer := TListeningServer.Create('127.0.0.1', 80);
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
