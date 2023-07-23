# 20230723 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

## Stream du "matin" (9h30 - 19h)

* passage en écoute sur 0.0.0.0:8080 sur le serveur afin d'écouter toutes les IPv4 locales et ne pas avoir de problème de droits sur Linux
* ajout des paramètres d'IPv4 et IPv6 pour que le jeu accède au serveur de jeu (uConfig)
* ajout de logs côté serveur (pour le débogage)
* modification de SendAPIMessage() sur le serveur et le client afin de s'assurer que ce qui a été envoyé est bien envoyé
* utilisation des paramètres d'IP+Port pour se connecter au serveur depuis le jeu (client)
* correction des fonctions d'envoi et des fonctions de réception des messages (position, buffer, et autres erreurs d'inattention)
* ajout d'un système interne de messagerie entre processus pour informer l'interface utilisateur de la connexion et déconnexion vers le serveur
* modification du démarrage du programme (connection au serveur, envoi d'un register et/ou login puis demande de la map)
* ajout d'un système de notification de l'interface utilisateur à chaque changement d'une cellule provenant du serveur

* ajout d'un data module pour stocker les images SVG du jeu (boutons, décors, personnages)
* suppression du termminateur utilisé dans les buffers de mesages car '0' est une valeur possible dans un stockage binaire de nombres
* correction des calculs de taille max de la zone demandée sur une session
* correction de la récupérationd ela valeur d'une cellule de la map (violation d'accès)
* correction du timer déclenchant les refresh de la map suite à resize, ça ne se déclenchait qu'une fois avant de désactiver la frame et toutes ses fonctionnalités

* correction de l'enregistrement des cellules dans la carte
* mise en place du refresh complet de la carte et changement au niveau de ses modifications (côté client, comme côté serveur)
* changement du message ID 6 qui n'envoi désormais que les cellules avec quelque chose dedans (optimisation réseau et temps de réponse)
* affichage de l'écran de jeu et du player

* mise en place des écrans de jeu et du système d'affichage
* prise en charge de ESC ou HardwareBack (Android)

* activation de l'écran de jeu depuis le menu (en test) avec action de la souris sur l'écran pour poser des étoiles
* synchronisation de l'affichage entre plusieurs logiciels clients
* tentative d'amélioration de l'envoi d'informations aux clients connectés depuis le serveur en cas de nouvelle étoile ou de déplacement de joueur

* tests divers de fonctionnement mono et multi joueur avec crashs aléatoires du serveur 

**hors délai pour soumettre le jeu à la KenneyJam donc échec pour cette année, mais jeu à poursuivre ultérieurement**
