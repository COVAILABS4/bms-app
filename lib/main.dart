import 'package:bms/components/homescreen/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

// Define global colors
const Color primaryColor = Color(0xFF007BFF); // Blue
const Color secondaryColor = Color(0xFFFFFFFF); // White

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Request permissions for storage
    Future<void> _requestPermissions() async {
      if (await Permission.storage.isDenied ||
          await Permission.location.isDenied) {
        await Permission.storage.request();
        await Permission.location.request();
      }
      if (await Permission.manageExternalStorage.isDenied) {
        await Permission.manageExternalStorage.request();
      }
      if (await Permission.storage.isPermanentlyDenied) {
        openAppSettings();
      }
    }

    _requestPermissions();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: secondaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: secondaryColor),
          titleTextStyle: const TextStyle(
            color: secondaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          foregroundColor: secondaryColor,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
