import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final bool isFrontCamera;

  PosePainter({
    required this.poses,
    required this.imageSize,
    required this.isFrontCamera,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pointPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final pose in poses) {
      final landmarks = pose.landmarks;

      for (final landmark in landmarks.values) {
        double x = landmark.x * size.width / imageSize.width;
        double y = landmark.y * size.height / imageSize.height;

        if (isFrontCamera) {
          x = size.width - x;
        }

        canvas.drawCircle(Offset(x, y), 4, pointPaint);
      }

      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.rightShoulder,
        size,
        linePaint,
      );
      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftElbow,
        size,
        linePaint,
      );
      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.leftElbow,
        PoseLandmarkType.leftWrist,
        size,
        linePaint,
      );
      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightElbow,
        size,
        linePaint,
      );
      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.rightElbow,
        PoseLandmarkType.rightWrist,
        size,
        linePaint,
      );

      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftHip,
        size,
        linePaint,
      );
      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightHip,
        size,
        linePaint,
      );
      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.leftHip,
        PoseLandmarkType.rightHip,
        size,
        linePaint,
      );

      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.leftHip,
        PoseLandmarkType.leftKnee,
        size,
        linePaint,
      );
      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.leftKnee,
        PoseLandmarkType.leftAnkle,
        size,
        linePaint,
      );
      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightKnee,
        size,
        linePaint,
      );
      _drawLine(
        canvas,
        landmarks,
        PoseLandmarkType.rightKnee,
        PoseLandmarkType.rightAnkle,
        size,
        linePaint,
      );
    }
  }

  void _drawLine(
    Canvas canvas,
    Map<PoseLandmarkType, PoseLandmark> landmarks,
    PoseLandmarkType type1,
    PoseLandmarkType type2,
    Size size,
    Paint paint,
  ) {
    final p1 = landmarks[type1];
    final p2 = landmarks[type2];

    if (p1 == null || p2 == null) return;

    double x1 = p1.x * size.width / imageSize.width;
    double y1 = p1.y * size.height / imageSize.height;
    double x2 = p2.x * size.width / imageSize.width;
    double y2 = p2.y * size.height / imageSize.height;

    if (isFrontCamera) {
      x1 = size.width - x1;
      x2 = size.width - x2;
    }

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return true;
  }
}
