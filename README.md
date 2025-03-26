# Eirbware mkdocs

Ceci est le dépôt de [docs.eirb.fr](https://docs.eirb.fr), le but est de
documenter les comment fonctionne Eirbware, et surtout le pourquoi Eirbware
fonctionne de cette façon.

## Développement

Ce dépôt propose un fichier `docker-compose.yml`, il sert **uniquement au
développement et à la compilation**. Le but étant de ne pas avoir à installer
`mkdocs` pour pouvoir contribuer à ce dépôt.

### Démarrer le serveur de développement

`mkdocs` propose un serveur de **développement**, il peut être démarré en
faisant :

```sh
docker compose up -d
```

### Modifications du site

Après avoir lancé le serveur de développement, il suffit de modifier les fichiers
markdown du dossier `mkdocs`.

## Production

Comme énoncé précédemment, le serveur proposé par mkdocs n'est pas fait pour un
environnement de production. Le site doit être compilé puis servi statiquement
par un serveur comme nginx.

### Compilation

Afin de compiler le site pour la production, faites :

```sh
make build
```

### Déploiement

Normalement, il suffit d'uploader en SFTP le site compilé dans le dossier
`~www-docs/nginx/www` sur le serveur d'Eirbware.
