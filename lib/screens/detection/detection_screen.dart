import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/exercise_model.dart';
import '../menu/hasil_latihan_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetectionScreen extends StatefulWidget {
  final ExerciseModel exercise;

  const DetectionScreen({super.key, required this.exercise});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int repetitionCount = 0;
  int elapsedSeconds = 0;
  int countdown = 5;
  int remainingSeconds = 0;

  bool isWorkoutStarted = false;
  bool isWorkoutFinished = false;
  bool isCameraInitialized = false;
  bool isCountingDown = true;

  String detectionStatus = "Bersiap memulai latihan";
  String countdownText = "5";

  CameraController? cameraController;
  Timer? stopwatchTimer;
  Timer? countdownTimer;
  Timer? workoutTimer;

  @override
  void initState() {
    super.initState();

    initializeCamera();

    remainingSeconds = widget.exercise.targetDurationInSeconds;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.4).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    startCountdown();
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

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (countdown > 1) {
        setState(() {
          countdown--;
          countdownText = "$countdown";
          detectionStatus = "Latihan dimulai dalam $countdown";
        });
        _animationController.forward(from: 0);
      } else if (countdown == 1) {
        setState(() {
          countdown = 0;
          countdownText = "GO!";
          detectionStatus = "Latihan dimulai";
        });
      } else {
        timer.cancel();

        setState(() {
          isCountingDown = false;
          isWorkoutStarted = true;
        });

        startStopwatch();
        startWorkoutTimer();
      }
    });
  }

  void startWorkoutTimer() {
    workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || isWorkoutFinished) return;

      setState(() {
        remainingSeconds--;
      });

      if (remainingSeconds <= 0) {
        finishWorkout();
      }
    });
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

  Future<void> saveWorkoutToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance.collection('workout_history').add({
      "userId": user.uid,
      "exerciseTitle": widget.exercise.title,
      "category": widget.exercise.category,
      "repetition": repetitionCount,
      "duration": elapsedSeconds,
      "date": Timestamp.now(),
    });
  }

  void tambahRepetisiDummy() {
    if (!isWorkoutStarted) return;
    if (isWorkoutFinished) return;

    setState(() {
      repetitionCount++;
      detectionStatus = "Gerakan terdeteksi";
    });
  }

  Future<void> finishWorkout() async {
    if (isWorkoutFinished) return;

    isWorkoutFinished = true;

    stopwatchTimer?.cancel();
    workoutTimer?.cancel();

    await saveWorkoutToFirestore();

    if (!mounted) return;

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
    countdownTimer?.cancel();
    stopwatchTimer?.cancel();
    workoutTimer?.cancel();
    cameraController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressText =
        '$repetitionCount / ${widget.exercise.targetRepetition}';

    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.title), centerTitle: true),
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
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CameraPreview(cameraController!),

                            if (isCountingDown)
                              Container(
                                color: Colors.black.withOpacity(0.35),
                                child: Center(
                                  child: ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: Text(
                                      countdownText,
                                      style: const TextStyle(
                                        fontSize: 90,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// REPS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Repetisi",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "$repetitionCount",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    /// PROGRESS
                    LinearProgressIndicator(
                      value:
                          (elapsedSeconds /
                                  widget.exercise.targetDurationInSeconds)
                              .clamp(0.0, 1.0),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    /// TIMER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Sisa Waktu",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatDuration(remainingSeconds),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    /// STATUS
                    Row(
                      children: [
                        const Text(
                          "Status: ",
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
                    if (isWorkoutStarted)
                      ElevatedButton(
                        onPressed: tambahRepetisiDummy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        child: const Text("Tambah Repetisi (Test)"),
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
