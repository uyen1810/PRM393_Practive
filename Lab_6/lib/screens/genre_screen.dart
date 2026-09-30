import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';
  final Set<String> selectedGenres = {};
  String selectedSort = 'A–Z';

  final List<String> availableGenres = [
    'Action',
    'Adventure',
    'Comedy',
    'Crime',
    'Drama',
    'Sci-Fi',
    'Thriller',
  ];

  final List<String> sortOptions = ['A–Z', 'Z–A', 'Year', 'Rating'];

  List<Movie> get visibleMovies {
    return sampleMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any((g) => selectedGenres.contains(g));
      return matchesSearch && matchesGenre;
    }).toList()
      ..sort((a, b) {
        switch (selectedSort) {
          case 'Z–A':
            return b.title.compareTo(a.title);
          case 'Year':
            return b.year.compareTo(a.year);
          case 'Rating':
            return b.rating.compareTo(a.rating);
          case 'A–Z':
          default:
            return a.title.compareTo(b.title);
        }
      });
  }

  void _clearFilters() {
    setState(() {
      searchQuery = '';
      selectedGenres.clear();
      selectedSort = 'A–Z';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMovies = visibleMovies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Movie', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          if (selectedGenres.isNotEmpty || searchQuery.isNotEmpty)
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Clear Filters'),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildGenreSection(),
              const SizedBox(height: 12),
              _buildSortBar(filteredMovies.length),
              const SizedBox(height: 16),
              Expanded(
                child: filteredMovies.isEmpty
                    ? const Center(
                  child: Text(
                    'No movies found matching your criteria.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 800) {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          return MovieCard(movie: filteredMovies[index], isGrid: true);
                        },
                      );
                    } else {
                      return ListView.builder(
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: MovieCard(movie: filteredMovies[index], isGrid: false),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() => searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Search by movie title or keyword...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => setState(() => searchQuery = ''),
        )
            : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGenreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Genres',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            if (selectedGenres.isNotEmpty)
              Badge(
                label: Text('${selectedGenres.length}'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: availableGenres.map((genre) {
            final isSelected = selectedGenres.contains(genre);
            return FilterChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedGenres.add(genre);
                  } else {
                    selectedGenres.remove(genre);
                  }
                });
              },
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
              checkmarkColor: Theme.of(context).colorScheme.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortBar(int totalCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing $totalCount movies',
          style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            const Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.w500)),
            DropdownButton<String>(
              value: selectedSort,
              underline: const SizedBox(),
              items: sortOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => selectedSort = newValue);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}