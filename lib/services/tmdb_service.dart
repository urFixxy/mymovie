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
      headers: {
        'Authorization': 'Bearer ${ApiConfig.bearerToken}',
      },
    );

    final data = jsonDecode(response.body);

    return (data['results'] as List)
        .map((e) => Movie.fromJson(e))
        .toList();
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/search/movie?api_key=${ApiConfig.apiKey}&query=$query',
      ),
      headers: {
        'Authorization': 'Bearer ${ApiConfig.bearerToken}',
      },
    );

    final data = jsonDecode(response.body);

    return (data['results'] as List)
        .map((e) => Movie.fromJson(e))
        .toList();
  }
}
