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

