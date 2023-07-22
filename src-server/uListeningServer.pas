unit uListeningServer;

interface

uses
  System.Classes;

type
  TListeningServer = class(TThread)
  private
    FPort: word;
    FIP: string;
  protected
    procedure Execute; override;
  public
    constructor Create(AIP: string; APort: word);
  end;

implementation

uses
  System.net.Socket,
  uConnectedClient,
  System.SysUtils;

{ TListeningServer }

constructor TListeningServer.Create(AIP: string; APort: word);
begin
  inherited Create(true);
  FIP := AIP;
  FPort := APort;
  FreeOnTerminate := true;
  Resume;
end;

procedure TListeningServer.Execute;
var
  ServerSocket, ClientSocket: TSocket;
begin
  NameThreadForDebugging('SporglooAPIServer');
  ServerSocket := TSocket.Create(tsockettype.tcp, tencoding.UTF8);
  try
    ServerSocket.Listen(FIP, '', FPort);
    try
      if (tsocketstate.client in ServerSocket.State) then
        writeln('tsocketstate.client');
      if (tsocketstate.listening in ServerSocket.State) then
        writeln('tsocketstate.listening');
      if (tsocketstate.connected in ServerSocket.State) then
        writeln('tsocketstate.connected');
      // TODO : remove trace log, the server must be in "listening" mode
      while not TThread.CheckTerminated do
      begin
        try
          ClientSocket := ServerSocket.accept(100); // wait 0.1 second max
          if assigned(ClientSocket) then
            TConnectedClient.Create(ClientSocket);
        except
          on e: exception do
            writeln('Server except: ' + e.Message);
          // TODO : write the error in a log file
        end;
      end;
    finally
      ServerSocket.Close;
    end;
  finally
    ServerSocket.Free;
  end;
end;

end.
