import 'package:flutter/material.dart';

import '../screens/common/trailer_screen.dart';
import '../services/tmdb_service.dart';

class TrailerHelper {
  static Future<void> playTrailer({
    required BuildContext context,
    required int movieId,
  }) async {
    final trailerKey =
        await TMDbService().getTrailerKey(movieId);

    print('Trailer Key: $trailerKey');
    
    if (trailerKey == null) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trailer not available'),
        ),
      );
      return;
    }

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrailerScreen(
          videoKey: trailerKey,
        ),
      ),
    );
  }
}