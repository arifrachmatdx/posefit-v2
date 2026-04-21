import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedExercises() async {
  final exercises = [
    {
      "id": "push_up",
      "title": "Push Up",
      "category": "Upper Body",
      "type": "pushUp",
      "targetRepetition": 10,
      "targetDurationInSeconds": 60,
      "isActive": true,
    },
    {
      "id": "plank",
      "title": "Plank",
      "category": "Upper Body",
      "type": "plank",
      "targetRepetition": 1,
      "targetDurationInSeconds": 30,
      "isActive": true,
    },
    {
      "id": "squat",
      "title": "Squat",
      "category": "Lower Body",
      "type": "squat",
      "targetRepetition": 15,
      "targetDurationInSeconds": 60,
      "isActive": true,
    },
    {
      "id": "high_knees",
      "title": "High Knees",
      "category": "Cardio",
      "type": "highKnees",
      "targetRepetition": 20,
      "targetDurationInSeconds": 45,
      "isActive": true,
    },
    {
      "id": "jumping_jack",
      "title": "Jumping Jack",
      "category": "Cardio",
      "type": "jumpingJack",
      "targetRepetition": 20,
      "targetDurationInSeconds": 60,
      "isActive": true,
    },
    {
      "id": "stretch_plank",
      "title": "Stretch Plank",
      "category": "Flexibility",
      "type": "plank",
      "targetRepetition": 1,
      "targetDurationInSeconds": 30,
      "isActive": true,
    },
  ];

  for (var exercise in exercises) {
    final id = exercise["id"];
    final data = Map<String, dynamic>.from(exercise);
    data.remove("id");

    await FirebaseFirestore.instance
        .collection("exercises")
        .doc(id as String)
        .set(data);
  }

  print("Exercises berhasil diupload");
}
