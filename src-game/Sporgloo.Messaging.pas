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
  TMapCellUpdateMessage = class(TObjectMessage<TSporglooMapCell>)
  end;

  /// <summary>
  /// Used to force the redraw of the map on screen
  /// </summary>
  TMapUpdateMessage = class(TMessage)
  end;

  /// <summary>
  /// Sent by the client/server API when an other player moved.
  /// </summary>
  TOtherPlayerUpdateMessage = class(TObjectMessage<TSporglooPlayer>)
  end;

  /// <summary>
  /// Sent from the client or the server to close the loop and the connection
  /// </summary>
  TDisconnectMessage = class(TMessage)
  end;

implementation

end.
