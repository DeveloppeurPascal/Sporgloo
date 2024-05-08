unit Sporgloo.Messaging;

interface

uses
  System.Messaging,
  Sporgloo.Types,
  Sporgloo.Client,
  Sporgloo.Database;

type
  /// <summary>
  /// Sent when the client is connected to a server
  /// </summary>
  TServerConnectedMessage = class(TMessage<TSporglooClient>)
  end;

  /// <summary>
  /// Connection to the server has been lost
  /// </summary>
  TLostServerMessage = class(TMessage<TSporglooClient>)
  end;

  /// <summary>
  /// This message is sent by the client/server API to send
  /// the new TileID to the subscribers
  /// </summary>
  TMapCellUpdateMessage = class(TMessage<TSporglooMapCell>)
  end;

  /// <summary>
  /// Used to force the redraw of the map on screen
  /// </summary>
  TMapUpdateMessage = class(TMessage)
  end;

  /// <summary>
  /// Sent from the client or the server to close the loop and the connection
  /// </summary>
  TDisconnectMessage = class(TMessage)
  end;

  /// <summary>
  /// Sent when the server deny a player move.
  /// </summary>
  TPlayerMoveDeniedByTheServerMessage = class(TMessage)
  end;

  /// <summary>
  /// Sent when the score is changed. The UI must refresh score panel with the new value.
  /// </summary>
  TPlayerScoreUpdatedMessage = class(TMessage<TSporglooAPINumber>)
  end;

  /// <summary>
  /// Sent when the stars count is changed. The UI must refresh stars count panel with the new value.
  /// </summary>
  TPlayerStarsCountUpdatedMessage = class(TMessage<TSporglooAPINumber>)
  end;

  /// <summary>
  /// Sent when the life level is changed. The UI must refresh life level panel with the new value.
  /// </summary>
  TPlayerLifeLevelUpdatedMessage = class(TMessage<TSporglooAPINumber>)
  end;

implementation

end.
