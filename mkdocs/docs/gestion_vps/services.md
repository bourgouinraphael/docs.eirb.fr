# Gestion des services

Cette section se concentre sur :

* La création d'un nouveau service
* La désactivation d'un service
* L'archivage d'un service

!!!info "Comment supprimer un service ?"

    Volontairement, on **ne peut pas supprimer** un service, le but étant de ne
    pas perdre de données.

    Selon les contraintes de stockages actuelles, il n'y a pas de problème lié
    à ce système.

## Création d'un nouveau service

Afin de créer un service, il suffit d'utiliser la commande `new_site`, dont le fonctionnement est détaillé avec l'option `-h`

## Désactivation d'un service 

Pour pouvoir temporairement désactiver un service, il faut utiliser la commande `disable_site` de la manière suivante: 

```title="Désactivation d'un site"
sudo disable_site www-<nom_site>
```

Pour le réactiver, il suffit d'utiliser la même commande avec l'option `-r`

!!!info "Ce que la commande ne fait pas"

    Cette commande désactive juste la redirection vers le service, mais elle n'arrête pas le docker associé

## Archivage d'un service

