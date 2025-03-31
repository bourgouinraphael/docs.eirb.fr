# Gestion du VPS

Vous retrouverez ici tous les détails de gestion du VPS (désolé, il y en a
beaucoup).

Cette page se concentre sur les détails techniques associés à chaque aspect du
VPS, il est **vivement conseillé** de bien avoir en tête
[l'architecture globale du serveur.](architecture.md)

## Installation



## Firewall

### Utilisation de `firewalld`

### Utilisation de `crowdsec`

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


### Utilisation de docker en mode rootful

Lié à


## Gestion des services

### Redirections


### Services publics

### Services internes

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

