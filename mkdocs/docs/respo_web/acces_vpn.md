# Accès au `VPN`

Certains outils d'administration sont installés sur le serveur, pour des
raisons de **sécurité**, ces outils **ne sont pas accessibles par internet**.

Parmi ces outils, **seul Portainer** vous concerne.

!!! warning "Accès à `*.vpn.eirb.fr`"

    L'accès à ces noms de domaines se fait **uniquement via le `VPN`**, et vous
    devrez utiliser le `DNS` qui est sur ce `VPN`, vérifiez que le
    [`DoH`](https://en.wikipedia.org/wiki/DNS_over_HTTPS) n'est pas activé sur
    votre navigateur.

## Demander un accès

De la même façon que pour l'accès `SFTP`, il vous faut contacter un membre
d'Eirbware, voici quelques techniques :

* Le contacter directement sur Telegram si vous en connaissez un
* Envoyer un message sur le groupe [Discussion d'Eirbware](https://telegram.eirb.fr) sur Telegram
* Envoyer un mail à [eirbware@enseirb-matmeca.fr](mailto:eirbware@enseirb-matmeca.fr)

On vous transmettra à l'issue de cette demande un fichier `wg_eirb.conf` qui
est un fichier de configuration pour `wireguard`.

## Installer un logiciel pour se connecter

Il vous faudra télécharger un
[client pour `wireguard`](https://www.wireguard.com/install/).

### Se connecter sous linux

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

### Se connecter sous Windows

jsp comment faire mdr
