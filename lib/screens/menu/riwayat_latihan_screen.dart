import 'package:flutter/material.dart';
import '../../models/workout_history_model.dart';
import '../../services/history_service.dart';

class RiwayatLatihanScreen extends StatefulWidget {
  const RiwayatLatihanScreen({super.key});

  @override
  State<RiwayatLatihanScreen> createState() => _RiwayatLatihanScreenState();
}

class _RiwayatLatihanScreenState extends State<RiwayatLatihanScreen> {
  List<WorkoutHistoryModel> historyList = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() {
    historyList = HistoryService.getHistory().reversed.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Latihan'), centerTitle: true),
      body: historyList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat latihan',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final item = historyList[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.history, color: Colors.blue),
                    title: Text(
                      item.exerciseTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Kategori: ${item.category}\n'
                      'Repetisi: ${item.repetitionCount}\n'
                      'Durasi: ${item.durationText}\n'
                      'Waktu: ${item.dateTimeText}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
