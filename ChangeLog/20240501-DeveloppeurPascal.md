# 20240501 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances
* verrouillage des sockets lors de l'opération d'envoi d'informations (effectué sur la librairie Socket Messaging)
* ajout du PlayerID au niveau du message TMapCellMessage
* modification de la structure du stockage (en mémoire et disque) du terrain : chaque cellule doit avoir aussi le player qui se trouve dessus
* suppression des messages envoyés par le serveur aux clients lorsqu'un joueur s'est déplacé ou lorsqu'une étoile a été posée

## Sur le jeu

* prise en compte des changements au niveau du stockage des map
* prise en compte des changements au niveau des changements sur l'API client/serveur

## Sur le serveur

* prise en compte des changements au niveau du stockage des map
* prise en compte des changements au niveau des changements sur l'API client/serveur
