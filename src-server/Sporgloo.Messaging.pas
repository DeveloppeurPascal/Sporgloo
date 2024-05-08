unit Sporgloo.Messaging;

interface

/// <summary>
/// This unit is a server side unit for compilation compatibility with common
/// units between the server and the client. Don't use it for an other reason !
/// </summary>

uses
  System.Messaging,
  Sporgloo.Types;

type
  /// <summary>
  /// For COMPILATION reason in the server program, don't use this class !
  /// </summary>
  TPlayerScoreUpdatedMessage = class(TMessage<TSporglooAPINumber>)
  end;

  /// <summary>
  /// For COMPILATION reason in the server program, don't use this class !
  /// </summary>
  TPlayerStarsCountUpdatedMessage = class(TMessage<TSporglooAPINumber>)
  end;

  /// <summary>
  /// For COMPILATION reason in the server program, don't use this class !
  /// </summary>
  TPlayerLifeLevelUpdatedMessage = class(TMessage<TSporglooAPINumber>)
  end;

implementation

end.
