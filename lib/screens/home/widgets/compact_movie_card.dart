import 'package:flutter/material.dart';
import '../../../models/movie.dart';
import '../../../providers/favorite_provider.dart';

class CompactMovieCard extends StatelessWidget {
  final Movie movie;
  final FavoriteProvider provider;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const CompactMovieCard({
    super.key,
    required this.movie,
    required this.provider,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(movie.posterUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            _buildGradientOverlay(),
            _buildFavoriteButton(),
            _buildTitleAndRating(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.9),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Positioned(
      bottom: 4,
      right: 6,
      child: GestureDetector(
        onTap: onFavoriteTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(
            provider.isFavorite(movie.id)
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: const Color(0xFFE01A1A),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndRating() {
    return Positioned(
      left: 10,
      right: 10,
      bottom: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 13),
              const SizedBox(width: 3),
              Text(
                movie.voteAverage.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}