import 'package:flutter/material.dart';
import '../../models/exercise_model.dart';
import '../detection/detection_screen.dart';

class ListGerakanScreen extends StatefulWidget {
  final String category;

  const ListGerakanScreen({super.key, required this.category});

  @override
  State<ListGerakanScreen> createState() => _ListGerakanScreenState();
}

class _ListGerakanScreenState extends State<ListGerakanScreen> {
  final List<ExerciseModel> allExercises = [
    ExerciseModel(
      title: 'Push Up',
      category: 'Upper Body',
      imagePath: '',
      color: Colors.blue,
      type: ExerciseType.pushUp,
      targetRepetition: 10,
      targetDurationInSeconds: 60,
    ),
    ExerciseModel(
      title: 'Plank',
      category: 'Upper Body',
      imagePath: '',
      color: Colors.indigo,
      type: ExerciseType.plank,
      targetRepetition: 1,
      targetDurationInSeconds: 30,
    ),
    ExerciseModel(
      title: 'Squat',
      category: 'Lower Body',
      imagePath: '',
      color: Colors.green,
      type: ExerciseType.squat,
      targetRepetition: 15,
      targetDurationInSeconds: 60,
    ),
    ExerciseModel(
      title: 'High Knees',
      category: 'Lower Body',
      imagePath: '',
      color: Colors.teal,
      type: ExerciseType.highKnees,
      targetRepetition: 20,
      targetDurationInSeconds: 45,
    ),
    ExerciseModel(
      title: 'Jumping Jack',
      category: 'Cardio',
      imagePath: '',
      color: Colors.orange,
      type: ExerciseType.jumpingJack,
      targetRepetition: 20,
      targetDurationInSeconds: 60,
    ),
    ExerciseModel(
      title: 'Plank Stretch',
      category: 'Flexibility',
      imagePath: '',
      color: Colors.purple,
      type: ExerciseType.plank,
      targetRepetition: 1,
      targetDurationInSeconds: 30,
    ),
  ];

  List<ExerciseModel> filteredExercises = [];

  @override
  void initState() {
    super.initState();
    filteredExercises = allExercises
        .where((exercise) => exercise.category == widget.category)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Gerakan - ${widget.category}'),
        centerTitle: true,
      ),
      body: filteredExercises.isEmpty
          ? const Center(
              child: Text(
                'Belum ada gerakan pada kategori ini',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: exercise.color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size: 32,
                    ),
                    title: Text(
                      exercise.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      exercise.category,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetectionScreen(exercise: exercise),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
