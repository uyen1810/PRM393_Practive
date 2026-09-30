class Movie {
  final String id;
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

final List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/inception/300/450',
    rating: 8.8,
  ),
  Movie(
    id: '2',
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Crime', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/darkknight/300/450',
    rating: 9.0,
  ),
  Movie(
    id: '3',
    title: 'Interstellar',
    year: 2014,
    genres: ['Adventure', 'Drama', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/interstellar/300/450',
    rating: 8.6,
  ),
  Movie(
    id: '4',
    title: 'Pulp Fiction',
    year: 1994,
    genres: ['Crime', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/pulpfiction/300/450',
    rating: 8.9,
  ),
  Movie(
    id: '5',
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/avengers/300/450',
    rating: 8.4,
  ),
  Movie(
    id: '6',
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://picsum.photos/seed/hangover/300/450',
    rating: 7.7,
  ),
];