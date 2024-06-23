# 20240623 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances

* tri et liste des choses à faire aujourd'hui
* prise en charge du clic sur le lien depuis la boite de dialogue "à propos"
* mise à jour de la licence (shareware) dans la fenêtre de dialogue "à propos"
* mise à jour de la description du logiciel dans la fenêtre de dialogue "à propos"
* affichage de la fenêtre de dialogue "à propos" lors de l'appuit sur F1

* création d'une boite de dialogue de type ShowMessage appelable par TcadShowMessageBox.ShowModal()
* création d'une boite de dialogue de confirmation par Yes ou No appelable par TcadShowYesNoBox.ShowModal(

* ajout d'une méthode AutoHeight de calcul de hauteur automatique de la boite grise (cadGrayBox)
* ajout du bouton "New Game" au menu principal et de son fonctionnement (à compléter une fois le ménage effectué côté serveur)

* prise en charge de l'ID du joueur pour son affichage sur les maps
* proposition de choix d'un looks de personnage au démarrage d'une partie s'il n'a pas encore été sélectionné
* ajout d'une fenêtre permettant de changer le look du joueur en cours

* passage en fonctionnement standard sur le lancement du programme : on ne repart plus sur une nouvelle partie à chaque lancement

* correction d'un effet de bord lié à length() qui retourne un NativeInt devenant un int64 en compilation 64 bits et ne peut donc pas être utilisé dans un intervale comparé à une variable de type Integer


* mise à jour de la roadmap
* mise à jour des tickets sur GitHub Issues
