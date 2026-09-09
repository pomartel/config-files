---
name: convert-pptx-to-marp
description: Convertir une présentation PowerPoint en présentation Marp en reconstruisant ses diapositives, en extrayant les médias utiles et en conservant les liens et vidéos pertinents.
---

# Convertir un PPTX en Marp

Utiliser ce skill lorsqu’un fichier `.pptx` doit devenir un fichier Marp `.slides.md`.

## Résultat attendu

- Créer `nom-de-la-presentation.slides.md` en minuscules ASCII, avec des tirets.
- Placer les médias conservés dans `assets/`, avec des noms descriptifs en minuscules ASCII.
- Produire une diapositive Marp par diapositive PowerPoint comme point de départ, mais diviser une diapositive trop chargée si cela améliore la lisibilité.
- Préserver le contenu, les liens et les vidéos utiles sans inventer de décoration.

## Procédure

1. Inventorier le PPTX avec `unzip -l` et extraire le texte des `ppt/slides/slide*.xml`.
2. Inspecter les relations des diapositives pour repérer les liens externes et les vidéos.
3. Extraire seulement les images utilisées dans le résultat final vers `assets/`, puis les renommer significativement.
4. Créer le fichier avec ce frontmatter :

   ```md
   ---
   marp: true
   theme: basic
   paginate: true
   title: Titre de la présentation
   footer: Titre de la présentation
   ---
   ```

5. Ajouter une diapositive titre avec cette convention lorsque le projet l’utilise :

   ```md
   <!-- _class: title -->

   # Titre de la présentation

   Objectif : ...
   ```

6. Reconstruire chaque diapositive en Markdown : titres courts, puces concises et ordre de lecture clair. Utiliser `<!-- _class: fullscreen -->` pour une image ou une vidéo plein écran.
7. Pour les images, utiliser `![bg contain](./assets/...)` pour une image pleine page et `![right width:...](./assets/...)` pour une image à droite. Adapter la largeur, généralement entre `350px` et `640px`, selon le contenu. Conserver les formats utiles, notamment `.svg`, `.png`, `.jpg`, `.jpeg`, `.webp` et `.avif`.
8. Représenter une vidéo par un iframe YouTube dans une section `fullscreen` si le rendu Marp le permet; accepter un iframe avec attributs `width` et `height` ou avec un style `position:absolute`. Sinon fournir un lien Markdown vers la vidéo.
9. Utiliser un langage dans les clôtures de blocs de code lorsque c’est pertinent, par exemple ` ```bash `, ` ```python ` ou ` ```text `.
10. N’ajouter la classe `compact` que si elle existe dans le style du document et si le contenu le justifie. Ne pas ajouter de fonds ou d’éléments décoratifs non présents dans la source.
11. Omettre une diapositive purement décorative ou sans valeur pédagogique si elle n’est pas nécessaire; conserver les schémas, organigrammes, images et informations importantes.
12. Supprimer les médias extraits mais non référencés et vérifier les chemins relatifs.
13. Après chaque modification du fichier `.slides.md`, régénérer immédiatement le HTML avec la commande suivante, exécutée depuis la racine du projet :

   ```bash
   /home/po/Projects/markdown/scripts/convert_md chemin/vers/nom-de-la-presentation.slides.md
   ```

   La commande produit le HTML dans `_build/` et peut synchroniser le résultat. Après la génération, vérifier les débordements, les titres trop longs et les diapositives trop chargées, puis recommencer cette boucle après toute correction.

## Conventions d’écriture

- Conserver les accents dans le texte, mais jamais dans les noms de fichiers.
- Employer la ponctuation française et les guillemets `« »` dans le texte courant.
- Utiliser la casse phrase pour les titres.
- Ne pas supprimer les sources, liens ou mentions importantes sans demande explicite.
