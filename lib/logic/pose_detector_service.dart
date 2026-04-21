import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../models/exercise_model.dart';
import '../models/exercise_detection_result.dart';
import 'exercises/pushup_logic.dart';

class PoseDetectorService {
  final PoseDetector poseDetector = PoseDetector(
    options: PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      model: PoseDetectionModel.accurate,
    ),
  );

  final PushUpLogic _pushUpLogic = PushUpLogic();

  Future<List<Pose>> processImage(InputImage inputImage) async {
    return await poseDetector.processImage(inputImage);
  }

  ExerciseDetectionResult processExercise({
    required ExerciseType exerciseType,
    required Pose pose,
  }) {
    switch (exerciseType) {
      case ExerciseType.pushUp:
        final repetition = _pushUpLogic.detect(pose);
        return ExerciseDetectionResult(
          repetition: repetition,
          status: _pushUpLogic.isDown
              ? 'Posisi bawah push-up'
              : 'Push-up terdeteksi',
        );

      case ExerciseType.squat:
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika squat belum dipasang',
        );

      case ExerciseType.jumpingJack:
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika jumping jack belum dipasang',
        );

      case ExerciseType.plank:
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika plank belum dipasang',
        );

      case ExerciseType.highKnees:
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika high knees belum dipasang',
        );
    }
  }

  void resetExercise(ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.pushUp:
        _pushUpLogic.isDown = false;
        _pushUpLogic.repetition = 0;
        break;

      case ExerciseType.squat:
      case ExerciseType.jumpingJack:
      case ExerciseType.plank:
      case ExerciseType.highKnees:
        break;
    }
  }

  void dispose() {
    poseDetector.close();
  }
}
