## Gestion des utilisateurs

Cette section se concentre sur :

* La création d'un nouvel administrateur
* L'archivage d'un administrateur
* L'ajout d'un accès à un respo web
* La révocation d'un accès `SSH`/`SFTP`

### Création d'un nouvel administrateur

La création d'un administrateur se fait facilement à l'aide des scripts
d'Eirbware, vous devrez vous occuper de ces 3 étapes :

* Créer l'utilisateur
* Créer un accès `SSH`
* Créer un accès wireguard

#### Création de l'utilisateur administrateur

Afin de créer un l'utilisateur pour un nouvel administrateur, vous devez
utiliser le script `new_admin` en tant qu'administrateur comme suivant :

```title="Création d'un nouvel administrateur"
sudo new_admin <cas_login>  # Créé l'utilisateur adm-<cas_login>
```

!!!info "Changement du mot de passe"

    Ce script créé un mot de passe temporaire pour l'administrateur, il devra
    **mettre à jour** son mot de passe lors de sa première connexion par `SSH`.

#### Création de l'accès `SSH`

Comme dit précédemment, l'accès par `SSH` se fait par clef et certificat, le
nouvel administrateur devra créer une paire de clefs spécifiquement pour
Eirbware en utilisant la commande suivante :

```title="Création d'une paire de clefs `SSH` par le futur administrateur"
ssh-keygen -t ed25519
```

Il devra ensuite transmettre la clef publique à l'utilisateur qui créé l'accès
`SSH` afin de créer le certificat.

!!!info "Stockage des clefs publiques"

    Les clefs publiques des utilisateurs sont stockées dans le dossier
    `/int/int-ssh/public_keys` avec le nom `id_<cas_login>.pub`, cela permet de
    créer un nouveau certificat sans avoir à retransmettre la clef publique.

    Il peut être utile de créer un nouveau certificat si un admin veut utiliser
    un accès `SFTP` ou si un respo web s'occuper de plusieurs sites

Finalement, la création du certificat pour l'administrateur se fait à l'aide de
la commande suivante :

```title="Création d'un certificat `SSH` pour un administrateur"
sudo cert_new -k /int/int-ssh/public_keys/id_<cas_login>.pub adm-<cas_login>
```

!!!info "Passphrase du certificat d'Eirbware"

    Afin de signer la clef publique, la passphrase du certificat d'Eirbware est
    nécessaire, vous la trouverez sur le [Vaultwarden d'Eirbware](https://vault.eirb.fr).

#### Création de l'accès wireguard

L'accès au `VPN` se fait comme pour n'importe quel utilisateur, référez-vous
directement à [cette section de la documentation](#wireguard).

### Archivage d'un administrateur

En vrai c'est pas dispo atm

### Ajout d'un accès à un respo web

### Révocation d'un accès `SSH`/`SFTP`
