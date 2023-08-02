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
// File generator : Socket Message Generator (v1.0)
// Website : https://socketmessaging.developpeur-pascal.fr/
// Generation date : 02/08/2023 17:03:03
//
// Don't do any change on this file. They will be erased by next generation !
// ****************************************

interface

uses
  System.Classes,
  Olf.Net.Socket.Messaging,
  Sporgloo.Types;

type
  /// <summary>
  /// Client login message
  /// </summary>
  TClient_login_message = class(TOlfSocketMessage)
  private
    FDeviceID: TSporglooAPIAlpha16;
    FPlayerID: TSporglooAPIAlpha16;
    procedure SetDeviceID(const Value: TSporglooAPIAlpha16);
    procedure SetPlayerID(const Value: TSporglooAPIAlpha16);
  public
    /// <summary>
    /// Device unique identifier
    /// </summary>
    property DeviceID: TSporglooAPIAlpha16 read FDeviceID write SetDeviceID;
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: TSporglooAPIAlpha16 read FPlayerID write SetPlayerID;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSocketMessage; override;
  end;

  /// <summary>
  /// Client login response message
  /// </summary>
  TClient_login_response_message = class(TOlfSocketMessage)
  private
    FDeviceID: TSporglooAPIAlpha16;
    FSessionID: TSporglooAPIAlpha16;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    FScore: TSporglooAPINumber;
    FStars: TSporglooAPINumber;
    FLife: TSporglooAPINumber;
    procedure SetDeviceID(const Value: TSporglooAPIAlpha16);
    procedure SetSessionID(const Value: TSporglooAPIAlpha16);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
    procedure SetScore(const Value: TSporglooAPINumber);
    procedure SetStars(const Value: TSporglooAPINumber);
    procedure SetLife(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Device unique identifier
    /// </summary>
    property DeviceID: TSporglooAPIAlpha16 read FDeviceID write SetDeviceID;
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: TSporglooAPIAlpha16 read FSessionID write SetSessionID;
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
    function GetNewInstance: TOlfSocketMessage; override;
  end;

  /// <summary>
  /// Client register message
  /// </summary>
  TClient_register_message = class(TOlfSocketMessage)
  private
    FDeviceID: TSporglooAPIAlpha16;
    procedure SetDeviceID(const Value: TSporglooAPIAlpha16);
  public
    /// <summary>
    /// Device unique identifier
    /// </summary>
    property DeviceID: TSporglooAPIAlpha16 read FDeviceID write SetDeviceID;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSocketMessage; override;
  end;

  /// <summary>
  /// Client register response message
  /// </summary>
  TClient_register_response_message = class(TOlfSocketMessage)
  private
    FDeviceID: TSporglooAPIAlpha16;
    FPlayerID: TSporglooAPIAlpha16;
    procedure SetDeviceID(const Value: TSporglooAPIAlpha16);
    procedure SetPlayerID(const Value: TSporglooAPIAlpha16);
  public
    /// <summary>
    /// Device unique identifier
    /// </summary>
    property DeviceID: TSporglooAPIAlpha16 read FDeviceID write SetDeviceID;
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: TSporglooAPIAlpha16 read FPlayerID write SetPlayerID;
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSocketMessage; override;
  end;

  /// <summary>
  /// Map cell message
  /// </summary>
  TMap_cell_message = class(TOlfSocketMessage)
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
    function GetNewInstance: TOlfSocketMessage; override;
  end;

  /// <summary>
  /// Map refresh demand message
  /// </summary>
  TMap_refresh_demand_message = class(TOlfSocketMessage)
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
    function GetNewInstance: TOlfSocketMessage; override;
  end;

  /// <summary>
  /// Other player move message
  /// </summary>
  TOther_player_move_message = class(TOlfSocketMessage)
  private
    FPlayerID: TSporglooAPIAlpha16;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    procedure SetPlayerID(const Value: TSporglooAPIAlpha16);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: TSporglooAPIAlpha16 read FPlayerID write SetPlayerID;
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
    function GetNewInstance: TOlfSocketMessage; override;
  end;

  /// <summary>
  /// Player add a star on the map message
  /// </summary>
  TPlayer_add_a_star_on_the_map_message = class(TOlfSocketMessage)
  private
    FSessionID: TSporglooAPIAlpha16;
    FPlayerID: TSporglooAPIAlpha16;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    procedure SetSessionID(const Value: TSporglooAPIAlpha16);
    procedure SetPlayerID(const Value: TSporglooAPIAlpha16);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: TSporglooAPIAlpha16 read FSessionID write SetSessionID;
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: TSporglooAPIAlpha16 read FPlayerID write SetPlayerID;
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
    function GetNewInstance: TOlfSocketMessage; override;
  end;

  /// <summary>
  /// Player move message
  /// </summary>
  TPlayer_move_message = class(TOlfSocketMessage)
  private
    FSessionID: TSporglooAPIAlpha16;
    FPlayerID: TSporglooAPIAlpha16;
    FX: TSporglooAPINumber;
    FY: TSporglooAPINumber;
    procedure SetSessionID(const Value: TSporglooAPIAlpha16);
    procedure SetPlayerID(const Value: TSporglooAPIAlpha16);
    procedure SetX(const Value: TSporglooAPINumber);
    procedure SetY(const Value: TSporglooAPINumber);
  public
    /// <summary>
    /// Session unique identifier
    /// </summary>
    property SessionID: TSporglooAPIAlpha16 read FSessionID write SetSessionID;
    /// <summary>
    /// Player unique identifier
    /// </summary>
    property PlayerID: TSporglooAPIAlpha16 read FPlayerID write SetPlayerID;
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
    function GetNewInstance: TOlfSocketMessage; override;
  end;

  /// <summary>
  /// Player move response
  /// </summary>
  TPlayer_move_response = class(TOlfSocketMessage)
  private
  public
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    function GetNewInstance: TOlfSocketMessage; override;
  end;

  /// <summary>
  /// Server accept the star adding message
  /// </summary>
  TServer_accept_the_star_adding_message = class(TOlfSocketMessage)
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
    function GetNewInstance: TOlfSocketMessage; override;
  end;

procedure RegisterMessagesReceivedByTheServer(Const Server
  : TOlfSocketMessagingServer);
procedure RegisterMessagesReceivedByTheClient(Const Client
  : TOlfSocketMessagingClient);

implementation

uses
  System.SysUtils;

procedure RegisterMessagesReceivedByTheServer(Const Server
  : TOlfSocketMessagingServer);
begin
  Server.RegisterMessageToReceive(TClient_login_message.Create);
  Server.RegisterMessageToReceive(TClient_register_message.Create);
  Server.RegisterMessageToReceive(TMap_refresh_demand_message.Create);
  Server.RegisterMessageToReceive(TPlayer_add_a_star_on_the_map_message.Create);
  Server.RegisterMessageToReceive(TPlayer_move_message.Create);
end;

procedure RegisterMessagesReceivedByTheClient(Const Client
  : TOlfSocketMessagingClient);
begin
  Client.RegisterMessageToReceive(TClient_login_response_message.Create);
  Client.RegisterMessageToReceive(TClient_register_response_message.Create);
  Client.RegisterMessageToReceive(TMap_cell_message.Create);
  Client.RegisterMessageToReceive(TOther_player_move_message.Create);
  Client.RegisterMessageToReceive(TPlayer_move_response.Create);
  Client.RegisterMessageToReceive(TServer_accept_the_star_adding_message.Create);
end;

{ TClient_login_message }

constructor TClient_login_message.Create;
begin
  inherited;
  MessageID := 3;
end;

function TClient_login_message.GetNewInstance: TOlfSocketMessage;
begin
  result := TClient_login_message.Create;
end;

procedure TClient_login_message.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FDeviceID, sizeof(FDeviceID)) <> sizeof(FDeviceID)) then
    raise exception.Create('Can''t load "DeviceID" value.');
  if (Stream.read(FPlayerID, sizeof(FPlayerID)) <> sizeof(FPlayerID)) then
    raise exception.Create('Can''t load "PlayerID" value.');
end;

procedure TClient_login_message.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FDeviceID, sizeof(FDeviceID));
  Stream.Write(FPlayerID, sizeof(FPlayerID));
end;

procedure TClient_login_message.SetDeviceID(const Value: TSporglooAPIAlpha16);
begin
  FDeviceID := Value;
end;

procedure TClient_login_message.SetPlayerID(const Value: TSporglooAPIAlpha16);
begin
  FPlayerID := Value;
end;

{ TClient_login_response_message }

constructor TClient_login_response_message.Create;
begin
  inherited;
  MessageID := 4;
  FX := 0;
  FY := 0;
  FScore := 0;
  FStars := 0;
  FLife := 0;
end;

function TClient_login_response_message.GetNewInstance: TOlfSocketMessage;
begin
  result := TClient_login_response_message.Create;
end;

procedure TClient_login_response_message.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FDeviceID, sizeof(FDeviceID)) <> sizeof(FDeviceID)) then
    raise exception.Create('Can''t load "DeviceID" value.');
  if (Stream.read(FSessionID, sizeof(FSessionID)) <> sizeof(FSessionID)) then
    raise exception.Create('Can''t load "SessionID" value.');
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

procedure TClient_login_response_message.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FDeviceID, sizeof(FDeviceID));
  Stream.Write(FSessionID, sizeof(FSessionID));
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
  Stream.Write(FScore, sizeof(FScore));
  Stream.Write(FStars, sizeof(FStars));
  Stream.Write(FLife, sizeof(FLife));
end;

procedure TClient_login_response_message.SetDeviceID(const Value: TSporglooAPIAlpha16);
begin
  FDeviceID := Value;
end;

procedure TClient_login_response_message.SetSessionID(const Value: TSporglooAPIAlpha16);
begin
  FSessionID := Value;
end;

procedure TClient_login_response_message.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TClient_login_response_message.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

procedure TClient_login_response_message.SetScore(const Value: TSporglooAPINumber);
begin
  FScore := Value;
end;

procedure TClient_login_response_message.SetStars(const Value: TSporglooAPINumber);
begin
  FStars := Value;
end;

procedure TClient_login_response_message.SetLife(const Value: TSporglooAPINumber);
begin
  FLife := Value;
end;

{ TClient_register_message }

constructor TClient_register_message.Create;
begin
  inherited;
  MessageID := 1;
end;

function TClient_register_message.GetNewInstance: TOlfSocketMessage;
begin
  result := TClient_register_message.Create;
end;

procedure TClient_register_message.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FDeviceID, sizeof(FDeviceID)) <> sizeof(FDeviceID)) then
    raise exception.Create('Can''t load "DeviceID" value.');
end;

procedure TClient_register_message.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FDeviceID, sizeof(FDeviceID));
end;

procedure TClient_register_message.SetDeviceID(const Value: TSporglooAPIAlpha16);
begin
  FDeviceID := Value;
end;

{ TClient_register_response_message }

constructor TClient_register_response_message.Create;
begin
  inherited;
  MessageID := 2;
end;

function TClient_register_response_message.GetNewInstance: TOlfSocketMessage;
begin
  result := TClient_register_response_message.Create;
end;

procedure TClient_register_response_message.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FDeviceID, sizeof(FDeviceID)) <> sizeof(FDeviceID)) then
    raise exception.Create('Can''t load "DeviceID" value.');
  if (Stream.read(FPlayerID, sizeof(FPlayerID)) <> sizeof(FPlayerID)) then
    raise exception.Create('Can''t load "PlayerID" value.');
end;

procedure TClient_register_response_message.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FDeviceID, sizeof(FDeviceID));
  Stream.Write(FPlayerID, sizeof(FPlayerID));
end;

procedure TClient_register_response_message.SetDeviceID(const Value: TSporglooAPIAlpha16);
begin
  FDeviceID := Value;
end;

procedure TClient_register_response_message.SetPlayerID(const Value: TSporglooAPIAlpha16);
begin
  FPlayerID := Value;
end;

{ TMap_cell_message }

constructor TMap_cell_message.Create;
begin
  inherited;
  MessageID := 6;
  FX := 0;
  FY := 0;
  FTileID := 0;
end;

function TMap_cell_message.GetNewInstance: TOlfSocketMessage;
begin
  result := TMap_cell_message.Create;
end;

procedure TMap_cell_message.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
  if (Stream.read(FTileID, sizeof(FTileID)) <> sizeof(FTileID)) then
    raise exception.Create('Can''t load "TileID" value.');
end;

procedure TMap_cell_message.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
  Stream.Write(FTileID, sizeof(FTileID));
end;

procedure TMap_cell_message.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TMap_cell_message.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

procedure TMap_cell_message.SetTileID(const Value: TSporglooAPIShort);
begin
  FTileID := Value;
end;

{ TMap_refresh_demand_message }

constructor TMap_refresh_demand_message.Create;
begin
  inherited;
  MessageID := 5;
  FX := 0;
  FY := 0;
  FColNumber := 0;
  FRowNumber := 0;
end;

function TMap_refresh_demand_message.GetNewInstance: TOlfSocketMessage;
begin
  result := TMap_refresh_demand_message.Create;
end;

procedure TMap_refresh_demand_message.LoadFromStream(Stream: TStream);
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

procedure TMap_refresh_demand_message.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
  Stream.Write(FColNumber, sizeof(FColNumber));
  Stream.Write(FRowNumber, sizeof(FRowNumber));
end;

procedure TMap_refresh_demand_message.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TMap_refresh_demand_message.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

procedure TMap_refresh_demand_message.SetColNumber(const Value: TSporglooAPINumber);
begin
  FColNumber := Value;
end;

procedure TMap_refresh_demand_message.SetRowNumber(const Value: TSporglooAPINumber);
begin
  FRowNumber := Value;
end;

{ TOther_player_move_message }

constructor TOther_player_move_message.Create;
begin
  inherited;
  MessageID := 11;
  FX := 0;
  FY := 0;
end;

function TOther_player_move_message.GetNewInstance: TOlfSocketMessage;
begin
  result := TOther_player_move_message.Create;
end;

procedure TOther_player_move_message.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FPlayerID, sizeof(FPlayerID)) <> sizeof(FPlayerID)) then
    raise exception.Create('Can''t load "PlayerID" value.');
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
end;

procedure TOther_player_move_message.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FPlayerID, sizeof(FPlayerID));
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
end;

procedure TOther_player_move_message.SetPlayerID(const Value: TSporglooAPIAlpha16);
begin
  FPlayerID := Value;
end;

procedure TOther_player_move_message.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TOther_player_move_message.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

{ TPlayer_add_a_star_on_the_map_message }

constructor TPlayer_add_a_star_on_the_map_message.Create;
begin
  inherited;
  MessageID := 9;
  FX := 0;
  FY := 0;
end;

function TPlayer_add_a_star_on_the_map_message.GetNewInstance: TOlfSocketMessage;
begin
  result := TPlayer_add_a_star_on_the_map_message.Create;
end;

procedure TPlayer_add_a_star_on_the_map_message.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FSessionID, sizeof(FSessionID)) <> sizeof(FSessionID)) then
    raise exception.Create('Can''t load "SessionID" value.');
  if (Stream.read(FPlayerID, sizeof(FPlayerID)) <> sizeof(FPlayerID)) then
    raise exception.Create('Can''t load "PlayerID" value.');
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
end;

procedure TPlayer_add_a_star_on_the_map_message.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FSessionID, sizeof(FSessionID));
  Stream.Write(FPlayerID, sizeof(FPlayerID));
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
end;

procedure TPlayer_add_a_star_on_the_map_message.SetSessionID(const Value: TSporglooAPIAlpha16);
begin
  FSessionID := Value;
end;

procedure TPlayer_add_a_star_on_the_map_message.SetPlayerID(const Value: TSporglooAPIAlpha16);
begin
  FPlayerID := Value;
end;

procedure TPlayer_add_a_star_on_the_map_message.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TPlayer_add_a_star_on_the_map_message.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

{ TPlayer_move_message }

constructor TPlayer_move_message.Create;
begin
  inherited;
  MessageID := 7;
  FX := 0;
  FY := 0;
end;

function TPlayer_move_message.GetNewInstance: TOlfSocketMessage;
begin
  result := TPlayer_move_message.Create;
end;

procedure TPlayer_move_message.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FSessionID, sizeof(FSessionID)) <> sizeof(FSessionID)) then
    raise exception.Create('Can''t load "SessionID" value.');
  if (Stream.read(FPlayerID, sizeof(FPlayerID)) <> sizeof(FPlayerID)) then
    raise exception.Create('Can''t load "PlayerID" value.');
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
end;

procedure TPlayer_move_message.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FSessionID, sizeof(FSessionID));
  Stream.Write(FPlayerID, sizeof(FPlayerID));
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
end;

procedure TPlayer_move_message.SetSessionID(const Value: TSporglooAPIAlpha16);
begin
  FSessionID := Value;
end;

procedure TPlayer_move_message.SetPlayerID(const Value: TSporglooAPIAlpha16);
begin
  FPlayerID := Value;
end;

procedure TPlayer_move_message.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TPlayer_move_message.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

{ TPlayer_move_response }

constructor TPlayer_move_response.Create;
begin
  inherited;
  MessageID := 8;
end;

function TPlayer_move_response.GetNewInstance: TOlfSocketMessage;
begin
  result := TPlayer_move_response.Create;
end;

procedure TPlayer_move_response.LoadFromStream(Stream: TStream);
begin
  inherited;
end;

procedure TPlayer_move_response.SaveToStream(Stream: TStream);
begin
  inherited;
end;

{ TServer_accept_the_star_adding_message }

constructor TServer_accept_the_star_adding_message.Create;
begin
  inherited;
  MessageID := 10;
  FX := 0;
  FY := 0;
end;

function TServer_accept_the_star_adding_message.GetNewInstance: TOlfSocketMessage;
begin
  result := TServer_accept_the_star_adding_message.Create;
end;

procedure TServer_accept_the_star_adding_message.LoadFromStream(Stream: TStream);
begin
  inherited;
  if (Stream.read(FX, sizeof(FX)) <> sizeof(FX)) then
    raise exception.Create('Can''t load "X" value.');
  if (Stream.read(FY, sizeof(FY)) <> sizeof(FY)) then
    raise exception.Create('Can''t load "Y" value.');
end;

procedure TServer_accept_the_star_adding_message.SaveToStream(Stream: TStream);
begin
  inherited;
  Stream.Write(FX, sizeof(FX));
  Stream.Write(FY, sizeof(FY));
end;

procedure TServer_accept_the_star_adding_message.SetX(const Value: TSporglooAPINumber);
begin
  FX := Value;
end;

procedure TServer_accept_the_star_adding_message.SetY(const Value: TSporglooAPINumber);
begin
  FY := Value;
end;

end.
