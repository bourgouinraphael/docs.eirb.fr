# Gestion des redirections

Afin que tous les services possèdent une addresse finissant en .eirb.fr (comme [celle-ci](https://feur.eirb.fr)), pas seulement ceux hébergés par eirbware, il est possible de créer des redirections

Cette section se concentre donc sur: 

* La création de redirections
* La désactivation de redirections 
* La suppression de redirections

## Création d'une redirection 

La création d'une redirection se fait via la commande `new_redir`, dont le fonctionnement est explicité en utilisant l'option `-h`

## Désactivation d'une redirection 

De manière similaire à la [désactivation d'un service](services.md#desactivation-dun-service), la commande à utiliser est `disable_redir`, de la manière suivante:

```title="Désactivation d'une redirection"
sudo disable_redir <nom_redir>
```

Cette commande possède aussi une option -r, afin de réactiver les redirection précédemment désactivées

## Suppresion d'une redirection

La commande à utiliser est `remove_redir`, dont le fonctionnement est expliqué en ajoutant l'option `-h`
