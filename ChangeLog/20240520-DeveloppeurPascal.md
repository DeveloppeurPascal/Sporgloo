# 20240520 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances
* refonte des SVG des images en format intégré, sans les styles, dans Adobe Illustrator pour les rendre compatibles avec le module de dessin intégré à Skia4Delphi (cf https://github.com/skia4delphi/skia4delphi/blob/main/Documents/SVG.md)
* réorganisation du dossier assets/graphics pour séparer les SVG par série (forêt, personnages, fond, ...)
* ajout des unités contenant les codes sources des SVG utilisés dans le projet
* ajout d'un programme de contrôle de l'affichage des SVG passant par Skia4Delphi

-----

* mise en place des fichiers sources des SVG dans le projet
* remplacement des TGlyph utilisant les listes d'images bitmap de l'unité Sporgloo.Images.pas par des TImage utilisateurs des SVG
* suppression de l'unité Sporgloo.Images.pas
* modification du chemin de récupératiuon de la musique de fond quand on est en DEBUG sous Windows
* ajout de personnages supplémentaires pour laisser plus de choix aux utilisateurs lorsqu'ils démarreront une partie (toons, aliens et les persos du RPG pack en pixel art)
* mise à jour de l'API cliente au niveau de l'enregistrement et la connexion auprès du serveur
* ajout des nouveaux messages et changement sur certains qui ont été dépréciés ou modifiés afin de coller à la bonne version de l'API entre jeux et serveur
* publication de la release 0.3a de test après mise en ligne de la nouvelle version du serveur
