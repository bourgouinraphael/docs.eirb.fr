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
