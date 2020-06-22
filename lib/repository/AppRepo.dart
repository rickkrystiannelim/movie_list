import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:movielist/model/Genre.dart';
import 'package:movielist/model/MovieList.dart';

class AppRepo {
  static const TMDB_API_KEY_V3 = '3c219e6d1cd0b8a4a583f12452273d1e';
  static const TMDB_BASE_URL_V3 = 'https://api.themoviedb.org/3';
  static const TMDB_BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w200';

  static final GET_TMDB_MOVIE_GENRES = '$TMDB_BASE_URL_V3/genre/movie/list?api_key=$TMDB_API_KEY_V3';
  static final GET_TMDB_MOVIES = '$TMDB_BASE_URL_V3/discover/movie?api_key=$TMDB_API_KEY_V3';

  static AppRepo _instance;

  /// Get singleton instance of this class.
  ///
  ///
  static AppRepo instance() {
    if (_instance == null) {
      _instance = AppRepo._();
    }

    return _instance;
  }

  AppRepo._();

  /// Get list of [Genre] from TMDB.
  ///
  ///
  Future<List<Genre>> getGenres() async {
    if (!await _checkConnectivity()) {
      return [];
    }
    final res = await http.get(GET_TMDB_MOVIE_GENRES);

    if (res.statusCode != HttpStatus.ok) {
      return [];
    }

    return compute(_parseGenres, res.body);
  }

  /// Discover movies from TMDB.
  ///
  ///
  Future<MovieList> getMovies({ int page = 1, List<Genre> genres = const [] }) async {
    if (!await _checkConnectivity()) {
      return null;
    }
    final url = _modifyGetMoviesUrl(page, genres);
    final res = await http.get(url);

    if (res.statusCode != HttpStatus.ok) {
      return null;
    }

    return compute(_parseMovies, res.body);
  }

  /// Add [page] and [genres] query to [GET_TMDB_MOVIES] URL.
  ///
  ///
  String _modifyGetMoviesUrl(int page, List<Genre> genres) {
    final url = StringBuffer(GET_TMDB_MOVIES);

    if (page > 1) {
      url.write('&page=');
      url.write(page);
    }
  
    if (genres.length > 0) {
      bool isFirstGenreAdded = false;
      
      url.write('&with_genres=');

      for (var i = 0; i < genres.length; i++) {
        if (!genres[i].isSelected) {
          continue;
        }

        if (isFirstGenreAdded) {
          url.write('|');
        }
        url.write(genres[i].id);
        isFirstGenreAdded = true;
      }
    }

    return url.toString();
  }

  /// Check if device is connected to Wifi or mobile data.
  ///
  ///
  Future<bool> _checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}

///
///
///
List<Genre> _parseGenres(String responseBody) {
  final body = jsonDecode(responseBody) as Map<String, dynamic>;
  final rawGenres = body['genres'] as List;

  return rawGenres.map(
    (obj) => Genre.from(obj)
  ).toList();
}

///
///
///
MovieList _parseMovies(String responseBody) {
  final rawMovieList = jsonDecode(responseBody) as Map<String, dynamic>;    
  return MovieList.from(rawMovieList, AppRepo.TMDB_BASE_IMAGE_URL);
}