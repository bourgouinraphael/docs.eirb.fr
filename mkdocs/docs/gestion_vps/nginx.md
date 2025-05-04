# Configuration du `nginx` principal

Cette section se concentre sur :

* L'organisation des services dans la configuration de `nginx`
* Les configurations avec le `nginx` principal

## Redirections

Les redirections sont faites par le `nginx` principal, vous retrouverez dans le
dossier `/etc/nginx` les dossiers suivants :

```title="Dossiers de configuration des redirections"
/etc/nginx
├── redir-available  # Configuration des différentes redirections
└── redir-enabled    # Liens symboliques des redirections actives vers les configs de redir-available
```

## Services publics

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

## Services internes

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

## Autres configurations du `nginx` principal

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

