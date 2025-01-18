class JokeModel {
  final String setup;
  final String punchline;
  bool isFavorite;

  JokeModel({
    required this.setup, 
    required this.punchline, 
    this.isFavorite = false
  });

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    return JokeModel(
      setup: json['setup'],
      punchline: json['punchline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setup': setup,
      'punchline': punchline,
      'isFavorite': isFavorite,
    };
  }
}
