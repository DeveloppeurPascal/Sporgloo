unit Sporgloo.Messaging;

interface

uses
  System.Messaging,
  uClientSocket;

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

implementation

initialization


finalization


end.
