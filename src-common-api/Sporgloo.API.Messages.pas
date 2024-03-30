unit Sporgloo.API.Messages;

// ****************************************
// * Sporgloo Socket Messages
// ****************************************
// 
// Sporgloo is a multiplayer game.
// 
// This file defines the messages exchanged
// between the game program and the server.
// 
// ****************************************
// File generator : Socket Messaging Code Generator (v1.1)
// Website : https://smcodegenerator.olfsoftware.fr/ 
// Generation date : 30/03/2024 21:35:23
// 
// Don't do any change on this file. They will be erased by next generation !
// ****************************************

// To compile this unit you need Olf.Net.Socket.Messaging.pas from
// https://github.com/DeveloppeurPascal/Socket-Messaging-Library
//
// Direct link to the file :
// https://raw.githubusercontent.com/DeveloppeurPascal/Socket-Messaging-Library/main/src/Olf.Net.Socket.Messaging.pas

interface

uses
  Sporgloo.Types,
  System.Classes,
  Olf.Net.Socket.Messaging;

type
  /// <summary>
  /// Message ID 3: Client login message
  /// </summary>
  TClientLoginMessage = class(TOlfSMMessage)
  private
    FDeviceID: string;
    FPlayerID: string;
    FVersionAPI: integer;
    procedure SetDeviceID(const Value: string);
    procedure SetPlayerID(const Value: string);
    procedure SetVersionAPI(const Value: integer);
  public
    /// <summary>
    /// Device unique identifier
    /// </summary>
    property DeviceID: string read FDeviceID write SetDeviceID;
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: string read FPlayerID write SetPlayerID;
    /// <summary>
    /// Version API
    /// </summary>
    property VersionAPI: integer read FVersionAPI write SetVersionAPI;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 4: Client login response message
  /// </summary>
  TClientLoginResponseMessage = class(TOlfSMMessage)
  private
    FDeviceID: string;
    FSessionID: string;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    FScore: TSporglooAPINumber;
    FStars: TSporglooAPINumber;
    FLife: TSporglooAPINumber;
    procedure SetDeviceID(const Value: string);
    procedure SetSessionID(const Value: string);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
    procedure SetScore(const Value: TSporglooAPINumber);
    procedure SetStars(const Value: TSporglooAPINumber);
    procedure SetLife(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Device unique identifier
    /// </summary>
    property DeviceID: string read FDeviceID write SetDeviceID;
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: string read FSessionID write SetSessionID;
    /// <summary>
    /// X
    /// </summary>
    property X: TSporglooAPINumber read FX write SetX;
    /// <summary>
    /// Y
    /// </summary>
    property Y: TSporglooAPINumber read FY write SetY;
    /// <summary>
    /// Score
    /// </summary>
    property Score: TSporglooAPINumber read FScore write SetScore;
    /// <summary>
    /// Stars count
    /// </summary>
    property Stars: TSporglooAPINumber read FStars write SetStars;
    /// <summary>
    /// Live level
    /// </summary>
    property Life: TSporglooAPINumber read FLife write SetLife;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 1: Client register message
  /// </summary>
  TClientRegisterMessage = class(TOlfSMMessage)
  private
    FDeviceID: string;
    FVersionAPI: integer;
    procedure SetDeviceID(const Value: string);
    procedure SetVersionAPI(const Value: integer);
  public
    /// <summary>
    /// Device unique identifier
    /// </summary>
    property DeviceID: string read FDeviceID write SetDeviceID;
    /// <summary>
    /// Version API
    /// </summary>
    property VersionAPI: integer read FVersionAPI write SetVersionAPI;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 2: Client register response message
  /// </summary>
  TClientRegisterResponseMessage = class(TOlfSMMessage)
  private
    FDeviceID: string;
    FPlayerID: string;
    procedure SetDeviceID(const Value: string);
    procedure SetPlayerID(const Value: string);
  public
    /// <summary>
    /// Device unique identifier
    /// </summary>
    property DeviceID: string read FDeviceID write SetDeviceID;
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: string read FPlayerID write SetPlayerID;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 12: Error
  /// </summary>
  /// <remarks>
  /// An error message send when needed by a
  /// client or a server.
  /// </remarks>
  TErrorMessage = class(TOlfSMMessage)
  private
    FErrorCode: integer;
    procedure SetErrorCode(const Value: integer);
  public
    /// <summary>
    /// Error code
    /// </summary>
    /// <remarks>
    /// Contains the reason of denying client's connection.
    /// </remarks>
    property ErrorCode: integer read FErrorCode write SetErrorCode;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 13: Logoff
  /// </summary>
  TLogoffMessage = class(TOlfSMMessage)
  private
  public
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 6: Map cell message
  /// </summary>
  TMapCellMessage = class(TOlfSMMessage)
  private
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    FTileID: TSporglooAPIShort;
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
    procedure SetTileID(const Value: TSporglooAPIShort);
  public
    /// <summary>
    /// X
    /// </summary>
    property X: TSporglooAPINumber read FX write SetX;
    /// <summary>
    /// Y
    /// </summary>
    property Y: TSporglooAPINumber read FY write SetY;
    /// <summary>
    /// Tile identifier
    /// </summary>
    property TileID: TSporglooAPIShort read FTileID write SetTileID;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 5: Map refresh demand message
  /// </summary>
  TMapRefreshDemandMessage = class(TOlfSMMessage)
  private
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    FColNumber: TSporglooAPINumber;
    FRowNumber: TSporglooAPINumber;
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
    procedure SetColNumber(const Value: TSporglooAPINumber);
    procedure SetRowNumber(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// X
    /// </summary>
    property X: TSporglooAPINumber read FX write SetX;
    /// <summary>
    /// Y
    /// </summary>
    property Y: TSporglooAPINumber read FY write SetY;
    /// <summary>
    /// ColNumber
    /// </summary>
    property ColNumber: TSporglooAPINumber read FColNumber write SetColNumber;
    /// <summary>
    /// RowNumber
    /// </summary>
    property RowNumber: TSporglooAPINumber read FRowNumber write SetRowNumber;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 11: Other player move message
  /// </summary>
  TOtherPlayerMoveMessage = class(TOlfSMMessage)
  private
    FPlayerID: string;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    procedure SetPlayerID(const Value: string);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: string read FPlayerID write SetPlayerID;
    /// <summary>
    /// X
    /// </summary>
    property X: TSporglooAPINumber read FX write SetX;
    /// <summary>
    /// Y
    /// </summary>
    property Y: TSporglooAPINumber read FY write SetY;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 9: Player add a star on the map message
  /// </summary>
  TPlayerAddAStarOnTheMapMessage = class(TOlfSMMessage)
  private
    FSessionID: string;
    FPlayerID: string;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    procedure SetSessionID(const Value: string);
    procedure SetPlayerID(const Value: string);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: string read FSessionID write SetSessionID;
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: string read FPlayerID write SetPlayerID;
    /// <summary>
    /// X
    /// </summary>
    property X: TSporglooAPINumber read FX write SetX;
    /// <summary>
    /// Y
    /// </summary>
    property Y: TSporglooAPINumber read FY write SetY;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 7: Player move message
  /// </summary>
  TPlayerMoveMessage = class(TOlfSMMessage)
  private
    FSessionID: string;
    FPlayerID: string;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    procedure SetSessionID(const Value: string);
    procedure SetPlayerID(const Value: string);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: string read FSessionID write SetSessionID;
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: string read FPlayerID write SetPlayerID;
    /// <summary>
    /// X
    /// </summary>
    property X: TSporglooAPINumber read FX write SetX;
    /// <summary>
    /// Y
    /// </summary>
    property Y: TSporglooAPINumber read FY write SetY;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 8: Player move response
  /// </summary>
  TPlayerMoveResponseMessage = class(TOlfSMMessage)
  private
  public
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 10: Server accept the star adding message
  /// </summary>
  TServerAcceptTheStarAddingMessage = class(TOlfSMMessage)
  private
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// X
    /// </summary>
    property X: TSporglooAPINumber read FX write SetX;
    /// <summary>
    /// Y
    /// </summary>
    property Y: TSporglooAPINumber read FY write SetY;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  TSporglooSocketMessagesServer = class(TOlfSMServer)
  private
  protected
    procedure onReceiveMessage3(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage1(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage12(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage13(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage5(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage9(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage7(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
  public
    onReceiveClientLoginMessage
      : TOlfSMReceivedMessageEvent<TClientLoginMessage>;
    onReceiveClientRegisterMessage
      : TOlfSMReceivedMessageEvent<TClientRegisterMessage>;
    onReceiveErrorMessage
      : TOlfSMReceivedMessageEvent<TErrorMessage>;
    onReceiveLogoffMessage
      : TOlfSMReceivedMessageEvent<TLogoffMessage>;
    onReceiveMapRefreshDemandMessage
      : TOlfSMReceivedMessageEvent<TMapRefreshDemandMessage>;
    onReceivePlayerAddAStarOnTheMapMessage
      : TOlfSMReceivedMessageEvent<TPlayerAddAStarOnTheMapMessage>;
    onReceivePlayerMoveMessage
      : TOlfSMReceivedMessageEvent<TPlayerMoveMessage>;
    constructor Create; override;
  end;

  TSporglooSocketMessagesClient = class(TOlfSMClient)
  private
  protected
    procedure onReceiveMessage4(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage2(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage12(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage13(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage6(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage11(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage8(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage10(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
  public
    onReceiveClientLoginResponseMessage
      : TOlfSMReceivedMessageEvent<TClientLoginResponseMessage>;
    onReceiveClientRegisterResponseMessage
      : TOlfSMReceivedMessageEvent<TClientRegisterResponseMessage>;
    onReceiveErrorMessage
      : TOlfSMReceivedMessageEvent<TErrorMessage>;
    onReceiveLogoffMessage
      : TOlfSMReceivedMessageEvent<TLogoffMessage>;
    onReceiveMapCellMessage
      : TOlfSMReceivedMessageEvent<TMapCellMessage>;
    onReceiveOtherPlayerMoveMessage
      : TOlfSMReceivedMessageEvent<TOtherPlayerMoveMessage>;
    onReceivePlayerMoveResponseMessage
      : TOlfSMReceivedMessageEvent<TPlayerMoveResponseMessage>;
    onReceiveServerAcceptTheStarAddingMessage
      : TOlfSMReceivedMessageEvent<TServerAcceptTheStarAddingMessage>;
    constructor Create; override;
  end;

procedure RegisterMessagesReceivedByTheServer(Const Server: TOlfSMServer);
procedure RegisterMessagesReceivedByTheClient(Const Client: TOlfSMClient);

implementation

uses
  System.SysUtils;

{$REGION 'code from Olf.RTL.Streams'}

procedure SaveStringToStream(AString: string; AStream: TStream;
  AEncoding: TEncoding); overload;
// From unit Olf.RTL.Streams.pas in repository :
// https://github.com/DeveloppeurPascal/librairies
var
  StrLen: int64; // typeof(System.Classes.TStream.size)
  StrStream: TStringStream;
begin
  StrStream := TStringStream.Create(AString, AEncoding);
  try
    StrLen := StrStream.Size;
    AStream.write(StrLen, sizeof(StrLen));
    if (StrLen > 0) then
    begin
      StrStream.Position := 0;
      AStream.CopyFrom(StrStream);
    end;
  finally
    StrStream.Free;
  end;
end;

procedure SaveStringToStream(AString: string; AStream: TStream); overload;
// From unit Olf.RTL.Streams.pas in repository :
// https://github.com/DeveloppeurPascal/librairies
begin
  SaveStringToStream(AString, AStream, TEncoding.UTF8);
end;

function LoadStringFromStream(AStream: TStream; AEncoding: TEncoding)
  : string; overload;
// From unit Olf.RTL.Streams.pas in repository :
// https://github.com/DeveloppeurPascal/librairies
var
  StrLen: int64; // typeof(System.Classes.TStream.size)
  StrStream: TStringStream;
begin
  AStream.Read(StrLen, sizeof(StrLen));
  if (StrLen > 0) then
  begin
    StrStream := TStringStream.Create('', AEncoding);
    try
      StrStream.CopyFrom(AStream, StrLen);
      result := StrStream.DataString;
    finally
      StrStream.Free;
    end;
  end
  else
    result := '';
end;

function LoadStringFromStream(AStream: TStream): string; overload;
// From unit Olf.RTL.Streams.pas in repository :
// https://github.com/DeveloppeurPascal/librairies
begin
  result := LoadStringFromStream(AStream, TEncoding.UTF8);
end;

{$ENDREGION}

procedure RegisterMessagesReceivedByTheServer(Const Server: TOlfSMServer);
begin
  Server.RegisterMessageToReceive(TClientLoginMessage.Create);
  Server.RegisterMessageToReceive(TClientRegisterMessage.Create);
  Server.RegisterMessageToReceive(TErrorMessage.Create);
  Server.RegisterMessageToReceive(TLogoffMessage.Create);
  Server.RegisterMessageToReceive(TMapRefreshDemandMessage.Create);
  Server.RegisterMessageToReceive(TPlayerAddAStarOnTheMapMessage.Create);
  Server.RegisterMessageToReceive(TPlayerMoveMessage.Create);
end;

procedure RegisterMessagesReceivedByTheClient(Const Client: TOlfSMClient);
begin
  Client.RegisterMessageToReceive(TClientLoginResponseMessage.Create);
  Client.RegisterMessageToReceive(TClientRegisterResponseMessage.Create);
  Client.RegisterMessageToReceive(TErrorMessage.Create);
  Client.RegisterMessageToReceive(TLogoffMessage.Create);
  Client.RegisterMessageToReceive(TMapCellMessage.Create);
  Client.RegisterMessageToReceive(TOtherPlayerMoveMessage.Create);
  Client.RegisterMessageToReceive(TPlayerMoveResponseMessage.Create);
  Client.RegisterMessageToReceive(TServerAcceptTheStarAddingMessage.Create);
end;

{$REGION 'TSporglooSocketMessagesServer'}

constructor TSporglooSocketMessagesServer.Create;
begin
  inherited;
  RegisterMessagesReceivedByTheServer(self);
  SubscribeToMessage(3, onReceiveMessage3);
  SubscribeToMessage(1, onReceiveMessage1);
  SubscribeToMessage(12, onReceiveMessage12);
  SubscribeToMessage(13, onReceiveMessage13);
  SubscribeToMessage(5, onReceiveMessage5);
  SubscribeToMessage(9, onReceiveMessage9);
  SubscribeToMessage(7, onReceiveMessage7);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage3(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TClientLoginMessage) then
    exit;
  if not assigned(onReceiveClientLoginMessage) then
    exit;
  onReceiveClientLoginMessage(ASender, AMessage as TClientLoginMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage1(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TClientRegisterMessage) then
    exit;
  if not assigned(onReceiveClientRegisterMessage) then
    exit;
  onReceiveClientRegisterMessage(ASender, AMessage as TClientRegisterMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage12(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TErrorMessage) then
    exit;
  if not assigned(onReceiveErrorMessage) then
    exit;
  onReceiveErrorMessage(ASender, AMessage as TErrorMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage13(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TLogoffMessage) then
    exit;
  if not assigned(onReceiveLogoffMessage) then
    exit;
  onReceiveLogoffMessage(ASender, AMessage as TLogoffMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage5(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TMapRefreshDemandMessage) then
    exit;
  if not assigned(onReceiveMapRefreshDemandMessage) then
    exit;
  onReceiveMapRefreshDemandMessage(ASender, AMessage as TMapRefreshDemandMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage9(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TPlayerAddAStarOnTheMapMessage) then
    exit;
  if not assigned(onReceivePlayerAddAStarOnTheMapMessage) then
    exit;
  onReceivePlayerAddAStarOnTheMapMessage(ASender, AMessage as TPlayerAddAStarOnTheMapMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage7(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TPlayerMoveMessage) then
    exit;
  if not assigned(onReceivePlayerMoveMessage) then
    exit;
  onReceivePlayerMoveMessage(ASender, AMessage as TPlayerMoveMessage);
end;

{$ENDREGION}

{$REGION 'TSporglooSocketMessagesClient'}

constructor TSporglooSocketMessagesClient.Create;
begin
  inherited;
  RegisterMessagesReceivedByTheClient(self);
  SubscribeToMessage(4, onReceiveMessage4);
  SubscribeToMessage(2, onReceiveMessage2);
  SubscribeToMessage(12, onReceiveMessage12);
  SubscribeToMessage(13, onReceiveMessage13);
  SubscribeToMessage(6, onReceiveMessage6);
  SubscribeToMessage(11, onReceiveMessage11);
  SubscribeToMessage(8, onReceiveMessage8);
  SubscribeToMessage(10, onReceiveMessage10);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage4(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TClientLoginResponseMessage) then
    exit;
  if not assigned(onReceiveClientLoginResponseMessage) then
    exit;
  onReceiveClientLoginResponseMessage(ASender, AMessage as TClientLoginResponseMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage2(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TClientRegisterResponseMessage) then
    exit;
  if not assigned(onReceiveClientRegisterResponseMessage) then
    exit;
  onReceiveClientRegisterResponseMessage(ASender, AMessage as TClientRegisterResponseMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage12(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TErrorMessage) then
    exit;
  if not assigned(onReceiveErrorMessage) then
    exit;
  onReceiveErrorMessage(ASender, AMessage as TErrorMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage13(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TLogoffMessage) then
    exit;
  if not assigned(onReceiveLogoffMessage) then
    exit;
  onReceiveLogoffMessage(ASender, AMessage as TLogoffMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage6(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TMapCellMessage) then
    exit;
  if not assigned(onReceiveMapCellMessage) then
    exit;
  onReceiveMapCellMessage(ASender, AMessage as TMapCellMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage11(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TOtherPlayerMoveMessage) then
    exit;
  if not assigned(onReceiveOtherPlayerMoveMessage) then
    exit;
  onReceiveOtherPlayerMoveMessage(ASender, AMessage as TOtherPlayerMoveMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage8(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TPlayerMoveResponseMessage) then
    exit;
  if not assigned(onReceivePlayerMoveResponseMessage) then
    exit;
  onReceivePlayerMoveResponseMessage(ASender, AMessage as TPlayerMoveResponseMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage10(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TServerAcceptTheStarAddingMessage) then
    exit;
  if not assigned(onReceiveServerAcceptTheStarAddingMessage) then
    exit;
  onReceiveServerAcceptTheStarAddingMessage(ASender, AMessage as TServerAcceptTheStarAddingMessage);
end;

{$ENDREGION}

{$REGION 'TClientLoginMessage' }

constructor TClientLoginMessage.Create;
begin
  inherited;
  MessageID := 3;
  FDeviceID := '';
  FPlayerID := '';
  FVersionAPI := 0;
end;

function TClientLoginMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TClientLoginMessage.Create;
end;

procedure TClientLoginMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FDeviceID := LoadStringFromStream(Stream);
  FPlayerID := LoadStringFromStream(Stream);
  if (Stream.read(FVersionAPI, sizeof(FVersionAPI)) <> sizeof(FVersionAPI)) then
    raise exception.Create('Can''t load "VersionAPI" value.');
end;

procedure TClientLoginMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FDeviceID, Stream);
  SaveStringToStream(FPlayerID, Stream);
  Stream.Write(FVersionAPI, sizeof(FVersionAPI));
end;

procedure TClientLoginMessage.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TClientLoginMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TClientLoginMessage.SetVersionAPI(const Value: integer);
begin
  FVersionAPI := Value;
end;

{$ENDREGION}

{$REGION 'TClientLoginResponseMessage' }

constructor TClientLoginResponseMessage.Create;
begin
  inherited;
  MessageID := 4;
  FDeviceID := '';
  FSessionID := '';
  FX := 0;
  FY := 0;
  FScore := 0;
  FStars := 0;
  FLife := 0;
end;

function TClientLoginResponseMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TClientLoginResponseMessage.Create;
end;

procedure TClientLoginResponseMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FDeviceID := LoadStringFromStream(Stream);
  FSessionID := LoadStringFromStream(Stream);
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
  if (Stream.read(FScore, sizeof(FScore)) <> sizeof(FScore)) then
    raise exception.Create('Can''t load "Score" value.');
  if (Stream.read(FStars, sizeof(FStars)) <> sizeof(FStars)) then
    raise exception.Create('Can''t load "Stars" value.');
  if (Stream.read(FLife, sizeof(FLife)) <> sizeof(FLife)) then
    raise exception.Create('Can''t load "Life" value.');
end;

procedure TClientLoginResponseMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FDeviceID, Stream);
  SaveStringToStream(FSessionID, Stream);
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
  Stream.Write(FScore, sizeof(FScore));
  Stream.Write(FStars, sizeof(FStars));
  Stream.Write(FLife, sizeof(FLife));
end;

procedure TClientLoginResponseMessage.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TClientLoginResponseMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TClientLoginResponseMessage.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TClientLoginResponseMessage.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

procedure TClientLoginResponseMessage.SetScore(const Value: TSporglooAPINumber);
begin
  FScore := Value;
end;

procedure TClientLoginResponseMessage.SetStars(const Value: TSporglooAPINumber);
begin
  FStars := Value;
end;

procedure TClientLoginResponseMessage.SetLife(const Value: TSporglooAPINumber);
begin
  FLife := Value;
end;

{$ENDREGION}

{$REGION 'TClientRegisterMessage' }

constructor TClientRegisterMessage.Create;
begin
  inherited;
  MessageID := 1;
  FDeviceID := '';
  FVersionAPI := 0;
end;

function TClientRegisterMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TClientRegisterMessage.Create;
end;

procedure TClientRegisterMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FDeviceID := LoadStringFromStream(Stream);
  if (Stream.read(FVersionAPI, sizeof(FVersionAPI)) <> sizeof(FVersionAPI)) then
    raise exception.Create('Can''t load "VersionAPI" value.');
end;

procedure TClientRegisterMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FDeviceID, Stream);
  Stream.Write(FVersionAPI, sizeof(FVersionAPI));
end;

procedure TClientRegisterMessage.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TClientRegisterMessage.SetVersionAPI(const Value: integer);
begin
  FVersionAPI := Value;
end;

{$ENDREGION}

{$REGION 'TClientRegisterResponseMessage' }

constructor TClientRegisterResponseMessage.Create;
begin
  inherited;
  MessageID := 2;
  FDeviceID := '';
  FPlayerID := '';
end;

function TClientRegisterResponseMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TClientRegisterResponseMessage.Create;
end;

procedure TClientRegisterResponseMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FDeviceID := LoadStringFromStream(Stream);
  FPlayerID := LoadStringFromStream(Stream);
end;

procedure TClientRegisterResponseMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FDeviceID, Stream);
  SaveStringToStream(FPlayerID, Stream);
end;

procedure TClientRegisterResponseMessage.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TClientRegisterResponseMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

{$ENDREGION}

{$REGION 'TErrorMessage' }

constructor TErrorMessage.Create;
begin
  inherited;
  MessageID := 12;
  FErrorCode := 0;
end;

function TErrorMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TErrorMessage.Create;
end;

procedure TErrorMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FErrorCode, sizeof(FErrorCode)) <> sizeof(FErrorCode)) then
    raise exception.Create('Can''t load "ErrorCode" value.');
end;

procedure TErrorMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FErrorCode, sizeof(FErrorCode));
end;

procedure TErrorMessage.SetErrorCode(const Value: integer);
begin
  FErrorCode := Value;
end;

{$ENDREGION}

{$REGION 'TLogoffMessage' }

constructor TLogoffMessage.Create;
begin
  inherited;
  MessageID := 13;
end;

function TLogoffMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TLogoffMessage.Create;
end;

procedure TLogoffMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
end;

procedure TLogoffMessage.SaveToStream(Stream: TStream);
begin
  inherited;
end;

{$ENDREGION}

{$REGION 'TMapCellMessage' }

constructor TMapCellMessage.Create;
begin
  inherited;
  MessageID := 6;
  FX := 0;
  FY := 0;
  FTileID := 0;
end;

function TMapCellMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TMapCellMessage.Create;
end;

procedure TMapCellMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
  if (Stream.read(FTileID, sizeof(FTileID)) <> sizeof(FTileID)) then
    raise exception.Create('Can''t load "TileID" value.');
end;

procedure TMapCellMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
  Stream.Write(FTileID, sizeof(FTileID));
end;

procedure TMapCellMessage.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TMapCellMessage.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

procedure TMapCellMessage.SetTileID(const Value: TSporglooAPIShort);
begin
  FTileID := Value;
end;

{$ENDREGION}

{$REGION 'TMapRefreshDemandMessage' }

constructor TMapRefreshDemandMessage.Create;
begin
  inherited;
  MessageID := 5;
  FX := 0;
  FY := 0;
  FColNumber := 0;
  FRowNumber := 0;
end;

function TMapRefreshDemandMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TMapRefreshDemandMessage.Create;
end;

procedure TMapRefreshDemandMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
  if (Stream.read(FColNumber, sizeof(FColNumber)) <> sizeof(FColNumber)) then
    raise exception.Create('Can''t load "ColNumber" value.');
  if (Stream.read(FRowNumber, sizeof(FRowNumber)) <> sizeof(FRowNumber)) then
    raise exception.Create('Can''t load "RowNumber" value.');
end;

procedure TMapRefreshDemandMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
  Stream.Write(FColNumber, sizeof(FColNumber));
  Stream.Write(FRowNumber, sizeof(FRowNumber));
end;

procedure TMapRefreshDemandMessage.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TMapRefreshDemandMessage.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

procedure TMapRefreshDemandMessage.SetColNumber(const Value: TSporglooAPINumber);
begin
  FColNumber := Value;
end;

procedure TMapRefreshDemandMessage.SetRowNumber(const Value: TSporglooAPINumber);
begin
  FRowNumber := Value;
end;

{$ENDREGION}

{$REGION 'TOtherPlayerMoveMessage' }

constructor TOtherPlayerMoveMessage.Create;
begin
  inherited;
  MessageID := 11;
  FPlayerID := '';
  FX := 0;
  FY := 0;
end;

function TOtherPlayerMoveMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TOtherPlayerMoveMessage.Create;
end;

procedure TOtherPlayerMoveMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FPlayerID := LoadStringFromStream(Stream);
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
end;

procedure TOtherPlayerMoveMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FPlayerID, Stream);
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
end;

procedure TOtherPlayerMoveMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TOtherPlayerMoveMessage.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TOtherPlayerMoveMessage.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

{$ENDREGION}

{$REGION 'TPlayerAddAStarOnTheMapMessage' }

constructor TPlayerAddAStarOnTheMapMessage.Create;
begin
  inherited;
  MessageID := 9;
  FSessionID := '';
  FPlayerID := '';
  FX := 0;
  FY := 0;
end;

function TPlayerAddAStarOnTheMapMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TPlayerAddAStarOnTheMapMessage.Create;
end;

procedure TPlayerAddAStarOnTheMapMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FSessionID := LoadStringFromStream(Stream);
  FPlayerID := LoadStringFromStream(Stream);
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
end;

procedure TPlayerAddAStarOnTheMapMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FSessionID, Stream);
  SaveStringToStream(FPlayerID, Stream);
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
end;

procedure TPlayerAddAStarOnTheMapMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TPlayerAddAStarOnTheMapMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TPlayerAddAStarOnTheMapMessage.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TPlayerAddAStarOnTheMapMessage.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

{$ENDREGION}

{$REGION 'TPlayerMoveMessage' }

constructor TPlayerMoveMessage.Create;
begin
  inherited;
  MessageID := 7;
  FSessionID := '';
  FPlayerID := '';
  FX := 0;
  FY := 0;
end;

function TPlayerMoveMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TPlayerMoveMessage.Create;
end;

procedure TPlayerMoveMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FSessionID := LoadStringFromStream(Stream);
  FPlayerID := LoadStringFromStream(Stream);
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
end;

procedure TPlayerMoveMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FSessionID, Stream);
  SaveStringToStream(FPlayerID, Stream);
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
end;

procedure TPlayerMoveMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TPlayerMoveMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TPlayerMoveMessage.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TPlayerMoveMessage.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

{$ENDREGION}

{$REGION 'TPlayerMoveResponseMessage' }

constructor TPlayerMoveResponseMessage.Create;
begin
  inherited;
  MessageID := 8;
end;

function TPlayerMoveResponseMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TPlayerMoveResponseMessage.Create;
end;

procedure TPlayerMoveResponseMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
end;

procedure TPlayerMoveResponseMessage.SaveToStream(Stream: TStream);
begin
  inherited;
end;

{$ENDREGION}

{$REGION 'TServerAcceptTheStarAddingMessage' }

constructor TServerAcceptTheStarAddingMessage.Create;
begin
  inherited;
  MessageID := 10;
  FX := 0;
  FY := 0;
end;

function TServerAcceptTheStarAddingMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TServerAcceptTheStarAddingMessage.Create;
end;

procedure TServerAcceptTheStarAddingMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
end;

procedure TServerAcceptTheStarAddingMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
end;

procedure TServerAcceptTheStarAddingMessage.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TServerAcceptTheStarAddingMessage.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

{$ENDREGION}

end.
