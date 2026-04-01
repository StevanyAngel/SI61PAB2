import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_daftar_movie/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIsFavorite();
  }

  Future<void> _checkIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = prefs.containsKey('movie_${widget.movie.id}');
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Memberikan feedback haptic ringan saat ditekan (opsional)
    // HapticFeedback.lightImpact();

    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      final String movieJson = jsonEncode(widget.movie.toJson());
      await prefs.setString('movie_${widget.movie.id}', movieJson);

      List<String> favoriteMovieIds =
          prefs.getStringList('favoriteMovies') ?? [];
      if (!favoriteMovieIds.contains(widget.movie.id.toString())) {
        favoriteMovieIds.add(widget.movie.id.toString());
        await prefs.setStringList('favoriteMovies', favoriteMovieIds);
      }
    } else {
      await prefs.remove('movie_${widget.movie.id}');
      List<String> favoriteMovieIds =
          prefs.getStringList('favoriteMovies') ?? [];
      favoriteMovieIds.remove(widget.movie.id.toString());
      await prefs.setStringList('favoriteMovies', favoriteMovieIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GUNAKAN STACK UNTUK MENUMPUK ICON DI ATAS FOTO
            Stack(
              children: [
                // Widget Utama: Foto Backdrop
                Image.network(
                  widget.movie.backdropPath.isNotEmpty
                      ? 'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}'
                      : 'https://via.placeholder.com/500?text=No+Image',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // 2. GUNAKAN POSITIONED UNTUK MENGATUR LETAK ICON
                Positioned(
                  bottom: 10, // Jarak 10 pixel dari bawah foto
                  right: 10, // Jarak 10 pixel dari kanan foto
                  child: Container(
                    // Memberikan sedikit background gelap transparan agar icon hati terlihat jelas
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 30, // Ukuran icon sedikit diperbesar
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(widget.movie.overview),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(widget.movie.releaseDate),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 10),
                      Text(widget.movie.voteAverage.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}