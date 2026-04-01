import 'package:flutter/material.dart';
import 'package:flutter_daftar_movie/screens/home_screen.dart';
import 'package:flutter_daftar_movie/screens/search_screen.dart';
import 'package:flutter_daftar_movie/screens/favorite_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Index untuk menentukan halaman mana yang aktif
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai index
  final List<Widget> _screens = [
    const HomeScreen(), // Index 0
    const SearchScreen(), // Index 1
    const FavoriteScreen(), // Index 2
  ];

  // Fungsi untuk menangani perpindahan tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan berubah otomatis saat _selectedIndex berubah
      body: _screens[_selectedIndex],

      // BottomNavigationBar yang bersih (Tanpa kotak pink yang menumpuk)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Menjaga agar icon tidak bergeser
        backgroundColor: Colors.white, // Latar belakang putih bersih
        selectedItemColor: Colors.deepPurple, // Warna saat aktif (sesuai theme)
        unselectedItemColor: Colors.grey, // Warna saat tidak aktif
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
