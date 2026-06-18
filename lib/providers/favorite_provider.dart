import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/movie.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Movie> _favorites = [];
  static const String _favoritesKey = 'favorites_list';

  List<Movie> get favorites => _favorites;

  FavoriteProvider() {
    _loadFavoritesFromLocal();
  }

  Future<void> _loadFavoritesFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson != null && favoritesJson.isNotEmpty) {
        final List<dynamic> decodedList = json.decode(favoritesJson);
        _favorites = decodedList
            .map((item) => Movie.fromJson(item as Map<String, dynamic>))
            .toList();
        notifyListeners();
        print('Loaded ${_favorites.length} favorites from local storage');
      } else {
        _favorites = [];
        print('ℹNo favorites found in local storage');
      }
    } catch (e) {
      print('Error loading favorites: $e');
      _favorites = [];
    }
  }

  Future<void> _saveFavoritesToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> favoritesMapList = 
          _favorites.map((movie) => movie.toJson()).toList();
      final String jsonString = json.encode(favoritesMapList);
      await prefs.setString(_favoritesKey, jsonString);
      print('Saved ${_favorites.length} favorites to local storage');
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  Future<void> toggleFavorite(Movie movie) async {
    final isExist = _favorites.any((m) => m.id == movie.id);

    if (isExist) {
      _favorites.removeWhere((m) => m.id == movie.id);
      print('Removed from favorites: ${movie.title}');
    } else {
      _favorites.add(movie);
      print('Added to favorites: ${movie.title}');
    }

    await _saveFavoritesToLocal();
    notifyListeners();
  }

  bool isFavorite(int movieId) {
    return _favorites.any((movie) => movie.id == movieId);
  }

  Future<void> clearAllFavorites() async {
    _favorites.clear();
    await _saveFavoritesToLocal();
    notifyListeners();
    print('All favorites cleared');
  }

  Future<void> refreshFavorites() async {
    await _loadFavoritesFromLocal();
  }
}