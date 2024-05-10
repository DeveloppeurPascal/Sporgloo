# 20240510 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances
* ajout d'une feuille de route présentant les développements à venir dans leur ordre de dépendance
* ajout des mots de passes et XOR Keys pour le mode DEBUG des projets (chiffrements et autorisations d'accès en LOGIN/REGISTER)

* renommage de LifeLevel sur les players en LivesCount
* renommage de Score sur les players en CoinsCount
* modification de la classe TSporglooPlayer
* modification de la classe TSporglooMapCell

## Sur l'API

* mise à jour des messages et leur structure pour les échanges entre le serveur et les clients (jeux)

## Sur le jeu

* mise à jour de la classe cliente de gestion des messages pour que le programme se compile (juste les changements de types et retraits de paramètres plus utilisés)

## Sur le serveur

* mise à jour de la classe serveur de gestion des messages pour que le programme se compile (juste les changements de types et retraits de paramètres plus utilisés)
* ajout des nouveaux messages de l'interface et adaptation des paramètres sur les messages existants
* finalisation de la liste des méthodes permettant d'envoyer un message attendu par le client (jeu)
* finalisation de la liste des méthodes recevant des messages depuis le client (jeu)
