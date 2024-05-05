# 20240505 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances
* ajout de DeveloppeurPascal/AboutDialog-Delphi-Component en sous module
* renommage du dossier assets/icon en assets/icons
* renommage de la constante CSporglooTileNone en CSporglooTileForest puisque c'était ce qui s'affiche en cas de "rien" sur la map
* correction d'un bogue à la création des cellules de la carte (invisible quand on crée à 0 mais effets de bord possibles)

## Sur le jeu

* mise à jour du titre de la fenêtre avec le numéro et la date de version du programme en passant par le composant aboutbox
* mise à jour des options de projet suite au changement du nom du dossier "assets/icons"
* passage du jeu en version 0.1a du 20240505
* ajout d'un marge autour du viewport pour accélérer les déplacement sans dépendre des temps de réponse du serveur (chaque déplacement demandera les infos avec la marge adaptée)
* utilisation de Return ou Space pour actionner un bouton de menu et pour poser une étoile à l'écran
* ajout de coordonnées cibles au niveau du player et d'une boucle (en timer) de déplacement vers cette destination
* ajout de la recherche de l'étoile la plus proche
* mise en place d'un déplacement simple du joueur
* publication en test de la version 0.1a du programme

## Sur le serveur

* mise à jour des options de projet suite au changement du nom du dossier "assets/icons"
* adaptation des messages du serveur aux changements liés aux déplacements des joueurs et à l'activation/récupération des étoiles
* mise en ligne d'une nouvelle version du serveur pour tests
