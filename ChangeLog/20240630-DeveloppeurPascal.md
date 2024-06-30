# 20240630 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances
* remplacement des ShowMessage() par les fenêtres de dialogue stylées via TcadShowMessage
* interception des erreurs de sockets pour afficher des messages d'erreur au joueur et traiter l'erreur
* suppression du nom des cadres utilisés en boite de dialogue pour éviter une erreur de doublon lors de leur création
* correction de certains contrôles (inutiles ou bloquants dans des conditions pas forcément normales) au niveau de l'API côté serveur
* finalisation du fonctionnement du lancement d'une nouvelle partie
