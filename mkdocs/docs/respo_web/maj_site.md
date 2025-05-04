# Comment mettre à jour un site

Pour ce faire, vous aurez besoin d'un client `SFTP`, la commande `sftp`
fonctionne très bien sous linux, et un montage `sshfs` peut vous plaire.

Cependant, il est compréhensible que des interfaces graphiques soient plus
agréables, la plupart des gestionnaires de fichiers vous permettront de vous
connecter en `SFTP` de la manière suivant.

!!! info "Gestionnaires de fichiers testés"

    La plupart des gestionnaires de fichiers doivent fonctionner, mais nous
    n'avons testé que [nemo](https://github.com/linuxmint/nemo),
    [nautilus](https://github.com/GNOME/nautilus)
    et [thunar](https://github.com/xfce-mirror/thunar)

## Connexion en `SFTP`

Si vous avez bien configuré votre fichier `~/.ssh/config` comme précédemment,
vous pouvez maintenant vous connecter au serveur d'EIRBWARE en `SFTP`, nous
préconisons 3 méthodes :

* Avec la commande `sftp`
* Monter avec `sshfs`
* Utiliser un gestionnaire de fichiers

### Avec la commande `sftp`

En utilisant la commande `sftp`, vous n'avez qu'à faire :

```sh title="Exemple de connexion à pixeirb avec sftp"
sftp eirb_pix
```

Vous êtes maintenant connecté en `SFTP` à Eirbware avec un client `CLI`.

### Monter avec `sshfs`

En utilisant la commande `sshfs`, vous pouvez monter le dossier du site web
via `SFTP` vers un dossier local, ici `~/mnt`.

!!! warning "Droits d'accès aux fichiers"

    Pour pouvoir monter dans le dossier `~/mnt`, vous devez en être
    propriétaire.

!!! warning "Droits d'accès à la configuration `ssh`"

    Si vous exécuté la commande en `root` avec `sudo`, le fichier
    `/root/.ssh/config` sera utilisé pour la configuration `ssh`, pas le votre

!!! warning "Utilisation de `-f`"

    Nous conseillons d'utiliser le _flag_ `-f` de `sshfs`, il permet, il permet
    de ne pas avoir à démonter le dossier après coup, et de savoir clairement
    quand on est connecter ou non.

!!! info "Utilisation des options `-o`"

    En utilisant le flag `-oauto_cache,reconnect,no_readahead`, il est possible
    de gagner énormément en vitesse de transfert (~10x). Il est donc conseillé
    de l'utiliser.

```sh title="Exemple de connexion à pixeirb avec sshfs"
sshfs -f eirb_pix: ~/mnt -oauto_cache,reconnect,no_readahead
```

Vous avez maintenant accès aux fichiers du site web en passant par le dossier
`~/mnt`.

### Monter avec votre gestionnaire de fichier

Écrivez dans la barre de recherche de votre gestionnaire de fichier
(Contrôle-L) :

```title="Exemple de connexion à pixeirb avec un gestionnaire de fichiers"
sftp://eirb_pix
```

Vous avez maintenant accès aux fichiers du site web directement depuis votre
gestionnaire de fichier.

## Mettre à jour les fichiers

En fonction du type de site web, la mise à jour se fait différemment.

### Site statique ou php

Eirbware utilise `docker` pour tous les sites hébergés. Pour des raisons
techniques, la plupart des sites sont de cette forme :

```title="Architecture des fichiers d'un site statique ou php"
/docker-compose.yml  # Définis Docker nginx, pas besoin de modifier
/nginx  # Dossier partagé avec le docker
/nginx/nginx  # Configuration nginx
/nginx/php  # Librairies php
/nginx/www  # Code du site
/nginx/log  # Log de nginx
/nginx/keys  # Inutilisé
```

Pour plus de détails sur le `docker` utilisé, vous trouverez la documentation
[ici](https://docs.linuxserver.io/images/docker-nginx/).

Si vous voulez mettre à jour le site, il **suffit donc de modifier** le contenu
du dossier `/nginx/www`.

### Site conteneurisé

Si le site que vous maintenez utilise un backend autre que `php`, vous allez
probablement utiliser un fichier `docker-compose.yml` fait **sur-mesure**.

Si tel est le cas, nous n'avons probablement **aucune documentation** sur ce
dernier, il est de la **responsabilité du club ou de l'association** de mettre
en œuvre les outils **nécessaires à la maintenabilité** du site web.

Voici tout de même des informations à connaître pour savoir comment gérer un
tel site :

* Vous pouvez upload un Dockerfile pour compiler sur le serveur
* Évitez d'upload le dossier `.git`
* Pour redémarrer ou recompiler le docker, faites le sur [portainer.vpn.eirb.fr](https://portainer.vpn.eirb.fr)

!!! info "Portainer"

    Pour plus d'information sur l'accès au portainer, référez-vous à la section
    `VPN` plus bas.

!!! info "Ports exposés"

    Nous **n'autorisons qu'un forward de port** de **localhost** à un conteneur.
    Ce port est **précisé dans le fichier `/README.md`** de votre site, si vous
    avez besoin d'exposer plusieurs conteneurs, utilisez un
    [reverse proxy](https://en.wikipedia.org/wiki/Reverse_proxy)
    
    [Caddy](https://caddyserver.com/) peut être une solution adaptée pour mettre
    en place facilement un reverse proxy avec un `Caddyfile`.
