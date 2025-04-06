# Gestion du VPS

Vous retrouverez ici tous les détails de gestion du VPS (désolé, il y en a
beaucoup).

Cette page se concentre sur les détails techniques associés à chaque aspect du
VPS, il est **vivement conseillé** de bien avoir en tête
[l'architecture globale du serveur.](architecture.md)

## Installation

## Utilisation de `sudo`

Une utilisation incorrecte de `sudo` mène généralement à une utilisation non
prévue du serveur (cf [historique de l'architecture](architecture.md#historique-de-larchitecture)).

### Whitelist des programmes disponibles

Il peut y avoir des failles de sécurités liées à l'
[utilisation de wildcard (`*`) dans la configuration de  `sudo`](https://blog.compass-security.com/2012/10/dangerous-sudoers-entries-part-4-wildcards/).

C'est pourquoi, les utilisateurs du groupe `admin` ont accès à une liste
**explicite** de programmes avec `sudo`

Cette liste contient :

* Les scripts du dossier `/opt/eirbware/bin`
* `su`

!!! info "Obtenir cette whitelist"

    Vous pouvez savoir quelles commandes vous pouvez exécuter avec `sudo` en
    exécutant :

    ```sh title="Lister les commandes éxecutable en sudo"
    sudo -l
    ```

Voici comment utiliser `sudo` pour ces deux éléments :

#### Utilisation des scripts

Différents scripts sont écrits pour la gestion du VPS d'Eirbware, et sont tous
ajoutés dans la variable `$PATH` des administrateurs, ils doivent tous être
utilisés avec `sudo`.

!!!info "Documentation sur les scripts"

    Seule la façon dont les scripts doivent être exécutés est expliquée ici,
    pour des détails plus précis sur les scripts eux même, référez-vous aux
    autres sections

Pour les utiliser les scripts, exécutez simplement `sudo <script>`, par exemple :

```sh title="Exemple d'exécution du script 'new_site' pour créer pix.eirb.fr"
sudo new_site pix
```

#### Utilisation de `su - <user>`

Si une modification doit être faite par un administrateur sur un site, il doit
se **connecter sur le VPS en tant que cet utilisateur**.

Pour ce faire, on utilise la commande `su - <user>`, par exemple :

```sh title="Exemple de connexion en tant que www-pix"
sudo su - www-pix
```

L'utilisation de `sudo` est requise, car le mot de passe pour l'utilisateur
`www-pix` n'est pas connu.

!!!warning "Pourquoi `su -` ?"

    Il est important de conserver les **différentes permissions** mises en place sur le
    serveur.

    La façon la plus simple de le faire est de **ne pas utiliser `sudo` à tort
    et à travers** pour exécuter des commandes en tant que `root`.

    Sur le serveur, si une modification doit être faite, on **essaye dans un
    premier temps** de le faire en tant que l'utilisateur concerné.

#### Utilisateur `eirbware`

Malheureusement, tout ne peut pas être prévu. Et il peut être nécessaire
d'exécuter des commandes en tant que `root`.

Pour ce faire, un utilisateur `eirbware` a été créé, vous pouvez vous connecter
en tant qu'`eirbware` en faisant :

```sh title="Exemple de connexion en tant qu'utilisateur eirbware"
sudo su - eirbware
```

Cet utilisateur appartient au groupe `wheel` et peut exécuter `sudo` avec
**tous les programmes sur le VPS** moyennant une mot de passe.

!!!info "Mot de passe du compte `eirbware`"

    Vous pourrez trouver le mot de passe du compte `eirbware` sur
    [le vaultwarden d'Eirbware](https://vault.eirb.fr).

!!!info "Pourquoi ne pas ajouter tous les admins dans `wheel` ?"

    Le but est d'encourager la gestion du VPS comme elle a été pensée, mais de
    laisser un accès complet à `sudo` _pas trop contraignant_ en cas de réel
    besoin.

## Docker à Eirbware

Docker est une solution de conteneurisation très connue. Les spécificités liées
à son utilisation sur le VPS d'Eirbware vont être décrite ici.

### Docker en [mode rootless](https://docs.docker.com/engine/security/rootless)

Docker a besoin d'un `daemon` pour fonctionner, il s'appelle _subtilement_
`dockerd`. Par défaut, il est lancé en `root` par l'instance principale
`systemd`, mais nous voulons **isoler un maximum** les différents sites, donc
nous utilisons le [mode rootless](https://docs.docker.com/engine/security/rootless).

Le mode rootless utilise des [instances utilisateurs de systemd](https://wiki.archlinux.org/title/Systemd/User),
ces instances lancent elle-même un daemon `dockerd`, mais cette fois ci il
**n'est pas lancé en tant que root**. Ainsi, un utilisateur **ne peut pas
savoir** quels dockers sont lancés sur la machine, car il n'a accès
qu'à son `dockerd`.

#### Mettre en place un forward de port

Comme un utilisateur peut très bien bind un port sur une machine, `dockerd` n'a
pas de mal à mettre en place un forward même en tant qu'utilisateur non
privilégié.

Mais ce n'est pas le cas pour les ports privilégiés (<=1024). Un programme a
besoin de la [capability](https://wiki.archlinux.org/title/Capabilities)
`cap_net_bind_service`, elle peut être donnée en utilisant la commande suivante :

```sh
sudo setcap cap_net_bind_service=ep $(which rootlesskit)
```

Normalement, c'est inutile d'utiliser un de ces ports, seul un docker
[CoreDNS](https://coredns.io/) bind sur `192.168.253.1:53` utilise cette
spécificité pour résoudre `vpn.eirb.fr` et `*.vpn.eirb.fr` sur le VPN.

#### Gestion des [UID](https://wiki.archlinux.org/title/Users_and_groups)

Un utilisateur est identifié sous linux par son `uid`, et docker rootless
utilise des [user namespaces](https://docs.docker.com/engine/security/userns-remap/).

!!! warning "Le seul vrai takeaway"

    La seule information importante est qu'un mapping est mis en oeuvre, et le
    **`uid` 0 à l'intérieur du docker** correspond à **l'utilisateur ayant lancé
    le docker** sur l'hôte. C'est important dans le cadre des
    [bind mounts](https://docs.docker.com/engine/storage/bind-mounts) largement
    utilisés sur le VPS.


### Utilisation de docker en mode _rootful_

On a vu juste avant que la gestion des `uid` était pénible avec docker, et ce
n'est rien comparé à la **gestion des `gid`**.

Ce qui fait que si un conteneur doit accéder aux logs du serveur (ex: `alloy` ou
`crowdsec`), la façon **la plus facile** est de les lancer avec le `dockerd`
rootful, ce qui permet de [bind mount](https://docs.docker.com/engine/storage/bind-mounts)
sans avoir de **problèmes de permissions**.

Dans la mesure où ces services sont internes et **ne sont jamais exposés** sur
internet, on considère que ce n'est pas un problème de sécurité.

## Configuration du `nginx` principal

Cette section se concentre sur :

* L'organisation des services dans la configuration de `nginx`
* Les configurations avec le `nginx` principal

### Redirections

Les redirections sont faites par le `nginx` principal, vous retrouverez dans le
dossier `/etc/nginx` les dossiers suivants :

```title="Dossiers de configuration des redirections"
/etc/nginx
├── redir-available  # Configuration des différentes redirections
└── redir-enabled    # Liens symboliques des redirections actives vers les configs de redir-available
```

### Services publics

Les services publics sont les services accessibles par **tout le monde**, depuis
internet, il s'agit principalement des sites de liste, de clubs et d'associations.

Les configurations `nginx` se résument donc au routage des paquets vers les
conteneurs.

```title="Dossiers de configuration des services publics"
/etc/nginx
├── sites-available  # Configurations des services publics
└── sites-enabled    # Liens symboliques des vers les configs des services publics actifs
```

Les homes des sites se trouvent dans le dossier `/srv`.

### Services internes

Une subtile distinction entre les services a été ajoutée : certains services ne
sont pas accessibles depuis internet et servent à :

* Administrer le VPS
* Mettre à jour les sites

Vu que la nature de ces services est différente de celle des services publics,
il a été proposé de les séparer complètement.

!!! info "Subtilité de nommage"

    Ce qui fait référence aux **services internes** est généralement, et très
    subtilement préfixé par `int` pour _internal_.

```title="Dossiers de configuration des services internes"
/etc/nginx
├── int-available  # Configurations des services internes
└── int-enabled    # Liens symboliques des vers les configs des services internes actifs
```

### Autres configurations du `nginx` principal

La configuration de `nginx` a été **légèrement factorisée**, et pour retrouver
ce qui l'a été, la plupart de ces factorisations se trouve dans le dossier
`/etc/nginx/config`.

On peut y retrouver :

```title="Fichiers de configuration supplémentaire de nginx"
/etc/nginx/config
├── https.conf          # Configurations ssl
├── rate_limit.conf     # Légère configuration d'un rate limit
├── proxy_headers.conf  # Factorisation de la création des headers pour proxy les requêtes
└── hardening.conf      # Configurations diverses de sécurité
```

## Gestion des services

Cette section se concentre sur :

* La création d'un nouveau service
* L'archivage d'un service

!!!info "Comment supprimer un service ?"

    Volontairement, on **ne peut pas supprimer** un service, le but étant de ne
    pas perdre de données.

    Selon les contraintes de stockages actuelles, il n'y a pas de problème lié
    à ce système.

### Création d'un nouveau service

### Archivage d'un service


## Gestion des utilisateurs

Cette section se concentre sur :

* La création d'un nouvel administrateur
* L'archivage d'un administrateur
* L'ajout d'un accès à un respo web
* La révocation d'un accès `SSH`/`SFTP`

### Création d'un nouvel administrateur

### Archivage d'un administrateur

### Ajout d'un accès à un respo web

### Révocation d'un accès `SSH`/`SFTP`

## Firewall

### Utilisation de `firewalld`

`firewalld` a un système de **zones**, qui sont sur le VPS des abstractions de
réseaux.

Dans chacune de ces zones, on peut activer ou désactiver des services.

Pour plus de détails sur l'utilisation de la cli de firewalld, nous vous
conseillons [cet article](https://www.redhat.com/en/blog/beginners-guide-firewalld).

!!!info "Zones de `firewalld` sur le VPS d'Eirbware"

    Nous utilisons deux zones : `public` et `wg_eirb`.

    * La zone `public` contient les règles liées à internet
    * La zone `wg_eirb` contient les règles liées au réseau privé créé avec `wireguard`


### Utilisation de `crowdsec`

Comme décrit dans [l'architecture globale](architecture.md), `crowdsec` a
besoin **d'accéder en lecture aux logs** qu'il analyse.

Pour simplifier sa mise en place, `crowdsec` est lancé dans un docker rootful,
pour pouvoir bind-mount facilement les logs.

Les fichiers et la configuration de `crowdsec` se trouvent dans le dossier
`/int/int-crowdsec`.

## `SSH` et `SFTP`

### Utilisation de certificats `SSH`

Cela permet notamment de spécifier une durée de validité d'un certificat.

### Utilisation des scripts `cert-*`

Il y a 3 scripts servant à la gestion des accès en `SFTP` aux sites web
d'Eirbware, ils sont :

* `cert_list` : liste les accès `SFTP` existant
* `cert_new` : Créé un accès `SFTP` à un site web pour un nouvel utilisateur
* `cert_revoke` : Révoque un certificat `SSH` pour un site web pour un utilisateur

Pour plus de détails sur leur utilisation, exécutez les différents scripts avec
le flag `-h`.

## VPN

### Wireguard

### Script `wgmanage`

Ce script permet de :

* Lister les accès VPN existant
* Créer un nouvel accès VPN
* Retirer un accès VPN

## Monitoring

Il est primordial de mettre en place des systèmes de monitoring pour analyser
l'activité d'un serveur.

### Grafana

Application web servant à visualiser des données sous la forme de dashboard.

### Grafana Loki

Base de donnée servant stocker des logs.

### Grafana Alloy

Outil servant à fetch et envoyer des logs dans une base de donnée Loki.

### Grafana Prometheus

Base de donnée pour stocker des metrics pour Grafana.

### What's Up Docker (WuD)

Outil de notification en cas de docker à mettre à jour.

