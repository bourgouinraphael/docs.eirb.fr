# HOWTO être respo web

Si vous vous êtes retrouvé ici, c'est probablement que vous êtes **respo web** pour
un club ou une association (ou peut-être même une _liste ?👀👀_).

Vous trouverez sur cette page **tout ce qu'il faut savoir** pour :

* Demander l'ajout d'un site
* Demander un accès pour mettre à jour un site
* Mettre à jour un site.
* Gérer la connexion au CAS

!!! info "Imposante la brasse 😱"

    Cette page de documentation est assez longue, n'hésitez pas à utiliser le
    sommaire à droite pour aller directement à la section qui vous intéresse.

## Comment demander l'ajout d'un site

Pour demander l'ajout d'un site, il suffit de demander gentiment à un membre
du bureau d'Eirbware !

Voici différentes manières d'en contacter un :

* Le contacter directement sur Telegram si vous en connaissez un
* Envoyer un message sur le groupe [Discussion d'Eirbware](https://telegram.eirb.fr) sur Telegram
* Envoyer un mail à [eirbware@enseirb-matmeca.fr](mailto:eirbware@enseirb-matmeca.fr)

## Comment demander un accès pour mettre à jour un site

Vous allez ensuite rajouter dans votre fichier `~/.ssh/config` les lignes
suivantes (exemple pour pixeirb) :

```title="~/.ssh/config" linenums="1"
Host eirb_pix
    Hostname eirb.fr
    User www-pix
    IdentityFile    ~/.ssh/<Votre clef SSH>
    CertificateFile ~/.ssh/<Votre certificat SSH>
```

Avec ceci, vous avez tout pour passer à l'étape d'après : Comment mettre à jour
un site ?

## Comment mettre à jour un site

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

### Connexion en SFTP

Si vous avez bien configuré votre fichier `~/.ssh/config` comme précédemment,
vous pouvez maintenant vous connecter au serveur d'EIRBWARE en `SFTP`, nous
préconisons 3 méthodes :

* Avec la commande `sftp`
* Monter avec `sshfs`
* Utiliser un gestionnaire de fichiers

#### Avec la commande `sftp`

En utilisant la commande `sftp`, vous n'avez qu'à faire :

```sh title="Exemple de connexion à pixeirb avec sftp"
sftp eirb_pix
```

Vous êtes maintenant connecté en `SFTP` à Eirbware avec un client `CLI`.

#### Monter avec `sshfs`

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

#### Monter avec votre gestionnaire de fichier

Écrivez dans la barre de recherche de votre gestionnaire de fichier
(Contrôle-L) :

```title="Exemple de connexion à pixeirb avec un gestionnaire de fichiers"
sftp://eirb_pix
```

Vous avez maintenant accès aux fichiers du site web directement depuis votre
gestionnaire de fichier.

### Mettre à jour les fichiers

En fonction du type de site web, la mise à jour se fait différemment.

#### Site statique ou php

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

#### Site conteneurisé

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

## Accès au `VPN`

Certains outils d'administration sont installés sur le serveur, pour des
raisons de **sécurité**, ces outils **ne sont pas accessibles par internet**.

Parmi ces outils, **seul Portainer** vous concerne.

!!! warning "Accès à `*.vpn.eirb.fr`"

    L'accès à ces noms de domaines se fait **uniquement via le `VPN`**, et vous
    devrez utiliser le `DNS` qui est sur ce `VPN`, vérifiez que le
    [`DoH`](https://en.wikipedia.org/wiki/DNS_over_HTTPS) n'est pas activé sur
    votre navigateur.

### Demander un accès

De la même façon que pour l'accès `SFTP`, il vous faut contacter un membre
d'Eirbware, voici quelques techniques :

* Le contacter directement sur Telegram si vous en connaissez un
* Envoyer un message sur le groupe [Discussion d'Eirbware](https://telegram.eirb.fr) sur Telegram
* Envoyer un mail à [eirbware@enseirb-matmeca.fr](mailto:eirbware@enseirb-matmeca.fr)

On vous transmettra à l'issue de cette demande un fichier `wg_eirb.conf` qui
est un fichier de configuration pour `wireguard`.

### Installer un logiciel pour se connecter

Il vous faudra télécharger un
[client pour `wireguard`](https://www.wireguard.com/install/).

#### Se connecter sous linux

Normalement, vous avez téléchargé un client `wireguard` en utilisant le
gestionnaire de paquets de votre distribution.

Le paquet que vous avez installé vous a normalement installé le script
`wg-quick`, vous pourrez vous connecter au `VPN` en utilisant la commande
suivante dans un `shell` :

```sh title="Commande pour se connecter au VPN sous linux"
wg-quick up ./wg_eirb.conf
```

!!! warning "Chemin vers la config `wireguard`"

    Vous devez spécifier un chemin **relatif ou absolu** vers la configuration
    `wireguard`, comme `./wg_eirb.conf` ou `/tmp/wg_eirb.conf`, sinon
    `wg-quick` essayera de trouver le fichier dans `/etc/wireguard`.

Pour vous déconnecter, exécutez :

```sh title="Commande pour se déconnecter du VPN sous linux"
wg-quick down ./wg_eirb.conf
```

#### Se connecter sous Windows

jsp comment faire mdr

## Gérer la connexion CAS

Le CAS a **toujours été** un problème très ennuyeux à gérer.

Nous avons essayé de trouver deux solutions pour que la mise en place d'une
connexion CAS soit la **plus simple possible**.

### En utilisant notre `API` "protect"

Si votre site est statique ou est fait en `PHP`, et utilise la configuration
`nginx` par défaut, nous vous conseillons cette solution.

Il s'agit d'un petit serveur `PHP` présent dans toutes les configurations par
défaut, nous proposons une librairie `javascript` pour l'utiliser depuis le
site web.

Pour télécharger la librairie, et avoir plus de documentation au sujet de
protect, allez sur [ce dépôt](https://github.com/Eirbware/protect).

### En utilisant [OpenID](https://openid.net/) avec keycloak ([connect.eirb.fr](https://connect.eirb.fr))

Étant donné que le CAS est assez désagréable à utiliser, et n'est pas
accessible en local, nous avons mis en place un relais d'authentification avec
[keycloak](https://www.keycloak.org/).

Vous pourrez utiliser ce système d'authentification à l'aide de librairies
(OpenID Provider), OpenID [en liste un certain nombre](https://openid.net/developers/certified-openid-connect-implementations/)

Voici une liste plus timide que vous pouvez utiliser :

* PHP : [OpenID-Connect-PHP](https://github.com/jumbojett/OpenID-Connect-PHP)
* JS/TS : [openid-client](https://www.npmjs.com/package/openid-client)

Pour pouvoir vous utiliser OpenID, vous devrez utiliser un secret, vous le
trouverez avec une configuration dans le dossier du site web que vous maintenez.

## Conseil de la part d'Eirbware

Il existe aujourd'hui beaucoup de technologies pour créer des sites web, et il
y a de quoi se demander "Quelle technologie devrais-je utiliser ?".

Voici quelques conseils que nous avons à vous partager en prenant en compte le
système associatif de l'ENSEIRB.

!!! info "Contrainte principale de l'associatif"

    Les clubs et les associations de l'ENSEIRB changent de membres
    **tous les ans**, il est primordiale de s'assurer que le mandat suivant
    puisse **maintenir le site**.

### Considérez le vanilla

Considérez de faire votre site en HTML/CSS/JS vanilla, voici les avantages :

* S'il y a un respo web dans le prochain mandat, il maitrisera les technologies
* Pas besoin d'avoir un dépôt git pour stocker les sources

Cependant, écrire un code _scalable_ en vanilla n'est pas trivial,
notamment pour l'écriture du `CSS`. Il est conseillé d'utiliser la
[convention BEM](https://getbem.com) pour s'en sortir en écrivant ce genre de
site.

### Si le vanilla vous fait peur

L'avantage du vanilla est qu'il est _censé_ être un prérequis aux autres
technologies web, ce qui le rend universel. Le maintenir peut tout de même être
pénible.

Voici des notes à propos des alternatives.

!!! warning "La contrepartie très importante"

    Un site qui n'est pas fait en vanilla, nécessite d'être compilé !

    La version sur [eirb.fr](https://eirb.fr) **ne peut donc pas suffire** à une
    passation, un **dépôt git et des instructions de compilations** doivent
    être transmise au prochain mandat pour que le site soit **maintenable**.

!!! info "Conseil pour gérer un dépôt git"

    Considérez la création d'une [organisation github](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch),
    cela permet de simplifier une passation : il n'y a plus qu'à changer le
    propriétaire de l'organisation

#### Le cas Typescript

Le manque de typage en javascript est **clairement** ennuyeux, et l'utilisation
de [typescript](https://www.typescriptlang.org) est clairement intéressant.

#### Les frameworks CSS

Les frameworks comme [tailwindCSS](https://tailwindcss.com) et
[bootstrap](https://getbootstrap.com) se comprend : cela permet de gérer le
responsive plus facilement, et d'accélérer la phase de développement.

Voici une [liste _assez imposante_ de frameworks](https://github.com/troxler/awesome-css-frameworks).

#### Les frameworks JS

En derniers viennent les frameworks JS, faire un site en
[React](https://react.dev/) est tentant, mais on a toujours la même
problématique : tout le monde ne connait pas React.

#### Générateurs de sites statiques

En fonction du besoin, les générateurs de sites statiques (comme
[Material for mkdocs](https://squidfunk.github.io/mkdocs-material) utilisé pour
le site sur lequel vous êtes) peut être une **très bonne solution**.

Ils permettent de générer un site web en vous **concentrant sur le contenu**.

### Technologies pour un backend

Si vous avez **absolument** besoin d'un backend, vous pouvez utiliser la
technologie que vous voulez, car tous les sites sont conteneurisés.

Cependant, comme dit précédemment, potentiellement **personne ne pourra
maintenir le site** dans le futur.

!!! warning "Considérez notre API `protect` d'abord"

    L'API que nous proposons avec `protect` permet quelques fonctionnalités
    avec une connexion CAS, peut-être que c'est suffisant pour vos besoins.

    Peut-être que votre besoin peut être rajouté à `protect`, si votre besoin
    est proche de ce que cette API propose, considérez d'en parler à Eirbware
    pour que ça soit rajouté.

Si vous avez besoin d'un backend, nous vous conseillons :

* De garder le backend le plus simple possible
* Pour une base de donnée, restez sur [postgres](https://www.postgresql.org/) ou [sqlite](https://www.sqlite.org/)
* Restez sur du SQL, c'est étudié en cours, pas [mongodb](https://www.mongodb.com/), ni [redis](https://redis.io/)
* D'utiliser git pour versionner le code, et le transmettre aux passations

Pour ce qui est des technologies pour un backend, nous vous conseillons :

* [NodeJS](https://nodejs.org) & [ExpressJS](https://expressjs.com/), ce framework est basique et permet d'être plus maintenable
* [Flask](https://flask.palletsprojects.com) en python, idem, simple donc maintenable même avec peu de connaissances

