# Sporgloo API

This folder contains the common files for the game and server programs. It's part of Delphi source code for [Sporgloo game](https://sporgloo.gamolf.fr/).

The API of the game is based over TCP sockets on port 8080. (voir 27015 pour Windows au cas où)

## Messages between client and server

Each message starts with MessageID and ends with MessageEnd.

### Client register

client to server

MessageID = 1
Client send : DeviceID

MessageID = 2
Server response : DeviceID+PlayerID

First launch of the game program, it creates a local DevideID from a GUID (or other). This GUID is sent to the server to get a PlayerID.

The server generate a PlayerID from a uniq ID (GUID or other) and store the DeviceID and the PlayerID. It choose the Player coordinates from last move of an other player or in (0,0) coordinates of the map.

The server send a PlayerID to the client.

### Client login

client to server

MessageID = 3
Client send : DevideID+PlayerID

MessageID = 4
Server response : DeviceID+SessionID+PlayerX+PlayerX+Score+StarsCount+LifeLevel

Each time the game program starts, it ask for a SessionID to the server.

The server generate a uniq ID as a SessionID and sent it to the client with last coordinates of the player.
**TODO : add player data (score, life, ...)**

### Map refresh

client to server

MessageID = 5
Client send : MapX+MapY+ColNumber+RowNumber

To draw the map, the game client ask to the server what is available in a part of the map. This part is defined by the screen size and current player position.

This message is sent for a row or a column when the player position change.

The server answers with "map cell" messages for each cell in this range.

For security reasons (DDoS attacks and other things), the colNumber and RowNumber are limited.

### Map cell

server to client

MessageID = 6
Server send : MapX+MapY+MapTileID

The server send the ID of current tile in position (MapX,MapY) of the map.

### Player move

client to server

MessageID = 7
Client send : SessionID+PlayerID+PlayerX+PlayerY

MessageID = 8
Server send : nothing

When the player moves, the client send the new position to the server.
The server send an ACK message (#8) as response.

If the client don't reveice an ACK message during 1 second, the new position is sent again. An ACK message validate all previous player position messages sent.

The server send a "other player move" message to other connected games.

### Player put a star

client to server

MessageID = 9
Client send : SessionID+PlayerID+NewStarX+NewStarY

MessageID = 10
Server send : NewStarX+NewStarY

When the player put a star on the map, the client send the new star position to the server.
The server send an ACK message (#10) as response.

If the client don't reveice an ACK message during 1 second, the new star position is sent again. Each message send by the client needs its ACK message.

The server send a "map cell" message to other connected games.

### Other player move

server to client

MessageID = 11
Server send : PlayerID+PlayerX+PlayerY

When the server receive a new player position, it sends the position to all connected games depending on their last "map refresh" zone.
**TODO : how to define the zone depending on clients screen size and moves**

## Values types and sizes

* TSporglooAPINumber => int64

PlayerX : TSporglooAPINumber
PlayerY : TSporglooAPINumber
StarX : TSporglooAPINumber
StarY : TSporglooAPINumber
MapX : TSporglooAPINumber
MapY : TSporglooAPINumber
ColNumber : TSporglooAPINumber
RowNumber : TSporglooAPINumber

* TSporglooAPIAlpha16 => array[0..15]of byte

DevideID : TSporglooAPIAlpha16
PlayerID : TSporglooAPIAlpha16
SessionID : TSporglooAPIAlpha16

* TSporglooAPIShort => byte

MapTileID : TSporglooAPIShort

MessageID : TSporglooAPIShort = depending on the message sent
MessageEnd : TSporglooAPIShort = $00
