# Docker à Eirbware

Docker est une solution de conteneurisation très connue. Les spécificités liées
à son utilisation sur le VPS d'Eirbware vont être décrite ici.

## Docker en [mode rootless](https://docs.docker.com/engine/security/rootless)

Docker a besoin d'un `daemon` pour fonctionner, il s'appelle _subtilement_
`dockerd`. Par défaut, il est lancé en `root` par l'instance principale
`systemd`, mais nous voulons **isoler un maximum** les différents sites, donc
nous utilisons le [mode rootless](https://docs.docker.com/engine/security/rootless).

Le mode rootless utilise des [instances utilisateurs de systemd](https://wiki.archlinux.org/title/Systemd/User),
ces instances lancent elle-même un daemon `dockerd`, mais cette fois ci il
**n'est pas lancé en tant que root**. Ainsi, un utilisateur **ne peut pas
savoir** quels dockers sont lancés sur la machine, car il n'a accès
qu'à son `dockerd`.

### Mettre en place un forward de port

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

### Gestion des [UID](https://wiki.archlinux.org/title/Users_and_groups)

Un utilisateur est identifié sous linux par son `uid`, et docker rootless
utilise des [user namespaces](https://docs.docker.com/engine/security/userns-remap/).

!!! warning "Le seul vrai takeaway"

    La seule information importante est qu'un mapping est mis en oeuvre, et le
    **`uid` 0 à l'intérieur du docker** correspond à **l'utilisateur ayant lancé
    le docker** sur l'hôte. C'est important dans le cadre des
    [bind mounts](https://docs.docker.com/engine/storage/bind-mounts) largement
    utilisés sur le VPS.


## Utilisation de docker en mode _rootful_

On a vu juste avant que la gestion des `uid` était pénible avec docker, et ce
n'est rien comparé à la **gestion des `gid`**.

Ce qui fait que si un conteneur doit accéder aux logs du serveur (ex: `alloy` ou
`crowdsec`), la façon **la plus facile** est de les lancer avec le `dockerd`
rootful, ce qui permet de [bind mount](https://docs.docker.com/engine/storage/bind-mounts)
sans avoir de **problèmes de permissions**.

Dans la mesure où ces services sont internes et **ne sont jamais exposés** sur
internet, on considère que ce n'est pas un problème de sécurité.

