class ExerciseDetectionResult {
  final int repetition;
  final String status;
  final bool isValidPose;
  final String stage;

  const ExerciseDetectionResult({
    required this.repetition,
    required this.status,
    required this.isValidPose,
    required this.stage,
  });

  factory ExerciseDetectionResult.initial() {
    return const ExerciseDetectionResult(
      repetition: 0,
      status: 'Belum ada gerakan',
      isValidPose: false,
      stage: 'idle',
    );
  }
}
