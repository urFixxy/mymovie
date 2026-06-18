import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../models/movie.dart';
import '../../providers/favorite_provider.dart';
import '../../services/tmdb_service.dart';
import '../common/detail_screen.dart';
import '../../helpers/trailer_helper.dart';
import 'widgets/compact_movie_card.dart';
import 'widgets/featured_banner.dart';
import '../common/section_title.dart';

class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  final service = TMDbService();
  late Future<List<Movie>> moviesFuture;
  List<Movie>? cachedMovies;

  @override
  void initState() {
    super.initState();
    moviesFuture = service.getPopularMovies();
  }

  Future<void> _refreshMovies() async {
    try {
      final movies = await service.getPopularMovies();
      if (mounted) {
        setState(() {
          cachedMovies = movies;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Refresh error: ${e.toString()}')),
        );
      }
    }
  }

  void _openDetail(Movie movie) async {
    try {
      final movieDetail = await service.getMovieDetail(movie.id);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(movie: movieDetail)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: FutureBuilder<List<Movie>>(
        future: moviesFuture,
        builder: (context, snapshot) {
          // Loading state - hanya tampil pertama kali
          if (snapshot.connectionState == ConnectionState.waiting &&
              cachedMovies == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE01A1A)),
            );
          }

          // Error state - hanya tampil pertama kali
          if (snapshot.hasError && cachedMovies == null) {
            return _buildErrorState(snapshot.error.toString());
          }

          // Gunakan cached movies atau data dari snapshot
          final movies = cachedMovies ?? snapshot.data;

          // Empty state
          if (movies == null || movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.movie_outlined,
                    color: Colors.white38,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No movies found',
                    style: TextStyle(color: Colors.white38),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE01A1A),
                    ),
                    onPressed: _refreshMovies,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Success state - gunakan Consumer untuk auto-update
          return Consumer<FavoriteProvider>(
            builder: (context, provider, _) {
              return _buildContent(movies, movies.first, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white38, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: Colors.white38),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE01A1A),
            ),
            onPressed: _refreshMovies,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    List<Movie> movies,
    Movie featuredMovie,
    FavoriteProvider provider,
  ) {
    return Column(
      children: [
        // AppBar custom (bukan Sliver)
        _buildAppBar(),
        // Content dengan RefreshIndicator
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshMovies,
            color: const Color(0xFFE01A1A),
            backgroundColor: const Color(0xFF1C1C1C),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Banner dengan Consumer untuk auto-update
                      Consumer<FavoriteProvider>(
                        builder: (context, favProvider, _) {
                          return FeaturedBanner(
                            movie: featuredMovie,
                            provider: favProvider,
                            onTap: () => _openDetail(featuredMovie),
                            onPlayTap: () => TrailerHelper.playTrailer(
                              context: context,
                              movieId: featuredMovie.id,
                            ),
                            onFavoriteTap: () =>
                                favProvider.toggleFavorite(featuredMovie),
                          );
                        },
                      ),
                      const SizedBox(height: 28),

                      // Trending Now Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SectionTitle(title: 'Trending Now'),
                      ),
                      const SizedBox(height: 14),
                      _buildTrendingList(movies, provider),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        border: Border(
          bottom: BorderSide(color: Colors.white10, width: 0.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo dan Title
              Row(
                children: [
                  SvgPicture.asset(
                    'lib/assets/images/logo2.svg',
                    width: 32,
                    height: 32,
                    placeholderBuilder: (context) => Container(
                      width: 32,
                      height: 32,
                      color: Colors.white10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'MyMovie',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              // Spacer
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingList(List<Movie> movies, FavoriteProvider provider) {
    return SizedBox(
      height: 265,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          // Wrap dengan Consumer untuk setiap card bisa auto-update
          return Consumer<FavoriteProvider>(
            builder: (context, favProvider, _) {
              return CompactMovieCard(
                movie: movie,
                provider: favProvider,
                onTap: () => _openDetail(movie),
                onFavoriteTap: () => favProvider.toggleFavorite(movie),
              );
            },
          );
        },
      ),
    );
  }
}