import 'package:flutter/material.dart';

/// Header section reusable, contoh: "Trending Now", "Popular Picks",
/// dengan tautan "See all" di kanan.
class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          GestureDetector(
            onTap: onSeeAllTap,
            child: const Text(
              'See all',
              style: TextStyle(
                color: Color(0xFFE01A1A),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}