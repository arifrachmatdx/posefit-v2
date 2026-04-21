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
        return _pushUpLogic.detect(pose);

      case ExerciseType.squat:
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika squat belum dipasang',
          isValidPose: false,
          stage: 'idle',
        );

      case ExerciseType.jumpingJack:
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika jumping jack belum dipasang',
          isValidPose: false,
          stage: 'idle',
        );

      case ExerciseType.plank:
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika plank belum dipasang',
          isValidPose: false,
          stage: 'idle',
        );

      case ExerciseType.highKnees:
        return const ExerciseDetectionResult(
          repetition: 0,
          status: 'Logika high knees belum dipasang',
          isValidPose: false,
          stage: 'idle',
        );
    }
  }

  void resetExercise(ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.pushUp:
        _pushUpLogic.reset();
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
