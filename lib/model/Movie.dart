class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;

  bool isViewed = false;

  Movie(
    this.id,
    this.title,
    this.posterPath,
    this.overview,
    this.releaseDate
  );

  /// Create instance of this class based from [map].
  ///
  /// [baseImageUrl] is the base URL of the API for images.
  static Movie from(Map<dynamic, dynamic> map, String baseImageUrl) => Movie(
    map['id'],
    map['title'],
    '$baseImageUrl${map['poster_path']}',
    map['overview'],
    map['release_date']
  );
}