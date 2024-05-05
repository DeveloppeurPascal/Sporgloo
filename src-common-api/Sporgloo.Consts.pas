unit Sporgloo.Consts;

interface

const
  CAPIVersion = 20240501;

  CSporglooTileNone = 0;
  CSporglooTilePath = 1;
  CSporglooTileStar = 2;

  CSporglooTileSize = 64;

  /// <summary>
  ///   Marge used to get the all map from the server (as a viewport left/right margin)
  /// </summary>
  CColMargins = 10;
  /// <summary>
  ///   Marge used to get the all map from the server (as a viewport top/bottom margin)
  /// </summary>
  CRowMargins = 10;

  CSporglooIDSize = 16;

  CStartStarsCount = 12;
  CStartLifeLevel = 24;
{$IFDEF DEBUG}
  CStartDistanceFromLastPlayer = 10;
{$ELSE}
  CStartDistanceFromLastPlayer = 50;
{$ENDIF}

type
{$SCOPEDENUMS ON}
  TSporglooErrorCode = (NoError = 0, WrongDeviceID = 1, WrongPlayerID = 2,
    WrongSessionID = 3, WrongAPIVersion = 4, UnknowPlayerID = 5,
    WrongDeviceForPlayerID = 6, UnknowSessionID = 7,
    WrongDeviceOrPlayerForSessionID = 8);

implementation

end.
