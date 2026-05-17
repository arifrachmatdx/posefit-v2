// Mengimport Flutter Material UI
import 'package:flutter/material.dart';

// Mengimport ML Kit Pose Detection
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// =====================================================
// POSE PAINTER
// =====================================================

// CustomPainter digunakan untuk menggambar skeleton pose
// di atas preview kamera
class PosePainter extends CustomPainter {
  // List pose yang terdeteksi oleh ML Kit
  final List<Pose> poses;

  // Ukuran gambar asli dari kamera
  final Size imageSize;

  // Penanda apakah kamera yang digunakan adalah kamera depan
  final bool isFrontCamera;

  // Constructor
  PosePainter({
    required this.poses,
    required this.imageSize,
    required this.isFrontCamera,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Paint untuk menggambar titik landmark
    final pointPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    // Paint untuk menggambar garis antar landmark
    final linePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Loop semua pose yang terdeteksi
    for (final pose in poses) {
      // Mengambil semua landmark tubuh
      final landmarks = pose.landmarks;

      // =================================================
      // MENGGAMBAR TITIK LANDMARK
      // =================================================

      // Loop semua titik landmark
      for (final landmark in landmarks.values) {
        // Mengubah posisi x dari ukuran image ke ukuran canvas
        double x = landmark.x * size.width / imageSize.width;

        // Mengubah posisi y dari ukuran image ke ukuran canvas
        double y = landmark.y * size.height / imageSize.height;

        // Jika kamera depan, posisi x dibalik agar sesuai preview
        if (isFrontCamera) {
          x = size.width - x;
        }

        // Menggambar titik landmark
        canvas.drawCircle(Offset(x, y), 4, pointPaint);
      }

      // =================================================
      // MENGGAMBAR GARIS BAGIAN BAHU DAN TANGAN
      // =================================================

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

      // =================================================
      // MENGGAMBAR GARIS BADAN / TORSO
      // =================================================

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

      // =================================================
      // MENGGAMBAR GARIS KAKI
      // =================================================

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

  // =====================================================
  // FUNGSI MENGGAMBAR GARIS ANTAR LANDMARK
  // =====================================================

  void _drawLine(
    Canvas canvas,
    Map<PoseLandmarkType, PoseLandmark> landmarks,
    PoseLandmarkType type1,
    PoseLandmarkType type2,
    Size size,
    Paint paint,
  ) {
    // Mengambil landmark pertama
    final p1 = landmarks[type1];

    // Mengambil landmark kedua
    final p2 = landmarks[type2];

    // Jika salah satu titik tidak ada, garis tidak digambar
    if (p1 == null || p2 == null) return;

    // Mengubah posisi titik pertama ke ukuran canvas
    double x1 = p1.x * size.width / imageSize.width;
    double y1 = p1.y * size.height / imageSize.height;

    // Mengubah posisi titik kedua ke ukuran canvas
    double x2 = p2.x * size.width / imageSize.width;
    double y2 = p2.y * size.height / imageSize.height;

    // Jika kamera depan, posisi x dibalik
    if (isFrontCamera) {
      x1 = size.width - x1;
      x2 = size.width - x2;
    }

    // Menggambar garis dari titik pertama ke titik kedua
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    // true artinya canvas akan digambar ulang
    // setiap kali ada perubahan pose
    return true;
  }
}
