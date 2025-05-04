# Conseil de la part d'Eirbware

Il existe aujourd'hui beaucoup de technologies pour créer des sites web, et il
y a de quoi se demander "Quelle technologie devrais-je utiliser ?".

Voici quelques conseils que nous avons à vous partager en prenant en compte le
système associatif de l'ENSEIRB.

!!! info "Contrainte principale de l'associatif"

    Les clubs et les associations de l'ENSEIRB changent de membres
    **tous les ans**, il est primordiale de s'assurer que le mandat suivant
    puisse **maintenir le site**.

## Considérez le vanilla

Considérez de faire votre site en HTML/CSS/JS vanilla, voici les avantages :

* S'il y a un respo web dans le prochain mandat, il maitrisera les technologies
* Pas besoin d'avoir un dépôt git pour stocker les sources

Cependant, écrire un code _scalable_ en vanilla n'est pas trivial,
notamment pour l'écriture du `CSS`. Il est conseillé d'utiliser la
[convention BEM](https://getbem.com) pour s'en sortir en écrivant ce genre de
site.

## Si le vanilla vous fait peur

L'avantage du vanilla est qu'il est _censé_ être un prérequis aux autres
technologies web, ce qui le rend universel. Le maintenir peut tout de même être
pénible.

Voici des notes à propos des alternatives.

!!! warning "La contrepartie très importante"

    Un site qui n'est pas fait en vanilla, nécessite d'être compilé !

    La version sur [eirb.fr](https://eirb.fr) **ne peut donc pas suffire** à une
    passation, un **dépôt git et des instructions de compilations** doivent
    être transmise au prochain mandat pour que le site soit **maintenable**.

!!! info "Conseil pour gérer un dépôt git"

    Considérez la création d'une [organisation github](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch),
    cela permet de simplifier une passation : il n'y a plus qu'à changer le
    propriétaire de l'organisation

### Le cas Typescript

Le manque de typage en javascript est **clairement** ennuyeux, et l'utilisation
de [typescript](https://www.typescriptlang.org) est clairement intéressant.

### Les frameworks CSS

Les frameworks comme [tailwindCSS](https://tailwindcss.com) et
[bootstrap](https://getbootstrap.com) se comprend : cela permet de gérer le
responsive plus facilement, et d'accélérer la phase de développement.

Voici une [liste _assez imposante_ de frameworks](https://github.com/troxler/awesome-css-frameworks).

### Les frameworks JS

En derniers viennent les frameworks JS, faire un site en
[React](https://react.dev/) est tentant, mais on a toujours la même
problématique : tout le monde ne connait pas React.

### Générateurs de sites statiques

En fonction du besoin, les générateurs de sites statiques (comme
[Material for mkdocs](https://squidfunk.github.io/mkdocs-material) utilisé pour
le site sur lequel vous êtes) peut être une **très bonne solution**.

Ils permettent de générer un site web en vous **concentrant sur le contenu**.

## Technologies pour un backend

Si vous avez **absolument** besoin d'un backend, vous pouvez utiliser la
technologie que vous voulez, car tous les sites sont conteneurisés.

Cependant, comme dit précédemment, potentiellement **personne ne pourra
maintenir le site** dans le futur.

!!! warning "Considérez notre API `protect` d'abord"

    L'API que nous proposons avec `protect` permet quelques fonctionnalités
    avec une connexion CAS, peut-être que c'est suffisant pour vos besoins.

    Peut-être que votre besoin peut être rajouté à `protect`, si votre besoin
    est proche de ce que cette API propose, considérez d'en parler à Eirbware
    pour que ça soit rajouté.

Si vous avez besoin d'un backend, nous vous conseillons :

* De garder le backend le plus simple possible
* Pour une base de donnée, restez sur [postgres](https://www.postgresql.org/) ou [sqlite](https://www.sqlite.org/)
* Restez sur du SQL, c'est étudié en cours, pas [mongodb](https://www.mongodb.com/), ni [redis](https://redis.io/)
* D'utiliser git pour versionner le code, et le transmettre aux passations

Pour ce qui est des technologies pour un backend, nous vous conseillons :

* [NodeJS](https://nodejs.org) & [ExpressJS](https://expressjs.com/), ce framework est basique et permet d'être plus maintenable
* [Flask](https://flask.palletsprojects.com) en python, idem, simple donc maintenable même avec peu de connaissances

