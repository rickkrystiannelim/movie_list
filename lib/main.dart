import 'package:flutter/material.dart';
import 'package:movielist/ui/home/MovieListModel.dart';
import 'package:movielist/ui/home/MovieListPage.dart';
import 'package:movielist/ui/home/ViewedMovieModel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MovieListModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ViewedMovieModel(),
        ),
      ],
      child:MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = "Movie List";

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MovieListPage(title),
    );
  }
}