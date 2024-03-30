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
  Olf.Net.Socket.Messaging
    in '..\lib-externes\Socket-Messaging-Library\src\Olf.Net.Socket.Messaging.pas',
  Olf.RTL.Streams in '..\lib-externes\librairies\src\Olf.RTL.Streams.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\src\Olf.RTL.Params.pas';

var
  GameServer: TSporglooServer;

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
  try
    GameServer := TSporglooServer.Create('0.0.0.0', 8080);
    try
      // TODO : change IP and port depending on the server
      // TODO : check if IPv6 is available and open a listening server for it too
      GameServer.Listen;
    finally
      GameServer.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
