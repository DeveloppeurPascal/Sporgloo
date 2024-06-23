unit Sporgloo.Consts;

interface

const
  CAPIVersion = 20240623;

  CDefaultServerPort = 8080;

  CSporglooTileForest = 0;
  CSporglooTilePath = 1;
  CSporglooTileStar = 2;

  CSporglooTileSize = 64;

  /// <summary>
  /// Marge used to get the all map from the server (as a viewport left/right margin)
  /// </summary>
{$IFDEF DEBUG}
  CColMargins = 1;
{$ELSE}
  CColMargins = 3;
{$ENDIF}
  /// <summary>
  /// Marge used to get the all map from the server (as a viewport top/bottom margin)
  /// </summary>
{$IFDEF DEBUG}
  CRowMargins = 1;
{$ELSE}
  CRowMargins = 3;
{$ENDIF}
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
    WrongDeviceOrPlayerForSessionID = 8, PlayerMoveDenied = 9, WrongToken = 10);

implementation

end.
