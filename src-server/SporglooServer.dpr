program SporglooServer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Sporgloo.API.Messages in '..\src-common-api\Sporgloo.API.Messages.pas',
  Sporgloo.Types in '..\src-common-api\Sporgloo.Types.pas',
  Sporgloo.Database in '..\src-common-api\Sporgloo.Database.pas',
  Sporgloo.Server in 'Sporgloo.Server.pas',
  Sporgloo.Consts in '..\src-common-api\Sporgloo.Consts.pas',
  Olf.Net.Socket.Messaging in '..\lib-externes\Socket-Messaging-Library\src\Olf.Net.Socket.Messaging.pas';

var
  GameServer: TSporglooServer;

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
  try
    // LocalHost
//    GameServer := TSporglooServer.Create('127.0.0.1', 8080);
    // Sporgloo VPS (temporary address)
//     GameServer := TSporglooServer.Create('141.94.221.190', 8080);
     GameServer := TSporglooServer.Create('0.0.0.0', 8080);
    try
      // TODO : change IP and port depending on the server
      // TODO : check if IPv6 is available and open a listening server for it too
      GameServer.Listen;
      readln;
    finally
      GameServer.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
