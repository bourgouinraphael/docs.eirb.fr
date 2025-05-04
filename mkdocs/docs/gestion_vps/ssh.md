# `SSH` et `SFTP`

## Utilisation de certificats `SSH`

Cela permet notamment de spécifier une durée de validité d'un certificat.

## Utilisation des scripts `cert-*`

Il y a 3 scripts servant à la gestion des accès en `SFTP` aux sites web
d'Eirbware, ils sont :

* `cert_list` : liste les accès `SFTP` existant
* `cert_new` : Créé un accès `SFTP` à un site web pour un nouvel utilisateur
* `cert_revoke` : Révoque un certificat `SSH` pour un site web pour un utilisateur

Pour plus de détails sur leur utilisation, exécutez les différents scripts avec
le flag `-h`.
