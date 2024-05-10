unit Sporgloo.Utils;

interface

/// <summary>
/// Generate the ServerAuthKey used in REGISTER message between the game client and the server
/// </summary>
function GetServerAuthKey(DeviceID: string): string;

/// <summary>
/// Generate the TokenID used in LOGIN message between the game client and the server
/// </summary>
function GetTokenID(PlayerID, DeviceID, DeviceAuthKey: string): string;

implementation

uses
  System.Types,
  Olf.RTL.CryptDecrypt;

var
  Password: string;
  Keys: TByteDynArray;

function GetServerAuthKey(DeviceID: string): string;
var
  s: string;
begin
  s := DeviceID + Password;
  result := TOlfCryptDecrypt.XORCrypt(s, Keys);
end;

function GetTokenID(PlayerID, DeviceID, DeviceAuthKey: string): string;
var
  s: string;
begin
  s := PlayerID + DeviceID + DeviceAuthKey + Password;
  result := TOlfCryptDecrypt.XORCrypt(s, Keys);
end;

initialization

{$IFDEF RELEASE}
{$I '..\_PRIVATE\src\LoginGamePassword.inc'}
{$I '..\_PRIVATE\src\LoginGameXORKey.inc'}
{$ELSE}
{$I 'LoginGamePassword.inc'}
{$I 'LoginGameXORKey.inc'}
{$ENDIF}

end.
