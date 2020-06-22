import 'package:flutter/material.dart';
import 'package:movielist/ui/home/MovieListModel.dart';
import 'package:provider/provider.dart';

class GenreList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final genres = Provider.of<MovieListModel>(context, listen: false).genres;

    return ListView.builder(
      itemCount: genres.length,
      itemBuilder: (context, i) => Consumer<MovieListModel>(
        builder: (context, movieListModel, child) => ListTile(
          title: Text(genres[i].name),
          trailing: Checkbox(
            value: genres[i].isSelected,
            onChanged: (bool newValue) => movieListModel.toggle(genres[i]),
          ),
          onTap: () => movieListModel.toggle(genres[i]),
        ),
      ),
    );
  }
}