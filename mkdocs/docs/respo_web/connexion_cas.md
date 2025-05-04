# Gérer la connexion CAS

Le CAS a **toujours été** un problème très ennuyeux à gérer.

Nous avons essayé de trouver deux solutions pour que la mise en place d'une
connexion CAS soit la **plus simple possible**.

## En utilisant notre `API` "protect"

Si votre site est statique ou est fait en `PHP`, et utilise la configuration
`nginx` par défaut, nous vous conseillons cette solution.

Il s'agit d'un petit serveur `PHP` présent dans toutes les configurations par
défaut, nous proposons une librairie `javascript` pour l'utiliser depuis le
site web.

Pour télécharger la librairie, et avoir plus de documentation au sujet de
protect, allez sur [ce dépôt](https://github.com/Eirbware/protect).

## En utilisant [OpenID](https://openid.net/) avec keycloak ([connect.eirb.fr](https://connect.eirb.fr))

Étant donné que le CAS est assez désagréable à utiliser, et n'est pas
accessible en local, nous avons mis en place un relais d'authentification avec
[keycloak](https://www.keycloak.org/).

Vous pourrez utiliser ce système d'authentification à l'aide de librairies
(OpenID Provider), OpenID [en liste un certain nombre](https://openid.net/developers/certified-openid-connect-implementations/)

Voici une liste plus timide que vous pouvez utiliser :

* PHP : [OpenID-Connect-PHP](https://github.com/jumbojett/OpenID-Connect-PHP)
* JS/TS : [openid-client](https://www.npmjs.com/package/openid-client)

Pour pouvoir vous utiliser OpenID, vous devrez utiliser un secret, vous le
trouverez avec une configuration dans le dossier du site web que vous maintenez.

