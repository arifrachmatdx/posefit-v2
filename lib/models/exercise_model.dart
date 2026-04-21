import 'package:flutter/material.dart';

enum ExerciseType { pushUp, squat, jumpingJack, plank, highKnees }

class ExerciseModel {
  final String title;
  final String category;
  final String imagePath;
  final Color color;
  final ExerciseType type;
  final int targetRepetition;
  final int targetDurationInSeconds;

  ExerciseModel({
    required this.title,
    required this.category,
    required this.imagePath,
    required this.color,
    required this.type,
    required this.targetRepetition,
    required this.targetDurationInSeconds,
  });
}
