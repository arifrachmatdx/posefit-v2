import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/exercise_model.dart';
import '../../models/workout_history_model.dart';
import '../../services/history_service.dart';
import '../menu/hasil_latihan_screen.dart';

class DetectionScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const DetectionScreen({super.key, required this.exercise});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  int repetitionCount = 0;
  String detectionStatus = 'Kamera belum aktif';

  CameraController? cameraController;
  bool isCameraInitialized = false;

  Timer? stopwatchTimer;
  int elapsedSeconds = 0;
  bool isWorkoutFinished = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    startStopwatch();
  }

  Future<void> initializeCamera() async {
    try {
      if (cameras.isEmpty) {
        setState(() {
          detectionStatus = 'Tidak ada kamera tersedia';
        });
        return;
      }

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();

      if (!mounted) return;

      setState(() {
        isCameraInitialized = true;
        detectionStatus = 'Kamera aktif';
      });
    } catch (e) {
      setState(() {
        detectionStatus = 'Gagal membuka kamera: $e';
      });
    }
  }

  void startStopwatch() {
    stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || isWorkoutFinished) return;

      setState(() {
        elapsedSeconds++;
      });
    });
  }

  String formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    final minuteText = minutes.toString().padLeft(2, '0');
    final secondText = seconds.toString().padLeft(2, '0');

    return '$minuteText:$secondText';
  }

  void tambahRepetisiDummy() {
    if (isWorkoutFinished) return;

    setState(() {
      repetitionCount++;
      detectionStatus = 'Gerakan benar terdeteksi';
    });

    checkWorkoutCompletion();
  }

  void checkWorkoutCompletion() {
    if (repetitionCount >= widget.exercise.targetRepetition) {
      finishWorkout();
    }
  }

  void finishWorkout() {
    if (isWorkoutFinished) return;

    isWorkoutFinished = true;
    stopwatchTimer?.cancel();

    final now = DateTime.now();

    final history = WorkoutHistoryModel(
      exerciseTitle: widget.exercise.title,
      category: widget.exercise.category,
      repetitionCount: repetitionCount,
      dateTimeText:
          '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
      durationText: formatDuration(elapsedSeconds),
    );

    HistoryService.addHistory(history);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HasilLatihanScreen(
          exercise: widget.exercise,
          repetitionCount: repetitionCount,
          durationText: formatDuration(elapsedSeconds),
        ),
      ),
    );
  }

  @override
  void dispose() {
    stopwatchTimer?.cancel();
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressText =
        '$repetitionCount / ${widget.exercise.targetRepetition}';

    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.title), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: tambahRepetisiDummy,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    isCameraInitialized &&
                        cameraController != null &&
                        cameraController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CameraPreview(cameraController!),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Repetisi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          progressText,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    LinearProgressIndicator(
                      value: repetitionCount / widget.exercise.targetRepetition,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Waktu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatDuration(elapsedSeconds),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            detectionStatus,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
