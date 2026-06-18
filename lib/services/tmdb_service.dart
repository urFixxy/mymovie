import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../config/api_config.dart';

class TMDbService {
  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/movie/popular?api_key=${ApiConfig.apiKey}',
        ),
        headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Popular movies loaded: ${data['results']?.length ?? 0}');
        
        return (data['results'] as List)
            .map((e) => Movie.fromTMDb(e))
            .toList();
      } else {
        print('Failed to load popular movies: ${response.statusCode}');
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error getting popular movies: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/search/movie?api_key=${ApiConfig.apiKey}&query=$query',
        ),
        headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Search results for "$query": ${data['results']?.length ?? 0}');
        
        // ===== PERBAIKAN: Gunakan fromTMDb =====
        return (data['results'] as List)
            .map((e) => Movie.fromTMDb(e))
            .toList();
      } else {
        print('Failed to search movies: ${response.statusCode}');
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error searching movies: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Movie> getMovieDetail(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/movie/$movieId?api_key=${ApiConfig.apiKey}',
        ),
        headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Movie detail loaded: ${data['title']}');
        
        // ===== PERBAIKAN: Gunakan fromTMDb =====
        return Movie.fromTMDb(data);
      } else {
        print('Failed to load movie detail: ${response.statusCode}');
        throw Exception('Failed to load movie detail');
      }
    } catch (e) {
      print('Error getting movie detail: $e');
      throw Exception('Error: $e');
    }
  }

  Future<String?> getTrailerKey(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/movie/$movieId/videos?api_key=${ApiConfig.apiKey}',
        ),
        headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final trailer = (data['results'] as List).firstWhere(
          (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
          orElse: () => null,
        );

        final key = trailer?['key'];
        print('Trailer key: $key');
        return key;
      } else {
        print('Failed to get trailer: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting trailer: $e');
      return null;
    }
  }

  Future<List<Movie>> getRelatedMovies(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/movie/$movieId/similar?api_key=${ApiConfig.apiKey}',
        ),
        headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Related movies loaded: ${data['results']?.length ?? 0}');
        
        return (data['results'] as List)
            .map((e) => Movie.fromTMDb(e))
            .toList();
      } else {
        print('Failed to load related movies: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting related movies: $e');
      return [];
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/discover/movie?api_key=${ApiConfig.apiKey}&with_genres=$genreId',
        ),
        headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Movies by genre loaded: ${data['results']?.length ?? 0}');
        
        return (data['results'] as List)
            .map((e) => Movie.fromTMDb(e))
            .toList();
      } else {
        print('❌ Failed to load movies by genre: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error getting movies by genre: $e');
      return [];
    }
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/movie/now_playing?api_key=${ApiConfig.apiKey}',
        ),
        headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Now playing movies loaded: ${data['results']?.length ?? 0}');
        
        return (data['results'] as List)
            .map((e) => Movie.fromTMDb(e))
            .toList();
      } else {
        print('Failed to load now playing movies: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting now playing movies: $e');
      return [];
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/movie/top_rated?api_key=${ApiConfig.apiKey}',
        ),
        headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Top rated movies loaded: ${data['results']?.length ?? 0}');
        
        return (data['results'] as List)
            .map((e) => Movie.fromTMDb(e))
            .toList();
      } else {
        print('Failed to load top rated movies: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting top rated movies: $e');
      return [];
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/movie/upcoming?api_key=${ApiConfig.apiKey}',
        ),
        headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Upcoming movies loaded: ${data['results']?.length ?? 0}');
        
        return (data['results'] as List)
            .map((e) => Movie.fromTMDb(e))
            .toList();
      } else {
        print('Failed to load upcoming movies: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error getting upcoming movies: $e');
      return [];
    }
  }
}