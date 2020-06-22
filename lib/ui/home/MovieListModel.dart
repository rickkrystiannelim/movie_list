import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:movielist/model/Genre.dart';
import 'package:movielist/model/Movie.dart';
import 'package:movielist/model/MovieList.dart';
import 'package:movielist/repository/AppRepo.dart';

class MovieListModel extends ChangeNotifier {
  final List<Genre> _genres = [];

  MovieList _movieList;

  /// Get list of [Genre] return by [getGenres] function.
  ///
  ///
  List<Genre> get genres => UnmodifiableListView(_genres);

  /// Get current page of the movie list.
  ///
  ///
  int get page => _movieList == null ? 0 : _movieList.page;

  /// Get total page of the movie list.
  ///
  ///
  int get totalPages => _movieList == null ? 0 : _movieList.totalPages;

  /// Set current page of the movie list.
  ///
  ///
  set page(int value) {
    if (value < 1 || value == page || value > totalPages) {
      return;
    }
    _movieList.page = value;
    notifyListeners();
  }

  /// Get list of [Genre] from TMDB.
  ///
  ///
  Future<List<Genre>> getGenres() async {
    final res = await AppRepo.instance().getGenres();

    if (res != null && res.length > 0) {
      _genres.clear();
      _genres.addAll(res);
    }

    return res;
  }

  int _getMoviesQueryCnt = 0;

  /// Get list of [Movie] from TMDB based from [page] and [genres] data.
  ///
  ///
  Future<List<Movie>> getMovies() async {
    if (_getMoviesQueryCnt == 1) {
      // During rerendering of "pages" widget, just return the [movies] list.
      _getMoviesQueryCnt++;
      return _movieList.movies;
    }

    _movieList = await AppRepo.instance().getMovies(
      page: _movieList == null ? 1 : _movieList.page,
      genres: _genres
    );

    if (_getMoviesQueryCnt == 0) {
      _getMoviesQueryCnt++;
      // Needed to rerender "pages" widget
      notifyListeners();
    }

    return _movieList.movies;
  }

  /// Select/Unselect genre.
  ///
  ///
  void toggle(Genre genre) {
    genre.isSelected = !genre.isSelected;
    notifyListeners();
  }

  /// Previous page.
  ///
  ///
  void previousPage() {
    page = page - 1;
  }

  /// Next page.
  ///
  ///
  void nextPage() {
    page = page + 1;
  }
}