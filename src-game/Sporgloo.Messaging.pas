unit Sporgloo.Messaging;

interface

uses
  System.Messaging,
  uClientSocket,
  Sporgloo.Types;

type
  /// <summary>
  /// Sent when the client is connected to a server
  /// </summary>
  TServerConnectedMessage = class(TMessage<TSporglooAPIClient>)
  end;

  /// <summary>
  /// Connection to the server has been lost
  /// </summary>
  TLostServerMessage = class(TMessage<TSporglooAPIClient>)
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

implementation

initialization

finalization

end.
