# 20240526 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances
* réactivation du centrage de l'écran au démarrage de la partie (pour avoir le personnage du joueur dans l'écran)
* implémentation des réceptions de nombre de jetons, étoiles et vies provenant du serveur (avec prise en charge de l'affichage)
* added *.tmp as ignored files for git repository

* => travail sur les librairies pour créer une liste d'images SVG en cache sous forme de bitmaps

* mise à jour du programme de test d'affichage des SVG du projet (avec correction d'erreur de taille des images qui explosait quand le BitmapScale n'était pas 1)

* ajout du référencement des SVG indépendants dans la nouvelle liste de SVG prenant en charge un cache des bitmaps
* remplacement des créations de bitmaps à l'utilisation par le cache des images
