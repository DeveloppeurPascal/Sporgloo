program SporglooServer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

begin
  try
    { TODO -oUser -cConsole Main : Ins�rer du code ici }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
