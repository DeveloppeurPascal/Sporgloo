# 20240330 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

## morning stream

* updated submodules
* added the API Version in register and login messages between games (clients) and the server
* updated the client/server messages API unit
* upgraded the server program to Delphi 12 Athens, the new client/server messages list and changes in submodules units path
* upgraded the client program to Delphi 12 Athens, the new client/server messages list and changes in submodules units path
* refactoring : changed IDs type to string and removed old code to manage TSporglooAPIAlpha16 type
* added the error message from the server to the client on register/login operations
* replaced the exceptions in the server by a common send of TErrorMessage to the concerned client

## afternoon stream (with an OBS crash)

* updated Skia4Delphi dependencies in FR/EN docs
* updated the client program (the game) to follow the new Socket Messaging unit and receiving message events
* updated the server program to follow the new Socket Messaging unit and receiving message events
* refactoring : client class simplification
* mise en place du stockage de la base de données du jeu et de son chargement (pour le serveur)

## afternoon stream (after OBS crash)

* prise en charge des mouvements des autres joueurs pour les afficher s'ils rentrent dans notre zone
* removed DeviceID and Player ID in Session class, replaced by the Player
* added some consts for default values on Player creation
* send the new Player position and tile change to existing players
* change default position for a new player (around an other connected player but not in (0,0))
* updated Android SDK&libraries list on Sporgloo client

## evening stream

* added a disconnect message from client to server and from server to client on closing a program
* added 2 graphical fonts from AdobeStock (generated with Folder2FMXImageList)
* added the game title in the client window
* added a frame for dialog boxes
* added a frame for menu buttons
* added the box and menu buttons in home screen
