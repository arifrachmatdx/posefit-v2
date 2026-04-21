import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PushUpLogic {
  bool isDown = false;
  int repetition = 0;

  double calculateAngle(
    PoseLandmark first,
    PoseLandmark mid,
    PoseLandmark last,
  ) {
    final radians =
        atan2(last.y - mid.y, last.x - mid.x) -
        atan2(first.y - mid.y, first.x - mid.x);

    double angle = radians * 180 / pi;
    angle = angle.abs();

    if (angle > 180) {
      angle = 360 - angle;
    }

    return angle;
  }

  int detect(Pose pose) {
    final shoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final elbow = pose.landmarks[PoseLandmarkType.leftElbow];
    final wrist = pose.landmarks[PoseLandmarkType.leftWrist];

    if (shoulder == null || elbow == null || wrist == null) {
      return repetition;
    }

    final elbowAngle = calculateAngle(shoulder, elbow, wrist);

    if (elbowAngle < 90) {
      isDown = true;
    }

    if (elbowAngle > 160 && isDown) {
      isDown = false;
      repetition++;
    }

    return repetition;
  }
}
