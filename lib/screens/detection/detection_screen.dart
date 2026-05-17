// Mengimport library async untuk menggunakan Timer
import 'dart:async';

// Mengimport package camera untuk mengakses kamera perangkat
import 'package:camera/camera.dart';

// Mengimport Flutter Material untuk membuat UI
import 'package:flutter/material.dart';

// Mengimport main.dart untuk mengambil list kamera global
import '../../main.dart';

// Mengimport model exercise
import '../../models/exercise_model.dart';

// Mengimport halaman hasil latihan
import '../menu/hasil_latihan_screen.dart';

// Mengimport Firestore untuk menyimpan riwayat latihan
import 'package:cloud_firestore/cloud_firestore.dart';

// Mengimport Firebase Auth untuk mengambil user yang sedang login
import 'package:firebase_auth/firebase_auth.dart';

// Mengimport foundation untuk debugPrint dan WriteBuffer
import 'package:flutter/foundation.dart';

// Mengimport ML Kit Pose Detection
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

// Mengimport service pose detector
import '../../logic/pose_detector_service.dart';

// Mengimport painter untuk menggambar skeleton pose
import '../../widgets/pose_painter.dart';

// Mengimport model hasil deteksi gerakan
import '../../models/exercise_detection_result.dart';

// Halaman untuk mendeteksi gerakan workout
class DetectionScreen extends StatefulWidget {
  // Data exercise yang dipilih dari halaman sebelumnya
  final ExerciseModel exercise;

  // Constructor DetectionScreen
  const DetectionScreen({super.key, required this.exercise});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

// State dari halaman DetectionScreen
class _DetectionScreenState extends State<DetectionScreen>
    with SingleTickerProviderStateMixin {
  // Controller untuk animasi countdown
  late AnimationController _animationController;

  // Animasi scale untuk memperbesar/memperkecil text countdown
  late Animation<double> _scaleAnimation;

  // Service untuk memproses pose detection dan exercise logic
  final PoseDetectorService _poseService = PoseDetectorService();

  // Penanda agar tidak memproses banyak frame kamera sekaligus
  bool _isProcessing = false;

  // Menyimpan daftar pose yang terdeteksi
  List<Pose> _poses = [];

  // Menyimpan ukuran gambar dari kamera
  Size _imageSize = Size.zero;

  // Jumlah repetisi yang terdeteksi
  int repetitionCount = 0;

  // Waktu latihan yang sudah berjalan dalam detik
  int elapsedSeconds = 0;

  // Hitungan mundur sebelum latihan dimulai
  int countdown = 5;

  // Sisa waktu latihan
  int remainingSeconds = 0;

  // Hasil awal deteksi exercise
  ExerciseDetectionResult _exerciseResult = ExerciseDetectionResult.initial();

  // Menandakan apakah workout sudah dimulai
  bool isWorkoutStarted = false;

  // Menandakan apakah workout sudah selesai
  bool isWorkoutFinished = false;

  // Menandakan apakah kamera sudah siap digunakan
  bool isCameraInitialized = false;

  // Menandakan apakah countdown sedang berjalan
  bool isCountingDown = true;

  // Status yang ditampilkan ke user
  String detectionStatus = "Bersiap memulai latihan";

  // Text countdown yang ditampilkan di layar
  String countdownText = "5";

  // Controller kamera
  CameraController? cameraController;

  // Timer untuk stopwatch waktu berjalan
  Timer? stopwatchTimer;

  // Timer untuk countdown sebelum mulai
  Timer? countdownTimer;

  // Timer untuk menghitung sisa waktu latihan
  Timer? workoutTimer;

  @override
  void initState() {
    super.initState();

    // Menginisialisasi kamera saat halaman dibuka
    initializeCamera();

    // Mengisi sisa waktu berdasarkan target durasi exercise
    remainingSeconds = widget.exercise.targetDurationInSeconds;

    // Reset data exercise sebelum mulai latihan
    _poseService.resetExercise(widget.exercise.type);

    // Membuat controller animasi
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Membuat animasi scale untuk countdown
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.4).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Menjalankan animasi pertama kali
    _animationController.forward();

    // Memulai countdown
    startCountdown();
  }

  // Fungsi untuk menginisialisasi kamera
  Future<void> initializeCamera() async {
    try {
      // Jika tidak ada kamera tersedia
      if (cameras.isEmpty) {
        setState(() {
          detectionStatus = 'Tidak ada kamera tersedia';
        });
        return;
      }

      // Mengambil kamera depan
      // Jika kamera depan tidak ada, gunakan kamera pertama
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      // Membuat CameraController
      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      // Mengaktifkan kamera
      await cameraController!.initialize();

      // Memulai stream gambar dari kamera secara realtime
      await cameraController!.startImageStream((CameraImage image) {
        processCameraImage(image);
      });

      // Jika widget sudah tidak aktif, hentikan proses
      if (!mounted) return;

      // Update status kamera
      setState(() {
        isCameraInitialized = true;
        detectionStatus = 'Kamera depan aktif';
      });
    } catch (e) {
      // Jika widget sudah tidak aktif, hentikan proses
      if (!mounted) return;

      // Jika kamera gagal dibuka
      setState(() {
        detectionStatus = 'Gagal membuka kamera';
      });
    }
  }

  // Fungsi untuk memulai countdown sebelum workout
  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Jika widget sudah tidak aktif, hentikan proses
      if (!mounted) return;

      // Jika countdown masih lebih dari 1
      if (countdown > 1) {
        setState(() {
          countdown--;
          countdownText = "$countdown";
          detectionStatus = "Latihan dimulai dalam $countdown";
        });

        // Menjalankan ulang animasi countdown
        _animationController.forward(from: 0);
      } else if (countdown == 1) {
        // Saat countdown mencapai 1, tampilkan GO
        setState(() {
          countdown = 0;
          countdownText = "GO!";
          detectionStatus = "Latihan dimulai";
        });
      } else {
        // Menghentikan timer countdown
        timer.cancel();

        // Menandakan workout sudah dimulai
        setState(() {
          isCountingDown = false;
          isWorkoutStarted = true;
        });

        // Memulai stopwatch dan timer workout
        startStopwatch();
        startWorkoutTimer();
      }
    });
  }

  // Fungsi untuk menghitung sisa waktu latihan
  void startWorkoutTimer() {
    workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Jika widget tidak aktif atau workout selesai, hentikan proses
      if (!mounted || isWorkoutFinished) return;

      // Kurangi sisa waktu setiap detik
      setState(() {
        remainingSeconds--;
      });

      // Jika waktu habis, selesaikan workout
      if (remainingSeconds <= 0) {
        finishWorkout();
      }
    });
  }

  // Fungsi untuk menghitung waktu latihan yang sudah berjalan
  void startStopwatch() {
    stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Jika widget tidak aktif atau workout selesai, hentikan proses
      if (!mounted || isWorkoutFinished) return;

      // Tambah elapsed time setiap detik
      setState(() {
        elapsedSeconds++;
      });
    });
  }

  // Fungsi untuk mengubah detik menjadi format MM:SS
  String formatDuration(int totalSeconds) {
    // Mengambil jumlah menit
    final minutes = totalSeconds ~/ 60;

    // Mengambil sisa detik
    final seconds = totalSeconds % 60;

    // Format menit menjadi 2 digit
    final minuteText = minutes.toString().padLeft(2, '0');

    // Format detik menjadi 2 digit
    final secondText = seconds.toString().padLeft(2, '0');

    // Mengembalikan format waktu
    return '$minuteText:$secondText';
  }

  // Fungsi untuk mengubah CameraImage menjadi InputImage ML Kit
  InputImage? _convertCameraImage(CameraImage image) {
    try {
      // Mengambil deskripsi kamera yang sedang digunakan
      final camera = cameraController?.description;

      // Jika kamera null, hentikan proses
      if (camera == null) return null;

      // Mengambil rotasi gambar berdasarkan sensor kamera
      final rotation = InputImageRotationValue.fromRawValue(
        camera.sensorOrientation,
      );

      // Jika rotasi tidak didukung
      if (rotation == null) return null;

      // Mengambil format gambar
      final format = InputImageFormatValue.fromRawValue(image.format.raw);

      // Jika format tidak didukung
      if (format == null) return null;

      // Menggabungkan semua bytes dari tiap plane gambar
      final WriteBuffer allBytes = WriteBuffer();

      // Loop setiap plane gambar
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }

      // Mengubah bytes menjadi Uint8List
      final bytes = allBytes.done().buffer.asUint8List();

      // Membuat metadata untuk ML Kit
      final metadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      // Mengembalikan InputImage yang siap diproses ML Kit
      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      // Menampilkan error di debug console
      debugPrint('convert image error: $e');

      return null;
    }
  }

  // Fungsi untuk memproses frame dari kamera
  Future<void> processCameraImage(CameraImage image) async {
    // Jangan proses gambar jika workout belum mulai atau sudah selesai
    if (!isWorkoutStarted || isWorkoutFinished) return;

    // Jika sedang memproses frame sebelumnya, jangan proses frame baru
    if (_isProcessing) return;

    // Tandai bahwa sistem sedang memproses frame
    _isProcessing = true;

    try {
      // Debug format gambar kamera
      debugPrint('raw image format: ${image.format.raw}');
      debugPrint('planes length: ${image.planes.length}');

      // Convert CameraImage menjadi InputImage
      final inputImage = _convertCameraImage(image);

      // Jika gagal convert image
      if (inputImage == null) {
        if (mounted) {
          setState(() {
            detectionStatus = 'Format gambar tidak didukung';
          });
        }
        return;
      }

      // Proses gambar menggunakan ML Kit Pose Detection
      final poses = await _poseService.processImage(inputImage);

      // Jika widget sudah tidak aktif, hentikan proses
      if (!mounted) return;

      // Jika pose terdeteksi
      if (poses.isNotEmpty) {
        // Proses pose sesuai jenis exercise
        final result = _poseService.processExercise(
          exerciseType: widget.exercise.type,
          pose: poses.first,
        );

        // Update data hasil deteksi
        setState(() {
          _poses = poses;
          _imageSize = Size(image.width.toDouble(), image.height.toDouble());

          _exerciseResult = result;
          repetitionCount = result.repetition;
          detectionStatus = result.status;
        });
      } else {
        // Jika tidak ada pose terdeteksi
        setState(() {
          _poses = [];
          _imageSize = Size(image.width.toDouble(), image.height.toDouble());
          detectionStatus = 'Tidak ada pose';
        });
      }
    } catch (e) {
      // Menampilkan error di debug console
      debugPrint('pose detection error: $e');

      // Jika widget sudah tidak aktif, hentikan proses
      if (!mounted) return;

      // Tampilkan status error
      setState(() {
        detectionStatus = 'Error deteksi pose';
      });
    } finally {
      // Setelah selesai, izinkan frame berikutnya diproses
      _isProcessing = false;
    }
  }

  // Fungsi untuk menyimpan hasil workout ke Firestore
  Future<void> saveWorkoutToFirestore() async {
    // Mengambil user yang sedang login
    final user = FirebaseAuth.instance.currentUser;

    // Jika tidak ada user login, jangan simpan data
    if (user == null) return;

    // Menyimpan data riwayat workout ke collection workout_history
    await FirebaseFirestore.instance.collection('workout_history').add({
      "userId": user.uid,
      "exerciseTitle": widget.exercise.title,
      "category": widget.exercise.category,
      "repetition": repetitionCount,
      "duration": elapsedSeconds,
      "date": Timestamp.now(),
    });
  }

  // Fungsi dummy untuk menambah repetisi secara manual
  // Biasanya dipakai untuk testing
  void tambahRepetisiDummy() {
    // Jika workout belum mulai, jangan tambah repetisi
    if (!isWorkoutStarted) return;

    // Jika workout sudah selesai, jangan tambah repetisi
    if (isWorkoutFinished) return;

    // Tambahkan repetisi
    setState(() {
      repetitionCount++;
      detectionStatus = "Gerakan terdeteksi";
    });
  }

  // Fungsi untuk menyelesaikan workout
  Future<void> finishWorkout() async {
    // Jika workout sudah selesai, jangan jalankan lagi
    if (isWorkoutFinished) return;

    // Tandai workout selesai
    isWorkoutFinished = true;

    // Hentikan stopwatch
    stopwatchTimer?.cancel();

    // Hentikan timer workout
    workoutTimer?.cancel();

    // Simpan hasil workout ke Firestore
    await saveWorkoutToFirestore();

    // Jika widget sudah tidak aktif, hentikan proses
    if (!mounted) return;

    // Pindah ke halaman hasil latihan
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
    // Hentikan countdown timer
    countdownTimer?.cancel();

    // Hentikan stopwatch timer
    stopwatchTimer?.cancel();

    // Hentikan workout timer
    workoutTimer?.cancel();

    // Matikan kamera
    cameraController?.dispose();

    // Matikan animation controller
    _animationController.dispose();

    // Matikan pose detector service
    _poseService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Text progress repetisi
    final progressText =
        '$repetitionCount / ${widget.exercise.targetRepetition}';

    return Scaffold(
      // AppBar menampilkan judul exercise
      appBar: AppBar(title: Text(widget.exercise.title), centerTitle: true),

      // SafeArea agar UI tidak tertutup notch/status bar
      body: SafeArea(
        child: Column(
          children: [
            // Bagian kamera
            Expanded(
              flex: 8,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                width: double.infinity,

                // Dekorasi container kamera
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                ),

                // Jika kamera sudah siap, tampilkan preview kamera
                child:
                    isCameraInitialized &&
                        cameraController != null &&
                        cameraController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),

                        // LayoutBuilder digunakan agar tampilan menyesuaikan ukuran layar
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Mengambil ukuran preview kamera
                            final previewSize =
                                cameraController!.value.previewSize!;

                            return FittedBox(
                              // Kamera dibuat memenuhi area container
                              fit: BoxFit.cover,

                              child: SizedBox(
                                width: previewSize.height,
                                height: previewSize.width,

                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Menampilkan preview kamera
                                    CameraPreview(cameraController!),

                                    // Jika pose terdeteksi, gambar skeleton di atas kamera
                                    if (_poses.isNotEmpty)
                                      CustomPaint(
                                        painter: PosePainter(
                                          poses: _poses,
                                          imageSize: Size(
                                            previewSize.height,
                                            previewSize.width,
                                          ),

                                          // Mengecek apakah kamera yang digunakan adalah kamera depan
                                          isFrontCamera:
                                              cameraController!
                                                  .description
                                                  .lensDirection ==
                                              CameraLensDirection.front,
                                        ),
                                      ),

                                    // Overlay countdown sebelum latihan dimulai
                                    if (isCountingDown)
                                      Container(
                                        color: Colors.black.withOpacity(0.35),

                                        child: Center(
                                          child: ScaleTransition(
                                            scale: _scaleAnimation,

                                            child: Text(
                                              countdownText,
                                              style: TextStyle(
                                                fontSize: 90,
                                                fontWeight: FontWeight.bold,

                                                // Warna hijau saat text GO
                                                color: countdownText == 'GO!'
                                                    ? Colors.greenAccent
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    // Jika kamera belum siap, tampilkan loading
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),

            // Bagian informasi workout
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                padding: const EdgeInsets.all(16),

                // Dekorasi panel informasi
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Baris informasi repetisi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Repetisi",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        // Menampilkan jumlah repetisi
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

                    // Progress bar berdasarkan waktu berjalan
                    LinearProgressIndicator(
                      value:
                          (elapsedSeconds /
                                  widget.exercise.targetDurationInSeconds)
                              .clamp(0.0, 1.0),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    // Baris sisa waktu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Sisa Waktu",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        // Menampilkan sisa waktu
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

                    // Baris status deteksi
                    Row(
                      children: [
                        const Text(
                          "Status: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        // Expanded agar text status tidak overflow
                        Expanded(
                          child: Text(
                            detectionStatus,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Tombol dummy untuk testing repetisi
                    // Bisa diaktifkan jika ingin mengetes tanpa pose detection
                    // if (isWorkoutStarted)
                    //   ElevatedButton(
                    //     onPressed: tambahRepetisiDummy,
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.blue,
                    //       minimumSize: const Size(double.infinity, 45),
                    //     ),
                    //     child: const Text("Tambah Repetisi (Test)"),
                    //   ),
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
