class Genre {
  final int id;
  final String name;

  bool isSelected = false;

  Genre(this.id, this.name);

  /// Create instance of this class based from [map].
  ///
  ///
  static Genre from(Map<dynamic, dynamic> map) => Genre(
    map['id'],
    map['name']
  );
}