import 'package:flutter/material.dart';

// Paramètres pour les catégories de sports
class SportCategory {
  final String name;
  final Color backgroundColor;
  final double borderRadius;

  SportCategory({
    required this.name,
    required this.backgroundColor,
    required this.borderRadius,
  });
}

// Liste des catégories de sports avec leurs propriétés
final List<SportCategory> sportCategories = [
  SportCategory(
    name: 'Football',
    backgroundColor: Colors.green, // Vert pour le football
    borderRadius: 20.0,
  ),
  SportCategory(
    name: 'Basketball',
    backgroundColor: Colors.orange, // Orange pour le basketball
    borderRadius: 20.0,
  ),
  SportCategory(
    name: 'Tennis',
    backgroundColor: Colors.blue, // Bleu pour le tennis
    borderRadius: 20.0,
  ),
  SportCategory(
    name: 'Handball',
    backgroundColor: Colors.red, // Rouge pour le handball
    borderRadius: 20.0,
  ),
  // Vous pouvez ajouter d'autres sports ici
];

// Paramètres pour les catégories de terrain
class FieldType {
  final String name;
  final Color backgroundColor;

  FieldType({
    required this.name,
    required this.backgroundColor,
  });
}

// Liste des tailles de terrain avec leurs propriétés
final List<FieldType> fieldTypes = [
  FieldType(
    name: 'A5',
    backgroundColor: Colors.brown, // Jaune pour A5
  ),
  FieldType(
    name: 'A7',
    backgroundColor: Colors.blue, // Bleu pour A7
  ),
  FieldType(
    name: 'A9',
    backgroundColor: Colors.purple, // Violet pour A9
  ),
  FieldType(
    name: 'A11',
    backgroundColor: Colors.red, // Rouge pour A11
  ),
];
