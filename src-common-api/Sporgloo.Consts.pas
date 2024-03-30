unit Sporgloo.Consts;

interface

const
  CAPIVersion = 20240330;

  CSporglooTileNone = 0;
  CSporglooTilePath = 1;
  CSporglooTileStar = 2;

  CSporglooTileSize = 64;

  CSporglooIDSize = 16;

type
{$SCOPEDENUMS ON}
  TSporglooErrorCode = (NoError = 0, WrongDeviceID = 1, WrongPlayerID = 2,
    WrongSessionID = 3, WrongAPIVersion = 4, UnknowPlayerID = 5,
    WrongDeviceForPlayerID = 6, UnknowSessionID = 7,
    WrongDeviceOrPlayerForSessionID = 8, WrongMessageReceived = 9);

implementation

end.
