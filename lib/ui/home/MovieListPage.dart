import 'package:flutter/material.dart';
import 'package:movielist/model/Genre.dart';
import 'package:movielist/ui/home/MovieListModel.dart';
import 'package:movielist/ui/home/widgets/GenreList.dart';
import 'package:movielist/ui/home/widgets/MovieList.dart';
import 'package:provider/provider.dart';

class MovieListPage extends StatelessWidget {
  final String _title;

  MovieListPage(this._title, { Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) => GenreList(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.blue,
        child: Container(
          height: 90.0,
          child: _buildPages(context),
        ),
      ),
    );
  }

  /// Build body widget.
  ///
  ///
  Widget _buildBody(BuildContext context) => FutureBuilder(
    future: Provider.of<MovieListModel>(context, listen: false).getGenres(),
    builder: (context, AsyncSnapshot<List<Genre>> snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator()
        );
      }

      return MovieList();
    },
  );

  /// Build pages widget.
  ///
  ///
  Widget _buildPages(BuildContext context) => Consumer<MovieListModel>(
    builder: (context, movieListModel, child) {
      if (movieListModel.totalPages == 0) {
        return Container();
      }

      return Column(
        children: <Widget>[
          child,
          _buildPageNumbers(movieListModel),
        ],
      );
    },
    child: _buildPageArrowButtons(context),
  );

  /// Build page navigation (arrows left and right) widget.
  ///
  ///
  Widget _buildPageArrowButtons(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      IconButton(
        icon: Icon(Icons.navigate_before),
        onPressed: () => Provider.of<MovieListModel>(context, listen: false).previousPage(),
      ),
      Text('Page'),
      IconButton(
        icon: Icon(Icons.navigate_next),
        onPressed: () => Provider.of<MovieListModel>(context, listen: false).nextPage(),
      ),
    ],
  );

  /// Build page navigation (page number) widget.
  ///
  ///
  Widget _buildPageNumbers(MovieListModel movieListModel) => Expanded(
    child: ListView.builder(
      itemCount: movieListModel.totalPages,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 5, right: 5),
      itemBuilder: (context, index) {
        final page = index + 1;
        final color = movieListModel.page == page ? Colors.white : Colors.black;

        return InkWell(
          child: Padding(
            padding: EdgeInsets.only(left: 15, top: 10, right: 15),
            child: Text(
              page.toString(),
              style: TextStyle(
                color: color
              ),
            ),
          ),
          onTap: () => movieListModel.page = page,
        );
      }
    ),
  );
}