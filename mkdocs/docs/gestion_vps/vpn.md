## VPN

L'accès aux services d'administration d'Eirbware se fait par le biais d'un
`VPN`. Ces services sont accessibles sous le nom de domaine `vpn.eirb.fr`
(exemple : `portainer.vpn.eirb.fr`).

!!!info "Raccourcis pour ces services"

    Il est possible d'accéder à cette page d'[eirb.fr](https://eirb.fr/vpn) en
    accédant à [https://vpn.eirb.fr](https://vpn.eirb.fr), elle propose des
    raccourcis vers les services d'administration d'Eirbware.

### Wireguard

Wireguard est la solution utilisée pour créer un `VPN`, elle a de nombreux
avantages :

* [Très performante](https://www.wireguard.com/performance/) comparé à des
alternatives comme [OpenVPN](https://openvpn.net/).
* Sécurisé, si vous voulez en apprendre plus, [allez ici](https://www.wireguard.com/protocol/) (il y a même des [preuves](https://www.wireguard.com/formal-verification/))

Cependant, le problème de wireguard est qu'il est peu verbeux, il est donc
compliqué de débugger une situation.

À noter qu'exécuter la commande suivante permet d'obtenir des informations sur
les connexions actuellement actives sur le serveur :

```title="Lister les connexions actives à wireguard"
sudo wg
```

### Script `wgmanage`

Afin de d'abstraire et de simplifier l'ajout d'utilisateurs au VPN, le script
`wgmanage` a été écrit. Ce script permet de :

* Lister les accès VPN existant
* Créer un nouvel accès VPN
* Retirer un accès VPN

!!!info "Page d'aide"

    Comme pour tous les scripts d'Eirbware, il est possible d'avoir une page
    d'aide en exécutant la commande suivante :

    ```title="Page d'aide pour le script wgmanage"
    sudo wgmanage --help
    ```

#### Lister les accès existant au VPN

Il est possible de lister les accès existant au VPN en utilisant la commande
suivante :

```title="Lister les accès existant au VPN"
sudo wgmanage list
```

#### Créer un nouvel accès au VPN

La création d'un nouvel accès au VPN se fait à l'aide de la commande suivante :

```title="Créer un nouvel accès au VPN"
sudo wgmanage add <cas_login>
```

Cette commande va écrire dans le terminal la configuration wireguard à
transmettre au nouvel utilisateur. Il est conseillé de nommer ce fichier
configuration `wg_eirb.conf` pour des questions d'uniformisation.

#### Retirer un accès au VPN

La suppression accès au VPN se fait à l'aide de la commande suivante :

```title="Suppression accès au VPN"
sudo wgmanage remove <cas_login>
```
