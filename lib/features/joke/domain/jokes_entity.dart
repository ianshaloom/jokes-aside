class JokeEntity{
  final String id;
  final String setup;
  final String punchline;
  final bool isFavorite;

  const JokeEntity({
    required this.id,
    required this.setup,
    required this.punchline,
    required this.isFavorite,
  });
}