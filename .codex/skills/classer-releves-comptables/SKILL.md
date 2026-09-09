---
name: classer-releves-comptables
description: Classe les relevés comptables mensuels déposés dans Downloads vers les dossiers Dropbox correspondants, avec renommage au numéro du mois et validation avant déplacement.
---

# Classer les relevés comptables

Utiliser cette skill lorsque l’utilisateur demande de classer les relevés mensuels actuellement dans `/home/po/Downloads`.

## Règles de classement

Le dossier racine est `/home/po/Dropbox/Documents/Finances/Comptabilité`.
Déduire l’année et le mois en lisant le contenu des PDF, pas seulement leur nom. Le mois doit être formaté sur deux chiffres (`01` à `12`). Les destinations et noms sont fixes :

| Document identifié | Destination | Nom final |
|---|---|---|
| Code Rubik — relevé bancaire CAD | `Code Rubik/2026/relevés bancaires/CAD` | `MM.pdf` |
| Code Rubik — relevé bancaire USD | `Code Rubik/2026/relevés bancaires/USD` | `MM.pdf` |
| Code Rubik — relevé Visa CAD (carte se terminant par 3007) | `Code Rubik/2026/relevés visa/CAD` | `MM.pdf` |
| Code Rubik — relevé Visa USD (compte se terminant par 0892) | `Code Rubik/2026/relevés visa/USD` | `MM.pdf` |
| Code Rubik — relevé PayPal (`pomartel@coderubik.com`) | `Code Rubik/2026/relevés paypal` | `MM.PDF` |
| Gestion Pierre Olivier Martel — relevé bancaire CAD | `Gestion POM/2026/Relevés bancaires/CAD` | `MM.pdf` |
| Gestion Pierre Olivier Martel — relevé bancaire USD | `Gestion POM/2026/Relevés bancaires/USD` | `MM.pdf` |

Remplacer `2026` par l’année détectée lorsque les dossiers correspondants existent. Ne pas inventer de destination pour un document qui ne correspond pas clairement à une règle.

## Procédure obligatoire

1. Inventorier les fichiers PDF directement dans `Downloads`.
2. Extraire le texte et les métadonnées utiles de chaque PDF (`pdftotext`, `pdfinfo` ou équivalent) afin d’identifier entité, type, devise, période et mois.
3. Vérifier que les dossiers cibles existent et qu’aucun fichier cible du même nom n’existe.
4. Présenter un tableau complet source → destination → nom final et attendre la confirmation explicite de l’utilisateur.
5. Après confirmation, déplacer les fichiers avec leurs noms finaux; ne pas copier et ne pas supprimer d’autres fichiers.
6. Vérifier les tailles ou l’existence des fichiers déplacés et confirmer que les sources ont disparu de `Downloads`.

En cas de période, entité, devise ou destination ambiguë, laisser le fichier en place et le signaler. Ne jamais utiliser `autorename` ni écraser un fichier existant sans instruction explicite.

Les opérations locales peuvent utiliser les chemins absolus ci-dessus. Si les fichiers sont déjà des objets Dropbox gérés par le connecteur, utiliser l’opération Dropbox de déplacement prévue à cet effet.
