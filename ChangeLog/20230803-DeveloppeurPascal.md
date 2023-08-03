# 20230803 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* updated the Socket Messaging Library sub module
* used the new short class type names for the client and the server
* removed isconnected() from the client (now available in its ancestor)
* use onConnected and onLostConnection events on the client to send TLostServerMessage and TServerConnectedMessage notifications
