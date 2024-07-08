import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson73/firebase_options.dart';
import 'package:lesson73/services/location_service.dart';
import 'package:lesson73/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // PermissionStatus cameraPermission = await Permission.camera.status;
  // PermissionStatus locationPermission = await Permission.location.status;
  // print(cameraPermission);
  // if (cameraPermission != PermissionStatus.granted) {
  //   await Permission.camera.request();
  //   print(cameraPermission);
  // }
  // if (locationPermission != PermissionStatus.granted) {
  //   await Permission.location.request();
  // }
  // if (!(await Permission.camera.request().isGranted) ||
  //     !(await Permission.location.request().isGranted)) {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.location,
  //     Permission.camera,
  //   ].request();
  //   print(statuses);
  // }

  await LocationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
