---
name: convert-word-to-markdown
description: Convertir un document Word en Markdown en préservant sa structure, ses médias et son HTML inline lorsque nécessaire.
---

# Convertir un document Word en Markdown

Utiliser ce skill lorsqu’un fichier `.docx` doit devenir un document Markdown destiné au projet de cours.

## Résultat attendu

- Créer `nom-du-document.html.md` en minuscules ASCII, avec des tirets.
- Commencer le fichier par un frontmatter contenant `title:` et reprendre le titre principal du document.
- Ne pas modifier le contenu du document : préserver le texte, l’ordre, les informations et le sens. Adapter uniquement la structure et la mise en forme nécessaires au Markdown, sauf demande explicite.
- Conserver la structure du document : titres, paragraphes, listes, tableaux, citations, liens et blocs de code.
- Placer les images conservées dans `assets/`, avec des noms descriptifs en minuscules ASCII.

## Procédure

1. Examiner le document Word et repérer son titre, ses niveaux de titres, ses listes, ses tableaux, ses liens et ses images.
2. Convertir avec Pandoc :

   ```bash
   pandoc "Document.docx" -f docx -t gfm+raw_html --wrap=preserve --extract-media="assets" -o "nom-du-document.html.md"
   ```

   Utiliser `--extract-media="assets"` seulement si le document contient des images à conserver.
3. Ajouter ou corriger le frontmatter :

   ```md
   ---
   title: Titre du document
   ---
   ```

4. Normaliser le Markdown : titres avec une hiérarchie cohérente, listes lisibles, tableaux correctement alignés et liens fonctionnels.
5. Placer les commandes dans des blocs `bash`, les sorties ou invites dans des blocs `text`, et conserver le langage des autres blocs de code lorsqu’il est connu.
6. Préserver le HTML inline utile, notamment `<u>...</u>` pour les avertissements ou les éléments soulignés explicitement présents dans la source.
7. Mettre à jour les chemins des images vers `./assets/...`, supprimer les médias extraits mais non utilisés et vérifier les noms de fichiers.
8. Après chaque modification du fichier `.html.md`, régénérer le HTML depuis la racine du projet :

   ```bash
   /home/po/Projects/markdown/scripts/convert_md chemin/vers/nom-du-document.html.md
   ```

9. Vérifier le HTML généré dans `_build/` : titres, listes, tableaux, liens, images, blocs de code et éléments HTML inline. Corriger puis régénérer après chaque modification.

## Conventions observées dans les cours

- Utiliser l’extension `.html.md`, et non `.md.html`.
- Utiliser des titres en casse phrase et des noms de fichiers ASCII.
- Conserver les accents dans le contenu du document.
- Utiliser `« »` pour les citations françaises et respecter la ponctuation française.
- Ne pas supprimer les sources, liens ou mentions importantes sans demande explicite.
- Ne pas corriger, reformuler, résumer ou compléter le contenu sans demande explicite.
- Ne pas ajouter de contenu, d’images ou de décoration qui n’existaient pas dans le document source.
