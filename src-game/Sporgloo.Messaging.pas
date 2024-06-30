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
  /// Sent when the coins count is changed. The UI must refresh score panel with the new value.
  /// </summary>
  TPlayerCoinsCountUpdatedMessage = class(TMessage<TSporglooAPINumber>)
  end;

  /// <summary>
  /// Sent when the stars count is changed. The UI must refresh stars count panel with the new value.
  /// </summary>
  TPlayerStarsCountUpdatedMessage = class(TMessage<TSporglooAPINumber>)
  end;

  /// <summary>
  /// Sent when the lives count is changed. The UI must refresh life level panel with the new value.
  /// </summary>
  TPlayerLivesCountUpdatedMessage = class(TMessage<TSporglooAPINumber>)
  end;

  /// <summary>
  /// Sent by the TBackgroundMusic class when the music status change (Play or Pause/Stop)
  /// </summary>
  TBackgroundMusicStatusMessage = class(TMessage<boolean>)
  end;

  /// <summary>
  /// The server answered to the LOGIN message.
  /// </summary>
  TLoginOKMessage = class(TMessage)
  end;

implementation

end.
