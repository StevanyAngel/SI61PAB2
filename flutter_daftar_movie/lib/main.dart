import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_daftar_movie/main_screen.dart';

// 1. WAJIB ADA: Fungsi main sebagai pintu masuk aplikasi
void main() {
  runApp(const MyApp());
}

// 2. Class Utama yang menjalankan MaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 3. Tambahkan ini agar mouse bisa digunakan untuk geser/scroll di emulator
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      // 4. Arahkan home ke MainScreen (bukan HomeScreen)
      home: const MainScreen(),
    );
  }
}
