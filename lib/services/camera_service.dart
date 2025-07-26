import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CameraService {
  static List<CameraDescription>? _cameras;
  static CameraController? _controller;

  /// Initialize cameras
  static Future<void> initializeCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      throw Exception('Failed to initialize cameras: $e');
    }
  }

  /// Get available cameras
  static List<CameraDescription>? get cameras => _cameras;

  /// Initialize camera controller
  static Future<CameraController> initializeController({
    CameraDescription? camera,
    ResolutionPreset resolution = ResolutionPreset.high,
  }) async {
    if (_cameras == null || _cameras!.isEmpty) {
      await initializeCameras();
    }

    if (_cameras == null || _cameras!.isEmpty) {
      throw Exception('No cameras available');
    }

    // Use provided camera or default to first available camera
    final selectedCamera = camera ?? _cameras!.first;

    _controller = CameraController(
      selectedCamera,
      resolution,
      enableAudio: false,
    );

    await _controller!.initialize();
    return _controller!;
  }

  /// Take a picture and return the file
  static Future<File> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      // Get the directory to store the image
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String dirPath = path.join(appDir.path, 'attendance_photos');
      await Directory(dirPath).create(recursive: true);

      // Create unique filename
      final String fileName =
          'attendance_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(dirPath, fileName);

      // Take the picture
      final XFile picture = await _controller!.takePicture();

      // Copy to our directory
      final File savedImage = await File(picture.path).copy(filePath);

      // Clean up temporary file
      await File(picture.path).delete();

      return savedImage;
    } catch (e) {
      throw Exception('Failed to take picture: $e');
    }
  }

  /// Get camera preview widget
  static Widget getCameraPreview() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return CameraPreview(_controller!);
  }

  /// Check if camera is initialized
  static bool get isInitialized =>
      _controller != null && _controller!.value.isInitialized;

  /// Dispose camera controller
  static Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }

  /// Switch camera (front/back)
  static Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) {
      throw Exception('Cannot switch camera - insufficient cameras available');
    }

    if (_controller == null) {
      throw Exception('Camera controller not initialized');
    }

    final currentCamera = _controller!.description;
    CameraDescription newCamera;

    // Find the opposite camera
    if (currentCamera.lensDirection == CameraLensDirection.back) {
      newCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );
    } else {
      newCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );
    }

    // Dispose current controller and initialize new one
    await _controller!.dispose();
    await initializeController(camera: newCamera);
  }

  /// Get camera flash modes
  static List<FlashMode> get availableFlashModes => [
        FlashMode.off,
        FlashMode.auto,
        FlashMode.always,
      ];

  /// Set flash mode
  static Future<void> setFlashMode(FlashMode flashMode) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }
    await _controller!.setFlashMode(flashMode);
  }

  /// Get current flash mode
  static FlashMode? get currentFlashMode => _controller?.value.flashMode;
}
