import 'package:movielist/model/Movie.dart';

class MovieList {
  int page;
  final int totalResults;
  final int totalPages;
  final List<Movie> movies;

  MovieList(
    this.page,
    this.totalResults,
    this.totalPages,
    this.movies
  );

  /// Create instance of this class based from [map].
  ///
  /// [baseImageUrl] is the base URL of the API for images.
  static MovieList from(Map<dynamic, dynamic> map, String baseImageUrl) {
    final rawMovies = map['results'] as List;
    final movies = rawMovies.map(
      (obj) => Movie.from(obj, baseImageUrl)
    ).toList();

    return MovieList(
      map['page'],
      map['total_results'],
      map['total_pages'],
      movies
    );
  }
}