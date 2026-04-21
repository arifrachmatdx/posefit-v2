class WorkoutHistoryModel {
  final String exerciseTitle;
  final String category;
  final int repetitionCount;
  final String dateTimeText;
  final String durationText;

  WorkoutHistoryModel({
    required this.exerciseTitle,
    required this.category,
    required this.repetitionCount,
    required this.dateTimeText,
    required this.durationText,
  });
}
