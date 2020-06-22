

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movielist/model/Movie.dart';
import 'package:movielist/ui/home/MovieListModel.dart';
import 'package:movielist/ui/home/ViewedMovieModel.dart';
import 'package:provider/provider.dart';

class MovieList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieListModel>(
      builder: (context, movieListModel, child) => FutureBuilder(
        future: movieListModel.getMovies(),
        builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          else if (snapshot.data.isEmpty) {
            return Center(
              child: Text('No Movies'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) => _buildRow(snapshot.data[i]),
          );
        },
      ),
    );
  }

  /// Build list row widget.
  ///
  ///
  Widget _buildRow(Movie movie) => Consumer<ViewedMovieModel>(
    builder: (context, viewedMovieModel, child) => ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: CachedNetworkImage(
        imageUrl: movie.posterPath,
        width: 50,
        progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(
          value: downloadProgress.progress
        ),
        errorWidget: (context, url, error) => Icon(Icons.broken_image),
      ),
      title: Text(
        movie.title,
        style: TextStyle(
          color: movie.isViewed ? Colors.blue : Colors.black,
        ),
      ),
      subtitle: movie.isViewed ? 
          _buildViewedRow(movie) :
          Text(
            movie.overview,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      onTap: () => viewedMovieModel.viewedMovie = movie,
    ),
  );

  /// Build selected [movie] widget.
  ///
  ///
  Widget _buildViewedRow(Movie movie) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(movie.overview),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text('Release Date: ${movie.releaseDate}'),
      ),
    ],
  );
}