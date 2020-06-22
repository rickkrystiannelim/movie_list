import 'package:flutter/foundation.dart';
import 'package:movielist/model/Movie.dart';

class ViewedMovieModel extends ChangeNotifier {
  Movie _viewedMovie;

  /// Get viewed/selected [Movie].
  ///
  ///
  Movie get viewedMovie => _viewedMovie;

  /// Set viewed/selected [Movie].
  ///
  ///
  set viewedMovie(Movie movie) {
    if (_viewedMovie != null && _viewedMovie != movie) {
      _viewedMovie.isViewed = false;
    }

    movie.isViewed = !movie.isViewed;
    _viewedMovie = movie;
    notifyListeners();
  }
}