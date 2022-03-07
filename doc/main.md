---
authors: Guillaume Allain (info@guillaumealla.in)
docstyle: ga-min
title: Organisation des données scientifiques avec HDF5 et Pandas
bibliography: bibliography.bib
---

# Introduction

## Objectifs de la présentation

Fournir un exemple de workflow fonctionnel pour l'aggrégation, l'organisation et le stockage de grande quantité de donnée qui est accessible et simple à implémenter.

## Défis de la programmation scientifiques

-   Taille des données importantes
-   Acquisitions et écriture rapides des données
-   Dans des conditions souvent moins controlées (à l'extérieur du laboratoire)
-   Doit pouvoir facilement faire des calculs et des analyses sur les données
-   Partage des données

## Bases de données traditionnelles

-   SQL
-   MongoDB

Bien quelles sont très bien supportée par les revendeurs de service en ligne (AWS par exemple) et les systèmes de serveurs traditionnels, ils sont relativement lents et peu adaptés à la structure des solutions logicielles en science. Bien qu'ils sont simples à utiliser, il peut être difficile de partager la base de données à des collaborateurs qui s'y connaissent moins (sans avoir à héberger la base de donnée par exemple).

Les besoins en machine learning pour stocker et lire les données sont très spécifiques. Elles sont souvent basées sur SQL ou des bases de données traditionnelles. Elles sont par contre mésadaptées aux besoins généraux qui sont spécifiées plus haut.

# Outils

## HDF5

HDF5 @hdf5 est un format de fichier hierarchique qui s'apparente à la structure d'un dictionnaire sur python. Les données sont décrites dans des groupes qui ressemblent à des fichiers dans des sous-dossiers sur un disque. Bien que ces données peuvent être n'importe quel type d'objet, le format est plus confortable pour gérer les données de type array. Beaucoup plus rapide que les fichiers de données traditionnels.

## Pandas

Pandas @reback2020pandas est une librairie qui permet la gestion des données de façon hiérarchique, de façon similaire à ce qu'un tableau excel permettrait. Il y a une très bonne gestion des données manquantes et permet de faire des calculs rapides sur les données (de façon similaire à Numpy pour les tableaux de données). Simple à utiliser et excessivement bien documenté.
