import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../models/exercise_detection_result.dart';

class PushUpLogic {
  int pushUpCount = 0;
  bool isLowered = false;

  ExerciseDetectionResult detect(Pose pose) {
    final landmarks = pose.landmarks;

    final leftShoulder = landmarks[PoseLandmarkType.leftShoulder];
    final leftElbow = landmarks[PoseLandmarkType.leftElbow];
    final leftWrist = landmarks[PoseLandmarkType.leftWrist];
    final leftHip = landmarks[PoseLandmarkType.leftHip];
    final leftKnee = landmarks[PoseLandmarkType.leftKnee];
    final leftAnkle = landmarks[PoseLandmarkType.leftAnkle];

    final rightShoulder = landmarks[PoseLandmarkType.rightShoulder];
    final rightElbow = landmarks[PoseLandmarkType.rightElbow];
    final rightWrist = landmarks[PoseLandmarkType.rightWrist];
    final rightHip = landmarks[PoseLandmarkType.rightHip];
    final rightKnee = landmarks[PoseLandmarkType.rightKnee];
    final rightAnkle = landmarks[PoseLandmarkType.rightAnkle];
    final leftShoulderOuter = landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulderOuter = landmarks[PoseLandmarkType.rightShoulder];

    PoseLandmark? shoulder;
    PoseLandmark? elbow;
    PoseLandmark? wrist;
    PoseLandmark? hip;
    PoseLandmark? knee;
    PoseLandmark? ankle;

    final leftSideReady =
        leftShoulder != null &&
        leftElbow != null &&
        leftWrist != null &&
        leftHip != null &&
        leftKnee != null;

    final rightSideReady =
        rightShoulder != null &&
        rightElbow != null &&
        rightWrist != null &&
        rightHip != null &&
        rightKnee != null;

    if (leftSideReady) {
      shoulder = leftShoulder;
      elbow = leftElbow;
      wrist = leftWrist;
      hip = leftHip;
      knee = leftKnee;
      ankle = leftAnkle;
    } else if (rightSideReady) {
      shoulder = rightShoulder;
      elbow = rightElbow;
      wrist = rightWrist;
      hip = rightHip;
      knee = rightKnee;
      ankle = rightAnkle;
    } else {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Posisi tubuh belum lengkap',
        isValidPose: false,
        stage: 'incomplete',
      );
    }

    if (shoulder == null ||
        elbow == null ||
        wrist == null ||
        hip == null ||
        knee == null) {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Posisi tubuh belum lengkap',
        isValidPose: false,
        stage: 'incomplete',
      );
    }

    // Validasi agar push-up hanya dihitung dari samping
    if (leftShoulder != null && rightShoulder != null) {
      final shoulderWidth = _distance(leftShoulder, rightShoulder);
      final sideBodyLength = _distance(shoulder, hip);

      // Jika bahu terlihat terlalu lebar dibanding torso,
      // besar kemungkinan kamera menghadap depan, bukan samping.
      if (shoulderWidth > sideBodyLength * 0.75) {
        return ExerciseDetectionResult(
          repetition: pushUpCount,
          status: 'Arahkan kamera ke samping tubuh',
          isValidPose: false,
          stage: 'front_view',
        );
      }
    }

    final upperArm = _distance(shoulder, elbow);
    final foreArm = _distance(elbow, wrist);
    final fullArm = _distance(shoulder, wrist);
    final torsoLength = _distance(shoulder, hip);
    final thighLength = _distance(hip, knee);

    // Anti false positive saat kamera terlalu dekat / hanya wajah
    if (fullArm < 60 || upperArm < 25 || foreArm < 25) {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Terlalu dekat ke kamera',
        isValidPose: false,
        stage: 'too_close',
      );
    }

    // Anti false positive saat kamera menghadap depan, bukan samping
    // Dari samping, tubuh terlihat memanjang secara vertikal/horizontal dalam satu sisi.
    // Dari depan muka, proporsi torso biasanya terlalu kecil dibanding lengan.
    if (torsoLength < 40 || thighLength < 35) {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Arahkan kamera ke samping tubuh',
        isValidPose: false,
        stage: 'wrong_view',
      );
    }

    final elbowAngle = _calculateAngle(shoulder, elbow, wrist);
    final torsoAngle = _calculateAngle(shoulder, hip, knee);

    final ankleReady = ankle != null;
    double? legAngle;
    if (ankleReady) {
      legAngle = _calculateAngle(hip, knee, ankle!);
    }

    final inPlankPosition =
        torsoAngle > 135 && (legAngle == null || legAngle > 130);

    if (!inPlankPosition) {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Ambil posisi plank',
        isValidPose: false,
        stage: 'plank_invalid',
      );
    }

    if (elbowAngle < 105) {
      isLowered = true;
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Naikkan badan',
        isValidPose: true,
        stage: 'down',
      );
    }

    if (elbowAngle > 145 && isLowered) {
      pushUpCount++;
      isLowered = false;
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Push-up terhitung',
        isValidPose: true,
        stage: 'up',
      );
    }

    if (!isLowered && elbowAngle >= 95 && elbowAngle <= 155) {
      return ExerciseDetectionResult(
        repetition: pushUpCount,
        status: 'Turunkan badan',
        isValidPose: true,
        stage: 'mid',
      );
    }

    return ExerciseDetectionResult(
      repetition: pushUpCount,
      status: 'Pose siap',
      isValidPose: true,
      stage: 'ready',
    );
  }

  double _calculateAngle(PoseLandmark p1, PoseLandmark p2, PoseLandmark p3) {
    final a = _distance(p2, p3);
    final b = _distance(p1, p2);
    final c = _distance(p1, p3);

    if (a == 0 || b == 0) return 0;

    final cosValue = ((b * b + a * a - c * c) / (2 * b * a)).clamp(-1.0, 1.0);
    return acos(cosValue) * (180 / pi);
  }

  double _distance(PoseLandmark p1, PoseLandmark p2) {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
  }

  void reset() {
    pushUpCount = 0;
    isLowered = false;
  }
}
