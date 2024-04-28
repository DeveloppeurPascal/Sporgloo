# 20240428 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances
* mise à jour des docs
* ajout des TMonitor dans les unités communes pour limiter l'impact du multithread et réduire les possibilités de violations d'accès
* élimination des violations d'accès et des conflits potentiels entre threads

* mise à jour de la checklist et priorisation des choses à traiter

## Sur le jeu

* création d'une clé de chiffrement des paramètres du jeu (via XOR Keys Generator)
* implémentation du chiffrement des paramètres dans la configuration du jeu
* fiabilisation de la fermeture du programme en cas de problème réseau et de libération de la mémoire
* modifications mineures et optimisations dans l'allocation/libération mémoire
* traitement de quelques TODOs
* ajout d'une temporisation des actions au joystick (pour gérer le temps entre deux déplacements identiques)

## Sur le serveur

* changement de la distance par défaut entre deux joueurs lorsqu'on en crée un nouveau
* changement de la position par défaut si on n'a pas encore de session ouverte (au lieu de toujours (0,0))
* correction de la libération des sessions et clients connectés sur un Logoff envoyé par un client au serveur
