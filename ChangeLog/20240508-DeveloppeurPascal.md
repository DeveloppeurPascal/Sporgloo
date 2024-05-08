# 20240508 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances

## Sur le jeu

* changement de la version du client (jeu) en 0.2a du 08/05/2024

* choix d'une fonte graphique pour afficher les chiffres du score, nombre d'étoiles et niveau de vie
* mise en place d'un cadre pour l'affichage du nombre d'étoiles disponibles, le score actuel, le niveau de vie

* choix des images pour les pavés "score" et "life level" (Adobe Illustrator aux manettes) et mise en place sur les zones d'affichage correspondantes

* mise à jour des panels de scores, étoiles et niveau de vie par un envoi de message directement depuis la classe TSporglooPlayer

* nettoyage des propriétés inutiles dans la fiche principale (TfrmMain)

* ajout d'un bouton jaune carré pour les boutons de l'écran de jeu (musique on/off, pause du jeu)
* ajout de la zone de boutons dans l'écran de jeu
* réactivation du curseur de la souris dans l'écran de jeu sinon impossible de choper le bouton pause ou musique on/off

* mise en place et prise en charge du bouton PAUSE dans l'écran de jeu
* mise en place et prise en charge du bouton MUSIC ON/OFF dans l'écran de jeu

* correction de la taille des pavés d'affichage de données du joueur en démarrage de partie (seul le nombre d'étoiles était de la bonne largeur)
* modification du mode de calcul des distances pour trouver l'étoile à atteindre (passage en diagonale plutôt que largeur/hauteur)

* déploiement en test de la version 0.2a

## Sur le serveur

* adaptations aux modifications sur les messages internes (pour pouvoir toujorus le compiler)
