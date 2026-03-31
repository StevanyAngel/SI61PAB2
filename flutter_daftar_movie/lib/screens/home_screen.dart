import 'package:flutter/material.dart';
import 'package:flutter_daftar_movie/models/movie.dart';
import 'package:flutter_daftar_movie/screens/detail_screen.dart';
import 'package:flutter_daftar_movie/screens/favorite_screen.dart'; // Import halaman favorit
import 'package:flutter_daftar_movie/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  int _selectedIndex = 0; // Index untuk navigasi

  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final List<Map<String, dynamic>> allMoviesData = await _apiService
        .getAllMovies();
    final List<Map<String, dynamic>> trendingMoviesData = await _apiService
        .getTrendingMovies();
    final List<Map<String, dynamic>> popularMoviesData = await _apiService
        .getPopularMovies();

    setState(() {
      _allMovies = allMoviesData.map((e) => Movie.fromJson(e)).toList();
      _trendingMovies = trendingMoviesData
          .map((e) => Movie.fromJson(e))
          .toList();
      _popularMovies = popularMoviesData.map((e) => Movie.fromJson(e)).toList();
    });
  }

  // Widget untuk konten utama Home
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoviesList('All Movies', _allMovies),
          _buildMoviesList('Trending Movies', _trendingMovies),
          _buildMoviesList('Popular Movies', _popularMovies),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // List halaman yang akan ditampilkan berdasarkan index navigasi
    final List<Widget> _pages = [
      _buildHomeContent(),
      const FavoriteScreen(), // Halaman favorit yang sudah kita buat sebelumnya
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Film'),
        // Tambahkan tombol cepat ke favorit di AppBar juga jika mau
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              setState(() {
                _selectedIndex = 1; // Pindah ke tab favorit
              });
            },
          ),
        ],
      ),
      // Body akan berubah sesuai tab yang dipilih
      body: _pages[_selectedIndex],

      // TAMBAHKAN NAVIGASI DI BAWAH INI
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220, // Sedikit ditinggikan agar teks tidak terpotong
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = movies[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(movie: movie),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        // Tambahkan sedikit lengkungan pada gambar
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          height: 150,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 100,
                        child: Text(
                          movie.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
