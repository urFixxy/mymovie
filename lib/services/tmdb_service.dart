import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../config/api_config.dart';

class TMDbService {
  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/movie/popular?api_key=${ApiConfig.apiKey}',
      ),
      headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/search/movie?api_key=${ApiConfig.apiKey}&query=$query',
      ),
      headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Movie> getMovieDetail(int movieId) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/movie/$movieId?api_key=${ApiConfig.apiKey}',
      ),
      headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Movie.fromJson(data);
    }

    throw Exception('Failed to load movie detail');
  }

  Future<String?> getTrailerKey(int movieId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/movie/$movieId/videos'),
      headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final trailer = (data['results'] as List).firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );

      return trailer?['key'];
    }

    return null;
  }

  Future<List<Movie>> getRelatedMovies(int movieId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/movie/$movieId/similar'),
      headers: {'Authorization': 'Bearer ${ApiConfig.bearerToken}'},
    );

    final data = jsonDecode(response.body);

    return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
  }
}
