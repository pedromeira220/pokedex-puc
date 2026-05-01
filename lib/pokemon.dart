class Pokemon {
  final String name;
  final int spriteId;
  final List<String> types;
  int level;
  final List<String> moves;

  Pokemon({
    required this.name,
    required this.spriteId,
    required this.types,
    required this.level,
    this.moves = const [],
  });

  String get spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$spriteId.png';

  List<String> get typeNames => types;
}
