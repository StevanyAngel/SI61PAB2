import 'package:flutter/material.dart';
import 'package:flutter_daftar_movie/models/movie.dart';
import 'package:flutter_daftar_movie/screens/detail_screen.dart';
import 'package:flutter_daftar_movie/services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

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

    if (mounted) {
      setState(() {
        _allMovies = allMoviesData.map((e) => Movie.fromJson(e)).toList();
        _trendingMovies = trendingMoviesData
            .map((e) => Movie.fromJson(e))
            .toList();
        _popularMovies = popularMoviesData
            .map((e) => Movie.fromJson(e))
            .toList();
      });
    }
  }

  // 1. KONTEN UTAMA HOME SEKARANG LANGSUNG DIUBAH MENJADI SCROLL VIEW
  @override
  Widget build(BuildContext context) {
    // Agar AppBar 'Film' tetap ada di atas, kita gunakan Scaffold minimalis tanpa BottomNav
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film'), // Judul di AppBar atas (image_3.png)
        elevation: 0,
      ),
      // Di sinilah kombinasi Scroll Vertikal dan Horizontal berada
      body: SingleChildScrollView(
        // physics: BouncingScrollPhysics agar scroll lancar
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoviesList('All Movies', _allMovies),
            _buildMoviesList('Trending Movies', _trendingMovies),
            _buildMoviesList('Popular Movies', _popularMovies),
            const SizedBox(
              height: 30,
            ), // Ruang ekstra di bawah agar tidak tumpuk dengan nav bar
          ],
        ),
      ),
    );
  }

  // Widget List Film Horizontal (Dipertahankan)
  Widget _buildMoviesList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal, // Memungkinkan geser ke samping
            itemCount: movies.length,
            // physics: BouncingScrollPhysics agar geser lancar
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = movies[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          height: 150,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 100,
                                height: 150,
                                color: Colors.grey[300],
                              ),
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
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
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
