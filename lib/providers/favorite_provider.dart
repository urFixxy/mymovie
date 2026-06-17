import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Movie> _favorites = [];

  List<Movie> get favorites => _favorites;

  FavoriteProvider() {
    loadFavorites();
  }

  bool isFavorite(int movieId) {
    return _favorites.any(
      (movie) => movie.id == movieId,
    );
  }

  Future<void> toggleFavorite(
      Movie movie) async {
    if (isFavorite(movie.id)) {
      _favorites.removeWhere(
        (m) => m.id == movie.id,
      );
    } else {
      _favorites.add(movie);
    }

    await saveFavorites();
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs =
        await SharedPreferences.getInstance();

    final encoded = _favorites
        .map(
          (movie) => jsonEncode({
            'id': movie.id,
            'title': movie.title,
            'overview': movie.overview,
            'poster_path': movie.posterPath,
            'vote_average': movie.rating,
            'release_date': movie.releaseDate,
          }),
        )
        .toList();

    await prefs.setStringList(
      'favorites',
      encoded,
    );
  }

  Future<void> loadFavorites() async {
    final prefs =
        await SharedPreferences.getInstance();

    final stored =
        prefs.getStringList('favorites');

    if (stored != null) {
      _favorites.clear();

      _favorites.addAll(
        stored.map(
          (e) => Movie.fromJson(
            jsonDecode(e),
          ),
        ),
      );

      notifyListeners();
    }
  }
}