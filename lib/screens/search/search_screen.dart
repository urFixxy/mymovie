import 'package:flutter/material.dart';

import '../../models/movie.dart';
import '../../services/tmdb_service.dart';
import '../common/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TMDbService service = TMDbService();
  final TextEditingController searchController = TextEditingController();

  List<Movie> searchResults = [];
  List<Movie> topRatedMovies = [];

  bool isLoading = true;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadTopRatedMovies();
  }

  Future<void> _loadTopRatedMovies() async {
    try {
      final movies = await service.getTopRatedMovies();

      if (!mounted) return;

      setState(() {
        topRatedMovies = movies;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load movies: $e'),
        ),
      );
    }
  }

  Future<void> _searchMovie(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        isSearching = false;
        searchResults.clear();
      });
      return;
    }

    setState(() {
      isLoading = true;
      isSearching = true;
    });

    try {
      final movies = await service.searchMovies(query);

      if (!mounted) return;

      setState(() {
        searchResults = movies;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search failed: $e'),
        ),
      );
    }
  }

  Future<void> _openDetail(Movie movie) async {
    try {
      final detail = await service.getMovieDetail(movie.id);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(movie: detail),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Widget _buildMovieGrid(List<Movie> movies) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: movies.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];

        return GestureDetector(
          onTap: () => _openDetail(movie),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Positioned.fill(
                  child: movie.posterUrl.isNotEmpty
                      ? Image.network(
                          movie.posterUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              color: Colors.grey[900],
                              child: const Icon(
                                Icons.movie,
                                color: Colors.white38,
                                size: 40,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[900],
                          child: const Icon(
                            Icons.movie,
                            color: Colors.white38,
                            size: 40,
                          ),
                        ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesToDisplay =
        isSearching ? searchResults : topRatedMovies;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Search'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search movie...',
                hintStyle:
                    const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  setState(() {
                    isSearching = false;
                    searchResults.clear();
                  });
                }
              },
              onSubmitted: _searchMovie,
            ),
          ),

          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSearching
                          ? 'Search Results'
                          : 'Top Rated Movies',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Expanded(
                      child: moviesToDisplay.isEmpty
                          ? const Center(
                              child: Text(
                                'No movies found',
                                style: TextStyle(
                                  color: Colors.white54,
                                ),
                              ),
                            )
                          : _buildMovieGrid(
                              moviesToDisplay,
                            ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
