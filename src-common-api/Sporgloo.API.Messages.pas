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
// Generation date : 10/05/2024 17:35:29
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
  /// Message ID 5: Ask for map refresh
  /// </summary>
  TAskForMapRefreshMessage = class(TOlfSMMessage)
  private
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    FColNumber: TSporglooAPINumber;
    FRowNumber: TSporglooAPINumber;
    FSessionID: string;
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
    procedure SetColNumber(const Value: TSporglooAPINumber);
    procedure SetRowNumber(const Value: TSporglooAPINumber);
    procedure SetSessionID(const Value: string);
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
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: string read FSessionID write SetSessionID;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 18: Ask for player infos
  /// </summary>
  TAskForPlayerInfosMessage = class(TOlfSMMessage)
  private
    FSessionID: string;
    FPlayerID: string;
    procedure SetSessionID(const Value: string);
    procedure SetPlayerID(const Value: string);
  public
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: string read FSessionID write SetSessionID;
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
  /// Message ID 3: Client login (deprecated)
  /// </summary>
  TClientLoginDeprecatedMessage = class(TOlfSMMessage)
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
  /// Message ID 21: Client login
  /// </summary>
  TClientLoginMessage = class(TOlfSMMessage)
  private
    FVersionAPI: integer;
    FDeviceID: string;
    FPlayerID: string;
    FTokenID: string;
    procedure SetVersionAPI(const Value: integer);
    procedure SetDeviceID(const Value: string);
    procedure SetPlayerID(const Value: string);
    procedure SetTokenID(const Value: string);
  public
    /// <summary>
    /// Version API
    /// </summary>
    property VersionAPI: integer read FVersionAPI write SetVersionAPI;
    /// <summary>
    /// Device unique identifier
    /// </summary>
    property DeviceID: string read FDeviceID write SetDeviceID;
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: string read FPlayerID write SetPlayerID;
    /// <summary>
    /// Token identifier
    /// </summary>
    /// <remarks>
    /// calculated with the private DeviceAuthKey,
    /// DeviceID, PlayerID and the private server
    /// password
    /// </remarks>
    property TokenID: string read FTokenID write SetTokenID;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 4: Client login response
  /// </summary>
  TClientLoginResponseMessage = class(TOlfSMMessage)
  private
    FDeviceID: string;
    FSessionID: string;
    FPlayerID: string;
    procedure SetDeviceID(const Value: string);
    procedure SetSessionID(const Value: string);
    procedure SetPlayerID(const Value: string);
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
    /// Player unique identifier
    /// </summary>
    property PlayerID: string read FPlayerID write SetPlayerID;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 1: Client register (deprecated)
  /// </summary>
  TClientRegisterDeprecatedMessage = class(TOlfSMMessage)
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
  /// Message ID 20: Client register
  /// </summary>
  TClientRegisterMessage = class(TOlfSMMessage)
  private
    FVersionAPI: integer;
    FDeviceID: string;
    FServerAuthKey: string;
    procedure SetVersionAPI(const Value: integer);
    procedure SetDeviceID(const Value: string);
    procedure SetServerAuthKey(const Value: string);
  public
    /// <summary>
    /// Version API
    /// </summary>
    property VersionAPI: integer read FVersionAPI write SetVersionAPI;
    /// <summary>
    /// Device unique identifier
    /// </summary>
    property DeviceID: string read FDeviceID write SetDeviceID;
    /// <summary>
    /// Server authorization key
    /// </summary>
    /// <remarks>
    /// Token generated with DeviceID and the server
    /// private login password
    /// </remarks>
    property ServerAuthKey: string read FServerAuthKey write SetServerAuthKey;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 2: Client register response
  /// </summary>
  TClientRegisterResponseMessage = class(TOlfSMMessage)
  private
    FDeviceID: string;
    FPlayerID: string;
    FDeviceAuthKey: string;
    procedure SetDeviceID(const Value: string);
    procedure SetPlayerID(const Value: string);
    procedure SetDeviceAuthKey(const Value: string);
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
    /// Device authorization key
    /// </summary>
    /// <remarks>
    /// Private password for this device, to use to
    /// sign the TokenID in login messages
    /// </remarks>
    property DeviceAuthKey: string read FDeviceAuthKey write SetDeviceAuthKey;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 16: Coins change
  /// </summary>
  TCoinsChangeMessage = class(TOlfSMMessage)
  private
    FCoinsCount: TSporglooAPINumber;
    procedure SetCoinsCount(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Nb coins to add or substract
    /// </summary>
    property CoinsCount: TSporglooAPINumber read FCoinsCount write SetCoinsCount;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 25: Current player killed
  /// </summary>
  TCurrentPlayerKilledMessage = class(TOlfSMMessage)
  private
  public
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
  /// Message ID 22: Get hall of fame scores
  /// </summary>
  TGetHallOfFameScoresMessage = class(TOlfSMMessage)
  private
    FSessionID: string;
    FPageNumber: integer;
    procedure SetSessionID(const Value: string);
    procedure SetPageNumber(const Value: integer);
  public
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: string read FSessionID write SetSessionID;
    /// <summary>
    /// Page number
    /// </summary>
    property PageNumber: integer read FPageNumber write SetPageNumber;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 23: Hall of fame
  /// </summary>
  THallOfFameMessage = class(TOlfSMMessage)
  private
  public
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 24: Kill current player
  /// </summary>
  /// <remarks>
  /// This message is used to start a new game on
  /// the same device.
  /// </remarks>
  TKillCurrentPlayerMessage = class(TOlfSMMessage)
  private
    FSessionID: string;
    FPlayerID: string;
    procedure SetSessionID(const Value: string);
    procedure SetPlayerID(const Value: string);
  public
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: string read FSessionID write SetSessionID;
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
  /// Message ID 15: Lives count change
  /// </summary>
  TLivesCountChangeMessage = class(TOlfSMMessage)
  private
    FLivesCount: TSporglooAPINumber;
    procedure SetLivesCount(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Nb life to add or substract
    /// </summary>
    property LivesCount: TSporglooAPINumber read FLivesCount write SetLivesCount;
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
  /// Message ID 6: Map cell info
  /// </summary>
  TMapCellInfoMessage = class(TOlfSMMessage)
  private
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    FTileID: TSporglooAPIShort;
    FPlayerID: string;
    FImageID: integer;
    FStarsCount: TSporglooAPINumber;
    FLivesCount: TSporglooAPINumber;
    FCoinsCount: TSporglooAPINumber;
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
    procedure SetTileID(const Value: TSporglooAPIShort);
    procedure SetPlayerID(const Value: string);
    procedure SetImageID(const Value: integer);
    procedure SetStarsCount(const Value: TSporglooAPINumber);
    procedure SetLivesCount(const Value: TSporglooAPINumber);
    procedure SetCoinsCount(const Value: TSporglooAPINumber);
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
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: string read FPlayerID write SetPlayerID;
    /// <summary>
    /// Player image identifier
    /// </summary>
    property ImageID: integer read FImageID write SetImageID;
    /// <summary>
    /// Number of stars to collect
    /// </summary>
    property StarsCount: TSporglooAPINumber read FStarsCount write SetStarsCount;
    /// <summary>
    /// Number of lives to collect
    /// </summary>
    property LivesCount: TSporglooAPINumber read FLivesCount write SetLivesCount;
    /// <summary>
    /// Number of coins to collect
    /// </summary>
    property CoinsCount: TSporglooAPINumber read FCoinsCount write SetCoinsCount;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 9: Player add a star on the map
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
  /// Message ID 19: Player image changed
  /// </summary>
  TPlayerImageChangedMessage = class(TOlfSMMessage)
  private
    FSessionID: string;
    FImageID: integer;
    procedure SetSessionID(const Value: string);
    procedure SetImageID(const Value: integer);
  public
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: string read FSessionID write SetSessionID;
    /// <summary>
    /// ImageID
    /// </summary>
    property ImageID: integer read FImageID write SetImageID;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 17: Player infos
  /// </summary>
  TPlayerInfosMessage = class(TOlfSMMessage)
  private
    FPlayerID: string;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    FImageID: integer;
    FCoinsCount: TSporglooAPINumber;
    FStarsCount: TSporglooAPINumber;
    FLivesCount: TSporglooAPINumber;
    procedure SetPlayerID(const Value: string);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
    procedure SetImageID(const Value: integer);
    procedure SetCoinsCount(const Value: TSporglooAPINumber);
    procedure SetStarsCount(const Value: TSporglooAPINumber);
    procedure SetLivesCount(const Value: TSporglooAPINumber);
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
    /// <summary>
    /// Player image identifier
    /// </summary>
    property ImageID: integer read FImageID write SetImageID;
    /// <summary>
    /// Coins count
    /// </summary>
    property CoinsCount: TSporglooAPINumber read FCoinsCount write SetCoinsCount;
    /// <summary>
    /// Stars count
    /// </summary>
    property StarsCount: TSporglooAPINumber read FStarsCount write SetStarsCount;
    /// <summary>
    /// Lives count
    /// </summary>
    property LivesCount: TSporglooAPINumber read FLivesCount write SetLivesCount;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  /// <summary>
  /// Message ID 7: Player move
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
  /// Message ID 14: Stars count change
  /// </summary>
  TStarsCountChangeMessage = class(TOlfSMMessage)
  private
    FStarsCount: TSporglooAPINumber;
    procedure SetStarsCount(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Nb stars to add or substract
    /// </summary>
    property StarsCount: TSporglooAPINumber read FStarsCount write SetStarsCount;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSMMessage; override;
  end;

  TSporglooSocketMessagesServer = class(TOlfSMServer)
  private
  protected
    procedure onReceiveMessage5(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage18(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage3(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage21(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage1(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage20(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage12(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage22(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage24(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage13(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage9(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage19(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage7(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
  public
    onReceiveAskForMapRefreshMessage
      : TOlfSMReceivedMessageEvent<TAskForMapRefreshMessage>;
    onReceiveAskForPlayerInfosMessage
      : TOlfSMReceivedMessageEvent<TAskForPlayerInfosMessage>;
    onReceiveClientLoginDeprecatedMessage
      : TOlfSMReceivedMessageEvent<TClientLoginDeprecatedMessage>;
    onReceiveClientLoginMessage
      : TOlfSMReceivedMessageEvent<TClientLoginMessage>;
    onReceiveClientRegisterDeprecatedMessage
      : TOlfSMReceivedMessageEvent<TClientRegisterDeprecatedMessage>;
    onReceiveClientRegisterMessage
      : TOlfSMReceivedMessageEvent<TClientRegisterMessage>;
    onReceiveErrorMessage
      : TOlfSMReceivedMessageEvent<TErrorMessage>;
    onReceiveGetHallOfFameScoresMessage
      : TOlfSMReceivedMessageEvent<TGetHallOfFameScoresMessage>;
    onReceiveKillCurrentPlayerMessage
      : TOlfSMReceivedMessageEvent<TKillCurrentPlayerMessage>;
    onReceiveLogoffMessage
      : TOlfSMReceivedMessageEvent<TLogoffMessage>;
    onReceivePlayerAddAStarOnTheMapMessage
      : TOlfSMReceivedMessageEvent<TPlayerAddAStarOnTheMapMessage>;
    onReceivePlayerImageChangedMessage
      : TOlfSMReceivedMessageEvent<TPlayerImageChangedMessage>;
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
    procedure onReceiveMessage16(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage25(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage12(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage23(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage15(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage13(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage6(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage17(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
    procedure onReceiveMessage14(Const ASender: TOlfSMSrvConnectedClient;
      Const AMessage: TOlfSMMessage);
  public
    onReceiveClientLoginResponseMessage
      : TOlfSMReceivedMessageEvent<TClientLoginResponseMessage>;
    onReceiveClientRegisterResponseMessage
      : TOlfSMReceivedMessageEvent<TClientRegisterResponseMessage>;
    onReceiveCoinsChangeMessage
      : TOlfSMReceivedMessageEvent<TCoinsChangeMessage>;
    onReceiveCurrentPlayerKilledMessage
      : TOlfSMReceivedMessageEvent<TCurrentPlayerKilledMessage>;
    onReceiveErrorMessage
      : TOlfSMReceivedMessageEvent<TErrorMessage>;
    onReceiveHallOfFameMessage
      : TOlfSMReceivedMessageEvent<THallOfFameMessage>;
    onReceiveLivesCountChangeMessage
      : TOlfSMReceivedMessageEvent<TLivesCountChangeMessage>;
    onReceiveLogoffMessage
      : TOlfSMReceivedMessageEvent<TLogoffMessage>;
    onReceiveMapCellInfoMessage
      : TOlfSMReceivedMessageEvent<TMapCellInfoMessage>;
    onReceivePlayerInfosMessage
      : TOlfSMReceivedMessageEvent<TPlayerInfosMessage>;
    onReceiveStarsCountChangeMessage
      : TOlfSMReceivedMessageEvent<TStarsCountChangeMessage>;
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
  Server.RegisterMessageToReceive(TAskForMapRefreshMessage.Create);
  Server.RegisterMessageToReceive(TAskForPlayerInfosMessage.Create);
  Server.RegisterMessageToReceive(TClientLoginDeprecatedMessage.Create);
  Server.RegisterMessageToReceive(TClientLoginMessage.Create);
  Server.RegisterMessageToReceive(TClientRegisterDeprecatedMessage.Create);
  Server.RegisterMessageToReceive(TClientRegisterMessage.Create);
  Server.RegisterMessageToReceive(TErrorMessage.Create);
  Server.RegisterMessageToReceive(TGetHallOfFameScoresMessage.Create);
  Server.RegisterMessageToReceive(TKillCurrentPlayerMessage.Create);
  Server.RegisterMessageToReceive(TLogoffMessage.Create);
  Server.RegisterMessageToReceive(TPlayerAddAStarOnTheMapMessage.Create);
  Server.RegisterMessageToReceive(TPlayerImageChangedMessage.Create);
  Server.RegisterMessageToReceive(TPlayerMoveMessage.Create);
end;

procedure RegisterMessagesReceivedByTheClient(Const Client: TOlfSMClient);
begin
  Client.RegisterMessageToReceive(TClientLoginResponseMessage.Create);
  Client.RegisterMessageToReceive(TClientRegisterResponseMessage.Create);
  Client.RegisterMessageToReceive(TCoinsChangeMessage.Create);
  Client.RegisterMessageToReceive(TCurrentPlayerKilledMessage.Create);
  Client.RegisterMessageToReceive(TErrorMessage.Create);
  Client.RegisterMessageToReceive(THallOfFameMessage.Create);
  Client.RegisterMessageToReceive(TLivesCountChangeMessage.Create);
  Client.RegisterMessageToReceive(TLogoffMessage.Create);
  Client.RegisterMessageToReceive(TMapCellInfoMessage.Create);
  Client.RegisterMessageToReceive(TPlayerInfosMessage.Create);
  Client.RegisterMessageToReceive(TStarsCountChangeMessage.Create);
end;

{$REGION 'TSporglooSocketMessagesServer'}

constructor TSporglooSocketMessagesServer.Create;
begin
  inherited;
  RegisterMessagesReceivedByTheServer(self);
  SubscribeToMessage(5, onReceiveMessage5);
  SubscribeToMessage(18, onReceiveMessage18);
  SubscribeToMessage(3, onReceiveMessage3);
  SubscribeToMessage(21, onReceiveMessage21);
  SubscribeToMessage(1, onReceiveMessage1);
  SubscribeToMessage(20, onReceiveMessage20);
  SubscribeToMessage(12, onReceiveMessage12);
  SubscribeToMessage(22, onReceiveMessage22);
  SubscribeToMessage(24, onReceiveMessage24);
  SubscribeToMessage(13, onReceiveMessage13);
  SubscribeToMessage(9, onReceiveMessage9);
  SubscribeToMessage(19, onReceiveMessage19);
  SubscribeToMessage(7, onReceiveMessage7);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage5(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TAskForMapRefreshMessage) then
    exit;
  if not assigned(onReceiveAskForMapRefreshMessage) then
    exit;
  onReceiveAskForMapRefreshMessage(ASender, AMessage as TAskForMapRefreshMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage18(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TAskForPlayerInfosMessage) then
    exit;
  if not assigned(onReceiveAskForPlayerInfosMessage) then
    exit;
  onReceiveAskForPlayerInfosMessage(ASender, AMessage as TAskForPlayerInfosMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage3(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TClientLoginDeprecatedMessage) then
    exit;
  if not assigned(onReceiveClientLoginDeprecatedMessage) then
    exit;
  onReceiveClientLoginDeprecatedMessage(ASender, AMessage as TClientLoginDeprecatedMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage21(const ASender: TOlfSMSrvConnectedClient;
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
  if not(AMessage is TClientRegisterDeprecatedMessage) then
    exit;
  if not assigned(onReceiveClientRegisterDeprecatedMessage) then
    exit;
  onReceiveClientRegisterDeprecatedMessage(ASender, AMessage as TClientRegisterDeprecatedMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage20(const ASender: TOlfSMSrvConnectedClient;
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

procedure TSporglooSocketMessagesServer.onReceiveMessage22(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TGetHallOfFameScoresMessage) then
    exit;
  if not assigned(onReceiveGetHallOfFameScoresMessage) then
    exit;
  onReceiveGetHallOfFameScoresMessage(ASender, AMessage as TGetHallOfFameScoresMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage24(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TKillCurrentPlayerMessage) then
    exit;
  if not assigned(onReceiveKillCurrentPlayerMessage) then
    exit;
  onReceiveKillCurrentPlayerMessage(ASender, AMessage as TKillCurrentPlayerMessage);
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

procedure TSporglooSocketMessagesServer.onReceiveMessage9(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TPlayerAddAStarOnTheMapMessage) then
    exit;
  if not assigned(onReceivePlayerAddAStarOnTheMapMessage) then
    exit;
  onReceivePlayerAddAStarOnTheMapMessage(ASender, AMessage as TPlayerAddAStarOnTheMapMessage);
end;

procedure TSporglooSocketMessagesServer.onReceiveMessage19(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TPlayerImageChangedMessage) then
    exit;
  if not assigned(onReceivePlayerImageChangedMessage) then
    exit;
  onReceivePlayerImageChangedMessage(ASender, AMessage as TPlayerImageChangedMessage);
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
  SubscribeToMessage(16, onReceiveMessage16);
  SubscribeToMessage(25, onReceiveMessage25);
  SubscribeToMessage(12, onReceiveMessage12);
  SubscribeToMessage(23, onReceiveMessage23);
  SubscribeToMessage(15, onReceiveMessage15);
  SubscribeToMessage(13, onReceiveMessage13);
  SubscribeToMessage(6, onReceiveMessage6);
  SubscribeToMessage(17, onReceiveMessage17);
  SubscribeToMessage(14, onReceiveMessage14);
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

procedure TSporglooSocketMessagesClient.onReceiveMessage16(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TCoinsChangeMessage) then
    exit;
  if not assigned(onReceiveCoinsChangeMessage) then
    exit;
  onReceiveCoinsChangeMessage(ASender, AMessage as TCoinsChangeMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage25(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TCurrentPlayerKilledMessage) then
    exit;
  if not assigned(onReceiveCurrentPlayerKilledMessage) then
    exit;
  onReceiveCurrentPlayerKilledMessage(ASender, AMessage as TCurrentPlayerKilledMessage);
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

procedure TSporglooSocketMessagesClient.onReceiveMessage23(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is THallOfFameMessage) then
    exit;
  if not assigned(onReceiveHallOfFameMessage) then
    exit;
  onReceiveHallOfFameMessage(ASender, AMessage as THallOfFameMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage15(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TLivesCountChangeMessage) then
    exit;
  if not assigned(onReceiveLivesCountChangeMessage) then
    exit;
  onReceiveLivesCountChangeMessage(ASender, AMessage as TLivesCountChangeMessage);
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
  if not(AMessage is TMapCellInfoMessage) then
    exit;
  if not assigned(onReceiveMapCellInfoMessage) then
    exit;
  onReceiveMapCellInfoMessage(ASender, AMessage as TMapCellInfoMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage17(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TPlayerInfosMessage) then
    exit;
  if not assigned(onReceivePlayerInfosMessage) then
    exit;
  onReceivePlayerInfosMessage(ASender, AMessage as TPlayerInfosMessage);
end;

procedure TSporglooSocketMessagesClient.onReceiveMessage14(const ASender: TOlfSMSrvConnectedClient;
const AMessage: TOlfSMMessage);
begin
  if not(AMessage is TStarsCountChangeMessage) then
    exit;
  if not assigned(onReceiveStarsCountChangeMessage) then
    exit;
  onReceiveStarsCountChangeMessage(ASender, AMessage as TStarsCountChangeMessage);
end;

{$ENDREGION}

{$REGION 'TAskForMapRefreshMessage' }

constructor TAskForMapRefreshMessage.Create;
begin
  inherited;
  MessageID := 5;
  FX := 0;
  FY := 0;
  FColNumber := 0;
  FRowNumber := 0;
  FSessionID := '';
end;

function TAskForMapRefreshMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TAskForMapRefreshMessage.Create;
end;

procedure TAskForMapRefreshMessage.LoadFromStream(Stream: TStream);
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
  FSessionID := LoadStringFromStream(Stream);
end;

procedure TAskForMapRefreshMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
  Stream.Write(FColNumber, sizeof(FColNumber));
  Stream.Write(FRowNumber, sizeof(FRowNumber));
  SaveStringToStream(FSessionID, Stream);
end;

procedure TAskForMapRefreshMessage.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TAskForMapRefreshMessage.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

procedure TAskForMapRefreshMessage.SetColNumber(const Value: TSporglooAPINumber);
begin
  FColNumber := Value;
end;

procedure TAskForMapRefreshMessage.SetRowNumber(const Value: TSporglooAPINumber);
begin
  FRowNumber := Value;
end;

procedure TAskForMapRefreshMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

{$ENDREGION}

{$REGION 'TAskForPlayerInfosMessage' }

constructor TAskForPlayerInfosMessage.Create;
begin
  inherited;
  MessageID := 18;
  FSessionID := '';
  FPlayerID := '';
end;

function TAskForPlayerInfosMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TAskForPlayerInfosMessage.Create;
end;

procedure TAskForPlayerInfosMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FSessionID := LoadStringFromStream(Stream);
  FPlayerID := LoadStringFromStream(Stream);
end;

procedure TAskForPlayerInfosMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FSessionID, Stream);
  SaveStringToStream(FPlayerID, Stream);
end;

procedure TAskForPlayerInfosMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TAskForPlayerInfosMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

{$ENDREGION}

{$REGION 'TClientLoginDeprecatedMessage' }

constructor TClientLoginDeprecatedMessage.Create;
begin
  inherited;
  MessageID := 3;
  FDeviceID := '';
  FPlayerID := '';
  FVersionAPI := 0;
end;

function TClientLoginDeprecatedMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TClientLoginDeprecatedMessage.Create;
end;

procedure TClientLoginDeprecatedMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FDeviceID := LoadStringFromStream(Stream);
  FPlayerID := LoadStringFromStream(Stream);
  if (Stream.read(FVersionAPI, sizeof(FVersionAPI)) <> sizeof(FVersionAPI)) then
    raise exception.Create('Can''t load "VersionAPI" value.');
end;

procedure TClientLoginDeprecatedMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FDeviceID, Stream);
  SaveStringToStream(FPlayerID, Stream);
  Stream.Write(FVersionAPI, sizeof(FVersionAPI));
end;

procedure TClientLoginDeprecatedMessage.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TClientLoginDeprecatedMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TClientLoginDeprecatedMessage.SetVersionAPI(const Value: integer);
begin
  FVersionAPI := Value;
end;

{$ENDREGION}

{$REGION 'TClientLoginMessage' }

constructor TClientLoginMessage.Create;
begin
  inherited;
  MessageID := 21;
  FVersionAPI := 0;
  FDeviceID := '';
  FPlayerID := '';
  FTokenID := '';
end;

function TClientLoginMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TClientLoginMessage.Create;
end;

procedure TClientLoginMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FVersionAPI, sizeof(FVersionAPI)) <> sizeof(FVersionAPI)) then
    raise exception.Create('Can''t load "VersionAPI" value.');
  FDeviceID := LoadStringFromStream(Stream);
  FPlayerID := LoadStringFromStream(Stream);
  FTokenID := LoadStringFromStream(Stream);
end;

procedure TClientLoginMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FVersionAPI, sizeof(FVersionAPI));
  SaveStringToStream(FDeviceID, Stream);
  SaveStringToStream(FPlayerID, Stream);
  SaveStringToStream(FTokenID, Stream);
end;

procedure TClientLoginMessage.SetVersionAPI(const Value: integer);
begin
  FVersionAPI := Value;
end;

procedure TClientLoginMessage.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TClientLoginMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TClientLoginMessage.SetTokenID(const Value: string);
begin
  FTokenID := Value;
end;

{$ENDREGION}

{$REGION 'TClientLoginResponseMessage' }

constructor TClientLoginResponseMessage.Create;
begin
  inherited;
  MessageID := 4;
  FDeviceID := '';
  FSessionID := '';
  FPlayerID := '';
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
  FPlayerID := LoadStringFromStream(Stream);
end;

procedure TClientLoginResponseMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FDeviceID, Stream);
  SaveStringToStream(FSessionID, Stream);
  SaveStringToStream(FPlayerID, Stream);
end;

procedure TClientLoginResponseMessage.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TClientLoginResponseMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TClientLoginResponseMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

{$ENDREGION}

{$REGION 'TClientRegisterDeprecatedMessage' }

constructor TClientRegisterDeprecatedMessage.Create;
begin
  inherited;
  MessageID := 1;
  FDeviceID := '';
  FVersionAPI := 0;
end;

function TClientRegisterDeprecatedMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TClientRegisterDeprecatedMessage.Create;
end;

procedure TClientRegisterDeprecatedMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FDeviceID := LoadStringFromStream(Stream);
  if (Stream.read(FVersionAPI, sizeof(FVersionAPI)) <> sizeof(FVersionAPI)) then
    raise exception.Create('Can''t load "VersionAPI" value.');
end;

procedure TClientRegisterDeprecatedMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FDeviceID, Stream);
  Stream.Write(FVersionAPI, sizeof(FVersionAPI));
end;

procedure TClientRegisterDeprecatedMessage.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TClientRegisterDeprecatedMessage.SetVersionAPI(const Value: integer);
begin
  FVersionAPI := Value;
end;

{$ENDREGION}

{$REGION 'TClientRegisterMessage' }

constructor TClientRegisterMessage.Create;
begin
  inherited;
  MessageID := 20;
  FVersionAPI := 0;
  FDeviceID := '';
  FServerAuthKey := '';
end;

function TClientRegisterMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TClientRegisterMessage.Create;
end;

procedure TClientRegisterMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FVersionAPI, sizeof(FVersionAPI)) <> sizeof(FVersionAPI)) then
    raise exception.Create('Can''t load "VersionAPI" value.');
  FDeviceID := LoadStringFromStream(Stream);
  FServerAuthKey := LoadStringFromStream(Stream);
end;

procedure TClientRegisterMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FVersionAPI, sizeof(FVersionAPI));
  SaveStringToStream(FDeviceID, Stream);
  SaveStringToStream(FServerAuthKey, Stream);
end;

procedure TClientRegisterMessage.SetVersionAPI(const Value: integer);
begin
  FVersionAPI := Value;
end;

procedure TClientRegisterMessage.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TClientRegisterMessage.SetServerAuthKey(const Value: string);
begin
  FServerAuthKey := Value;
end;

{$ENDREGION}

{$REGION 'TClientRegisterResponseMessage' }

constructor TClientRegisterResponseMessage.Create;
begin
  inherited;
  MessageID := 2;
  FDeviceID := '';
  FPlayerID := '';
  FDeviceAuthKey := '';
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
  FDeviceAuthKey := LoadStringFromStream(Stream);
end;

procedure TClientRegisterResponseMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FDeviceID, Stream);
  SaveStringToStream(FPlayerID, Stream);
  SaveStringToStream(FDeviceAuthKey, Stream);
end;

procedure TClientRegisterResponseMessage.SetDeviceID(const Value: string);
begin
  FDeviceID := Value;
end;

procedure TClientRegisterResponseMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TClientRegisterResponseMessage.SetDeviceAuthKey(const Value: string);
begin
  FDeviceAuthKey := Value;
end;

{$ENDREGION}

{$REGION 'TCoinsChangeMessage' }

constructor TCoinsChangeMessage.Create;
begin
  inherited;
  MessageID := 16;
  FCoinsCount := 0;
end;

function TCoinsChangeMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TCoinsChangeMessage.Create;
end;

procedure TCoinsChangeMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FCoinsCount, sizeof(FCoinsCount)) <> sizeof(FCoinsCount)) then
    raise exception.Create('Can''t load "CoinsCount" value.');
end;

procedure TCoinsChangeMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FCoinsCount, sizeof(FCoinsCount));
end;

procedure TCoinsChangeMessage.SetCoinsCount(const Value: TSporglooAPINumber);
begin
  FCoinsCount := Value;
end;

{$ENDREGION}

{$REGION 'TCurrentPlayerKilledMessage' }

constructor TCurrentPlayerKilledMessage.Create;
begin
  inherited;
  MessageID := 25;
end;

function TCurrentPlayerKilledMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TCurrentPlayerKilledMessage.Create;
end;

procedure TCurrentPlayerKilledMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
end;

procedure TCurrentPlayerKilledMessage.SaveToStream(Stream: TStream);
begin
  inherited;
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

{$REGION 'TGetHallOfFameScoresMessage' }

constructor TGetHallOfFameScoresMessage.Create;
begin
  inherited;
  MessageID := 22;
  FSessionID := '';
  FPageNumber := 0;
end;

function TGetHallOfFameScoresMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TGetHallOfFameScoresMessage.Create;
end;

procedure TGetHallOfFameScoresMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FSessionID := LoadStringFromStream(Stream);
  if (Stream.read(FPageNumber, sizeof(FPageNumber)) <> sizeof(FPageNumber)) then
    raise exception.Create('Can''t load "PageNumber" value.');
end;

procedure TGetHallOfFameScoresMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FSessionID, Stream);
  Stream.Write(FPageNumber, sizeof(FPageNumber));
end;

procedure TGetHallOfFameScoresMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TGetHallOfFameScoresMessage.SetPageNumber(const Value: integer);
begin
  FPageNumber := Value;
end;

{$ENDREGION}

{$REGION 'THallOfFameMessage' }

constructor THallOfFameMessage.Create;
begin
  inherited;
  MessageID := 23;
end;

function THallOfFameMessage.GetNewInstance: TOlfSMMessage;
begin
  result := THallOfFameMessage.Create;
end;

procedure THallOfFameMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
end;

procedure THallOfFameMessage.SaveToStream(Stream: TStream);
begin
  inherited;
end;

{$ENDREGION}

{$REGION 'TKillCurrentPlayerMessage' }

constructor TKillCurrentPlayerMessage.Create;
begin
  inherited;
  MessageID := 24;
  FSessionID := '';
  FPlayerID := '';
end;

function TKillCurrentPlayerMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TKillCurrentPlayerMessage.Create;
end;

procedure TKillCurrentPlayerMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FSessionID := LoadStringFromStream(Stream);
  FPlayerID := LoadStringFromStream(Stream);
end;

procedure TKillCurrentPlayerMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FSessionID, Stream);
  SaveStringToStream(FPlayerID, Stream);
end;

procedure TKillCurrentPlayerMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TKillCurrentPlayerMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

{$ENDREGION}

{$REGION 'TLivesCountChangeMessage' }

constructor TLivesCountChangeMessage.Create;
begin
  inherited;
  MessageID := 15;
  FLivesCount := 0;
end;

function TLivesCountChangeMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TLivesCountChangeMessage.Create;
end;

procedure TLivesCountChangeMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FLivesCount, sizeof(FLivesCount)) <> sizeof(FLivesCount)) then
    raise exception.Create('Can''t load "LivesCount" value.');
end;

procedure TLivesCountChangeMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FLivesCount, sizeof(FLivesCount));
end;

procedure TLivesCountChangeMessage.SetLivesCount(const Value: TSporglooAPINumber);
begin
  FLivesCount := Value;
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

{$REGION 'TMapCellInfoMessage' }

constructor TMapCellInfoMessage.Create;
begin
  inherited;
  MessageID := 6;
  FX := 0;
  FY := 0;
  FTileID := 0;
  FPlayerID := '';
  FImageID := 0;
  FStarsCount := 0;
  FLivesCount := 0;
  FCoinsCount := 0;
end;

function TMapCellInfoMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TMapCellInfoMessage.Create;
end;

procedure TMapCellInfoMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
  if (Stream.read(FTileID, sizeof(FTileID)) <> sizeof(FTileID)) then
    raise exception.Create('Can''t load "TileID" value.');
  FPlayerID := LoadStringFromStream(Stream);
  if (Stream.read(FImageID, sizeof(FImageID)) <> sizeof(FImageID)) then
    raise exception.Create('Can''t load "ImageID" value.');
  if (Stream.read(FStarsCount, sizeof(FStarsCount)) <> sizeof(FStarsCount)) then
    raise exception.Create('Can''t load "StarsCount" value.');
  if (Stream.read(FLivesCount, sizeof(FLivesCount)) <> sizeof(FLivesCount)) then
    raise exception.Create('Can''t load "LivesCount" value.');
  if (Stream.read(FCoinsCount, sizeof(FCoinsCount)) <> sizeof(FCoinsCount)) then
    raise exception.Create('Can''t load "CoinsCount" value.');
end;

procedure TMapCellInfoMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
  Stream.Write(FTileID, sizeof(FTileID));
  SaveStringToStream(FPlayerID, Stream);
  Stream.Write(FImageID, sizeof(FImageID));
  Stream.Write(FStarsCount, sizeof(FStarsCount));
  Stream.Write(FLivesCount, sizeof(FLivesCount));
  Stream.Write(FCoinsCount, sizeof(FCoinsCount));
end;

procedure TMapCellInfoMessage.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TMapCellInfoMessage.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

procedure TMapCellInfoMessage.SetTileID(const Value: TSporglooAPIShort);
begin
  FTileID := Value;
end;

procedure TMapCellInfoMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TMapCellInfoMessage.SetImageID(const Value: integer);
begin
  FImageID := Value;
end;

procedure TMapCellInfoMessage.SetStarsCount(const Value: TSporglooAPINumber);
begin
  FStarsCount := Value;
end;

procedure TMapCellInfoMessage.SetLivesCount(const Value: TSporglooAPINumber);
begin
  FLivesCount := Value;
end;

procedure TMapCellInfoMessage.SetCoinsCount(const Value: TSporglooAPINumber);
begin
  FCoinsCount := Value;
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

{$REGION 'TPlayerImageChangedMessage' }

constructor TPlayerImageChangedMessage.Create;
begin
  inherited;
  MessageID := 19;
  FSessionID := '';
  FImageID := 0;
end;

function TPlayerImageChangedMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TPlayerImageChangedMessage.Create;
end;

procedure TPlayerImageChangedMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FSessionID := LoadStringFromStream(Stream);
  if (Stream.read(FImageID, sizeof(FImageID)) <> sizeof(FImageID)) then
    raise exception.Create('Can''t load "ImageID" value.');
end;

procedure TPlayerImageChangedMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FSessionID, Stream);
  Stream.Write(FImageID, sizeof(FImageID));
end;

procedure TPlayerImageChangedMessage.SetSessionID(const Value: string);
begin
  FSessionID := Value;
end;

procedure TPlayerImageChangedMessage.SetImageID(const Value: integer);
begin
  FImageID := Value;
end;

{$ENDREGION}

{$REGION 'TPlayerInfosMessage' }

constructor TPlayerInfosMessage.Create;
begin
  inherited;
  MessageID := 17;
  FPlayerID := '';
  FX := 0;
  FY := 0;
  FImageID := 0;
  FCoinsCount := 0;
  FStarsCount := 0;
  FLivesCount := 0;
end;

function TPlayerInfosMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TPlayerInfosMessage.Create;
end;

procedure TPlayerInfosMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  FPlayerID := LoadStringFromStream(Stream);
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
  if (Stream.read(FImageID, sizeof(FImageID)) <> sizeof(FImageID)) then
    raise exception.Create('Can''t load "ImageID" value.');
  if (Stream.read(FCoinsCount, sizeof(FCoinsCount)) <> sizeof(FCoinsCount)) then
    raise exception.Create('Can''t load "CoinsCount" value.');
  if (Stream.read(FStarsCount, sizeof(FStarsCount)) <> sizeof(FStarsCount)) then
    raise exception.Create('Can''t load "StarsCount" value.');
  if (Stream.read(FLivesCount, sizeof(FLivesCount)) <> sizeof(FLivesCount)) then
    raise exception.Create('Can''t load "LivesCount" value.');
end;

procedure TPlayerInfosMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  SaveStringToStream(FPlayerID, Stream);
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
  Stream.Write(FImageID, sizeof(FImageID));
  Stream.Write(FCoinsCount, sizeof(FCoinsCount));
  Stream.Write(FStarsCount, sizeof(FStarsCount));
  Stream.Write(FLivesCount, sizeof(FLivesCount));
end;

procedure TPlayerInfosMessage.SetPlayerID(const Value: string);
begin
  FPlayerID := Value;
end;

procedure TPlayerInfosMessage.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TPlayerInfosMessage.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

procedure TPlayerInfosMessage.SetImageID(const Value: integer);
begin
  FImageID := Value;
end;

procedure TPlayerInfosMessage.SetCoinsCount(const Value: TSporglooAPINumber);
begin
  FCoinsCount := Value;
end;

procedure TPlayerInfosMessage.SetStarsCount(const Value: TSporglooAPINumber);
begin
  FStarsCount := Value;
end;

procedure TPlayerInfosMessage.SetLivesCount(const Value: TSporglooAPINumber);
begin
  FLivesCount := Value;
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

{$REGION 'TStarsCountChangeMessage' }

constructor TStarsCountChangeMessage.Create;
begin
  inherited;
  MessageID := 14;
  FStarsCount := 0;
end;

function TStarsCountChangeMessage.GetNewInstance: TOlfSMMessage;
begin
  result := TStarsCountChangeMessage.Create;
end;

procedure TStarsCountChangeMessage.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FStarsCount, sizeof(FStarsCount)) <> sizeof(FStarsCount)) then
    raise exception.Create('Can''t load "StarsCount" value.');
end;

procedure TStarsCountChangeMessage.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FStarsCount, sizeof(FStarsCount));
end;

procedure TStarsCountChangeMessage.SetStarsCount(const Value: TSporglooAPINumber);
begin
  FStarsCount := Value;
end;

{$ENDREGION}

end.
