import 'package:flutter/material.dart';
import '../../../models/movie.dart';
import '../../../providers/favorite_provider.dart';

class FeaturedBanner extends StatelessWidget {
  final Movie movie;
  final FavoriteProvider provider;
  final VoidCallback onTap;
  final VoidCallback onPlayTap;
  final VoidCallback onFavoriteTap;

  const FeaturedBanner({
    super.key,
    required this.movie,
    required this.provider,
    required this.onTap,
    required this.onPlayTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          SizedBox(
            height: 560,
            width: double.infinity,
            child: Image.network(
              movie.posterUrl,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFF1C1C1C)),
            ),
          ),
          _buildGradientOverlay(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.4, 1.0],
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
              const Color(0xFF0A0A0A),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeaturedBadge(),
          const SizedBox(height: 10),
          Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          _buildMetaRow(),
          const SizedBox(height: 18),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildFeaturedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE01A1A),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'FEATURED',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMetaRow() {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
        const SizedBox(width: 4),
        Text(
          movie.rating.toStringAsFixed(1),
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(width: 12),
        const Icon(
          Icons.calendar_today_outlined,
          color: Colors.white38,
          size: 13,
        ),
        const SizedBox(width: 4),
        Text(
          movie.releaseDate,
          style: const TextStyle(color: Colors.white38, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.play_arrow_rounded, size: 20),
          label: const Text(
            'Play',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          onPressed: onPlayTap,
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white30),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Icon(
            provider.isFavorite(movie.id)
                ? Icons.check_rounded
                : Icons.add_rounded,
            size: 20,
          ),
          label: const Text('My List'),
          onPressed: onFavoriteTap,
        ),
      ],
    );
  }
}
