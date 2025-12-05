class GameTheme {
  final String id;
  final String title;

  const GameTheme({
    required this.id,
    required this.title,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameTheme && other.id == id && other.title == title;
  }

  @override
  int get hashCode => Object.hash(id, title);

  @override
  String toString() => 'GameTheme(id: $id, title: $title)';
}
