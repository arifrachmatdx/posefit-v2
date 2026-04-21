import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseDetectorService {
  final PoseDetector poseDetector = PoseDetector(
    options: PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      model: PoseDetectionModel.accurate,
    ),
  );

  Future<List<Pose>> processImage(InputImage inputImage) async {
    return await poseDetector.processImage(inputImage);
  }

  void dispose() {
    poseDetector.close();
  }
}
