program SporglooServer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
{$IFDEF LINUX}
  Posix.Stdlib,
  Posix.SysStat,
  Posix.SysTypes,
  Posix.Unistd,
  Posix.Signal,
  Posix.Fcntl,
{$ENDIF}
  System.SysUtils,
  Sporgloo.API.Messages in '..\src-common-api\Sporgloo.API.Messages.pas',
  Sporgloo.Types in '..\src-common-api\Sporgloo.Types.pas',
  Sporgloo.Database in '..\src-common-api\Sporgloo.Database.pas',
  Sporgloo.Server in 'Sporgloo.Server.pas',
  Sporgloo.Consts in '..\src-common-api\Sporgloo.Consts.pas',
  Olf.Net.Socket.Messaging
    in '..\lib-externes\Socket-Messaging-Library\src\Olf.Net.Socket.Messaging.pas',
  Olf.RTL.Streams in '..\lib-externes\librairies\src\Olf.RTL.Streams.pas',
  Olf.RTL.Params in '..\lib-externes\librairies\src\Olf.RTL.Params.pas',
  Olf.RTL.Maths.Conversions
    in '..\lib-externes\librairies\src\Olf.RTL.Maths.Conversions.pas',
  uGameData in 'uGameData.pas',
  Sporgloo.Messaging in 'Sporgloo.Messaging.pas',
  Olf.RTL.CryptDecrypt
    in '..\lib-externes\librairies\src\Olf.RTL.CryptDecrypt.pas',
  Sporgloo.Utils in '..\src-common-api\Sporgloo.Utils.pas',
  Olf.RTL.GenRandomID
    in '..\lib-externes\librairies\src\Olf.RTL.GenRandomID.pas';

{$IFDEF LINUX}

const
  // Missing from linux/StdlibTypes.inc !!! <stdlib.h>
  EXIT_FAILURE = 1;
  EXIT_SUCCESS = 0;

var
  pid: pid_t;
  fid: Integer;
  idx: Integer;
  running: Boolean;

procedure HandleSignals(SigNum: Integer); cdecl;
begin
  case SigNum of
    SIGTERM:
      begin
        running := False;
      end;
    SIGHUP:
      begin
        // syslog(LOG_NOTICE, 'daemon: reloading config');
        // Reload configuration
      end;
  end;
end;

{$ENDIF}

procedure StartServer(const Port: word);
var
  GameServer: TSporglooServer;
begin
  GameServer := TSporglooServer.Create('0.0.0.0', Port);
  try
    // TODO : change IP and port depending on the server
    // TODO : check if IPv6 is available and open a listening server for it too
    GameServer.Listen;
  finally
    GameServer.Free;
  end;
end;

var
  Port: Integer;
  paramvalue: string;

begin
  SporglooProjectType := TSporglooProjectType.Serveur;

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
  try
    if findcmdlineswitch('h') then
    begin
      Writeln('Sporgloo Server');
      Writeln('(c) 2023-2024 Patrick Prémartin');
      Writeln('');
      Writeln('-h => display this help');
      Writeln('-port number => port number to listen (' +
        CDefaultServerPort.ToString + ' by default)');
{$IFDEF LINUX}
      Writeln('-daemon => start the server as Linux daemon');
{$ENDIF}
    end
    else
    begin
      if findcmdlineswitch('port', paramvalue, true, [clstValueNextParam]) then
        Port := paramvalue.ToInteger
      else
        Port := CDefaultServerPort;

{$IFDEF LINUX}
      // Want to understand how to create a Linux daemon ?
      // Look at Paolo Rossi blog :
      // https://blog.paolorossi.net/building-a-real-linux-daemon-with-delphi-part-1/
      // https://blog.paolorossi.net/building-a-real-linux-daemon-with-delphi-part-2/
      if findcmdlineswitch('daemon') then
      begin
        // openlog(nil, LOG_PID or LOG_NDELAY, LOG_DAEMON);
        try
          if getppid() > 1 then
          begin
            pid := fork();
            if pid < 0 then
              raise exception.Create('Error forking the process');

            if pid > 0 then
              Halt(EXIT_SUCCESS);

            if setsid() < 0 then
              raise exception.Create
                ('Impossible to create an independent session');

            Signal(SIGCHLD, TSignalHandler(SIG_IGN));
            Signal(SIGHUP, HandleSignals);
            Signal(SIGTERM, HandleSignals);

            pid := fork();
            if pid < 0 then
              raise exception.Create('Error forking the process');

            if pid > 0 then
              Halt(EXIT_SUCCESS);

            for idx := sysconf(_SC_OPEN_MAX) downto 0 do
              __close(idx);

            fid := __open('/dev/null', O_RDWR);
            dup(fid);
            dup(fid);

            umask(027);

            chdir('/');
          end;

          running := true;

          StartServer(Port);

          ExitCode := EXIT_SUCCESS;
        except
          on E: exception do
          begin
            // syslog(LOG_ERR, 'Error: ' + E.Message);
            ExitCode := EXIT_FAILURE;
          end;
        end;

        // syslog(LOG_NOTICE, 'daemon stopped');
        // closelog();
      end
      else
{$ENDIF}
        StartServer(Port);
    end;

  except
    on E: exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
