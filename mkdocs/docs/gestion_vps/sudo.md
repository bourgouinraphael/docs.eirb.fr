# Utilisation de `sudo`

Une utilisation incorrecte de `sudo` mène généralement à une utilisation non
prévue du serveur (cf [historique de l'architecture](architecture.md#historique-de-larchitecture)).

## Whitelist des programmes disponibles

Il peut y avoir des failles de sécurités liées à l'
[utilisation de wildcard (`*`) dans la configuration de  `sudo`](https://blog.compass-security.com/2012/10/dangerous-sudoers-entries-part-4-wildcards/).

C'est pourquoi, les utilisateurs du groupe `admin` ont accès à une liste
**explicite** de programmes avec `sudo`

Cette liste contient :

* Les scripts du dossier `/opt/eirbware/bin`
* `su`

!!! info "Obtenir cette whitelist"

    Vous pouvez savoir quelles commandes vous pouvez exécuter avec `sudo` en
    exécutant :

    ```sh title="Lister les commandes éxecutable en sudo"
    sudo -l
    ```

Voici comment utiliser `sudo` pour ces deux éléments :

### Utilisation des scripts

Différents scripts sont écrits pour la gestion du VPS d'Eirbware, et sont tous
ajoutés dans la variable `$PATH` des administrateurs, ils doivent tous être
utilisés avec `sudo`.

!!!info "Documentation sur les scripts"

    Seule la façon dont les scripts doivent être exécutés est expliquée ici,
    pour des détails plus précis sur les scripts eux même, référez-vous aux
    autres sections

Pour les utiliser les scripts, exécutez simplement `sudo <script>`, par exemple :

```sh title="Exemple d'exécution du script 'new_site' pour créer pix.eirb.fr"
sudo new_site pix
```

### Utilisation de `su - <user>`

Si une modification doit être faite par un administrateur sur un site, il doit
se **connecter sur le VPS en tant que cet utilisateur**.

Pour ce faire, on utilise la commande `su - <user>`, par exemple :

```sh title="Exemple de connexion en tant que www-pix"
sudo su - www-pix
```

L'utilisation de `sudo` est requise, car le mot de passe pour l'utilisateur
`www-pix` n'est pas connu.

!!!warning "Pourquoi `su -` ?"

    Il est important de conserver les **différentes permissions** mises en place sur le
    serveur.

    La façon la plus simple de le faire est de **ne pas utiliser `sudo` à tort
    et à travers** pour exécuter des commandes en tant que `root`.

    Sur le serveur, si une modification doit être faite, on **essaye dans un
    premier temps** de le faire en tant que l'utilisateur concerné.

### Utilisateur `eirbware`

Malheureusement, tout ne peut pas être prévu. Et il peut être nécessaire
d'exécuter des commandes en tant que `root`.

Pour ce faire, un utilisateur `eirbware` a été créé, vous pouvez vous connecter
en tant qu'`eirbware` en faisant :

```sh title="Exemple de connexion en tant qu'utilisateur eirbware"
sudo su - eirbware
```

Cet utilisateur appartient au groupe `wheel` et peut exécuter `sudo` avec
**tous les programmes sur le VPS** moyennant une mot de passe.

!!!info "Mot de passe du compte `eirbware`"

    Vous pourrez trouver le mot de passe du compte `eirbware` sur
    [le vaultwarden d'Eirbware](https://vault.eirb.fr).

!!!info "Pourquoi ne pas ajouter tous les admins dans `wheel` ?"

    Le but est d'encourager la gestion du VPS comme elle a été pensée, mais de
    laisser un accès complet à `sudo` _pas trop contraignant_ en cas de réel
    besoin.
