# 20240330 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* updated submodules
* added the API Version in register and login messages between games (clients) and the server
* updated the client/server messages API unit
* upgraded the server program to Delphi 12 Athens, the new client/server messages list and changes in submodules units path
* upgraded the client program to Delphi 12 Athens, the new client/server messages list and changes in submodules units path
* refactoring : changed IDs type to string and removed old code to manage TSporglooAPIAlpha16 type
* added the error message from the server to the client on register/login operations
* replaced the exceptions in the server by a common send of TErrorMessage to the concerned client
