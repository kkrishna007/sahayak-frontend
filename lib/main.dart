import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'services/camera_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize cameras when the app starts
    await CameraService.initializeCameras();
  } catch (e) {
    print('Failed to initialize cameras: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sahayak AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SahayakHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
