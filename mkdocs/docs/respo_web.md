# HOWTO être respo web

Si vous vous êtes retrouvé ici, c'est probablement que vous êtes **respo web** pour
un club ou une association (ou peut-être même une _liste ?👀👀_).

Vous trouverez sur cette page **tout ce qu'il faut savoir** pour :

* Demander l'ajout d'un site
* Demander un accès pour mettre à jour un site
* Mettre à jour un site.
* Se connecter au CAS

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

!!! note "Gestionnaires de fichiers testés"

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

```sh title="Exemple de connexion à pixeirb avec sshfs"
sshfs -f eirb_pix: ~/mnt
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


