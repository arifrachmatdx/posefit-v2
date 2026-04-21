class ExerciseDetectionResult {
  final int repetition;
  final String status;

  const ExerciseDetectionResult({
    required this.repetition,
    required this.status,
  });

  factory ExerciseDetectionResult.initial() {
    return const ExerciseDetectionResult(
      repetition: 0,
      status: 'Belum ada gerakan',
    );
  }
}
