import '../models/workout_history_model.dart';

class HistoryService {
  static final List<WorkoutHistoryModel> _historyList = [];

  static List<WorkoutHistoryModel> getHistory() {
    return _historyList;
  }

  static void addHistory(WorkoutHistoryModel history) {
    _historyList.add(history);
  }
}
