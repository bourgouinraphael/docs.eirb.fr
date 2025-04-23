# Passation Eirbware

Cette page permet de lister ce qu'il faut faire lors **d'une passation d'Eirbware**.

Le but étant d'uniformiser les passations pour limiter les oublis et les pertes
d'informations.

## La banque : Anytime

C'est un enfer.

## Google drive

On utilise google drive pour stocker des diverses informations.

On aimerait bien s'en débarrasser, mais les gsheet sont actuellement pratiques
pour la trésorerie.

La passation se fait en **transférant la propriété du drive au président
entrant**, ce **nouveau président** a ensuite la responsabilité de le partager
avec **tous les membres d'Eirbware**.

## Gestionnaire de mots de passes : Vaultwarden

On utilise [Vaultwarden](https://github.com/dani-garcia/vaultwarden), une
alternative open-source à Bitwarden, qui est compatible avec 
[les clients](https://github.com/bitwarden/clients) développés par Bitwarden,
qui sont [(globalement) open-source](https://community.bitwarden.com/t/concerns-over-bitwarden-moving-away-from-open-source-what-does-our-future-hold/74800)

Il a l'avantage de proposer un **système d'organisations**, il suffit donc de
**créer des comptes** pour le mandat suivant pour transmettre les mots de
passes.

### Compte eirbware

Sur un maximum de services, on essaye de garder un compte "eirbware", dont les
différents mots de passe sont stockés sur [le vaultwarden](https://vault.eirb.fr).

Ce système plutôt que de donner des accès administrateurs à chaque membres du
bureau permet de réduire le nombre d'actions à faire lors d'une passation

### Créer des comptes

1. Aller sur [vault.eirb.fr](https://vault.eirb.fr)
1. Se connecter avec son compte (Le compte du président entrant est créé par le
président sortant)
1. Aller dans l'onglet "Organizations" dans le header
1. Aller dans le sous-onglet "Members" de l'organisation Eirbware
1. Appuyer sur "Invite Member"
1. Remplir l'Email
1. Donner les droits adéquats comme décrit dans la section suivante
1. Appuyer sur "Save"
1. Se déconnecter
1. Se connecter en tant qu'Eirbware (logins dans le vaultwarden)
1. Accepter l'ajout de membre dans le sous-onglet "Needs Confirmation" de
l'Organisation Eirbware

!!!warning "Respecter les étapes"

    il est **NÉCESSAIRE** de créer une invitation depuis l'interface de
    l'organization, comme décrit dans la section "Création d'un compte"

    Si la personne fait directement "Create Account" sur
    [vault.eirb.fr](https://vault.eirb.fr), alors elle **n'aura pas accès à
    l'organisation**, et il **faudra supprimer** le compte puis le **recréer**
    correctement.

### Notes

* Le TOTP est obligatoire pour tout le monde, mais le rôle admin permet ne
bloque pas un utilisateur qui n'a pas activé son TOTP, il faut faire attention
à ce qu'il soit bien activé !
* Ce serveur ne doit pas être utilisé à des fins personnelles, les membres, une
fois dans l'org Eirbware, ne peuvent pas créer de login perso, mais les admins
peuvent, il faut qu'ils fassent attention à ne pas enregistrer de login perso
sans faire exprès

### Les droits en fonction du rôle

#### Président

* Rôle : "Admin"
* Collections : "Grant access to all current and future collections."

#### Vice-président

* Rôle : "Admin"
* Collections : "Grant access to all current and future collections."

#### Secrétaire

* Rôle : "Manager"
* Collections : "Can edit : Administratif, Général"

#### Trésorier

* Rôle : "Manager"
* Collections : "Can edit : Achats, Administratif, Général"

#### Respo Serveur

* Rôle : "Manager"
* Collections : "Can edit : Administratif, Serveur"

#### Respo Com

* Rôle : "Manager"
* Collections : "Can edit : Réseaux Sociaux"


### Clients bitwarden

Pour utiliser vaultwarden, nous conseillons d'utiliser l'extension de navigateur bitwarden.

!!!info "Connexion internet et extension de navigateur"

    L'extension de navigateur bitwarden garde en **cache une version chiffrée**
    de la base de donnée des mots de passes.

    Ainsi, même **sans connexion au serveur Vaultwarden**, vous pouvez accéder
    aux mots de passes.

!!!info "Tips avec l'extension"

    En faisant Ctrl+l, vous pouvez remplir un formulaire de login
    automatiquement.


## Créer des comptes admin sur le VPS

Usuellement, les membres suivants ont accès au VPS :

* Président
* Vice-président
* Respo serveur

### Création d'un compte

L'ajout d'un administrateur se fait en exécutant la commande suivante :

```sh
sudo new_admin <admin name>
```

Par exemple :

```sh
sudo new_admin ndacremont  # Va créer l'utilisateur adm-ndacremont
```

### Créer un accès `SSH`

Après avoir créé l'utilisateur admin, vous pouvez créer un accès `SSH`.

Pour ce faire, il faut la _passphrase_ du certificat `SSH` d'Eirbware, qui est
trouvable sur [le vaultwarden](https://vault.eirb.fr).

Il suffit ensuite d'exécuter la commande suivante :

```sh
sudo cert_new -k <chemin vers clef publique> adm-<admin name>
```

Par exemple, la commande suivante va créer un certificat `/tmp/id-cert.pub` pour
la clef publique donnée `/tmp/id.pub` pour l'utilisateur `adm-ndacremont`.

```sh
sudo cert_new -k /tmp/id.pub adm-ndacremont
```

Le mieux est de demander la clef `SSH` publique des membres d'Eirbware

!!!info "Accès à la _passphrase_ du certificat"

    Avant, seul le président d'Eirbware avait accès à la _passphrase_ du
    certificat.
    
    Sachant que les accès à la mise à jour des sites se fait maintenant en
    `SFTP`, il a été jugé plus simple de permettre à tous les membres ayant
    accès au serveur de créer de nouveaux accès `SFTP` quitte à ce qu'ils
    puisse créer de nouveaux accès `SSH`.
