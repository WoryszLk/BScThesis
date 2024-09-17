class PlayerScoreFBI {
  final String playerId;
  int alphaScore;
  int betaScore;
  int charlieScore;
  bool isCompleted;

  PlayerScoreFBI({
    required this.playerId,
    this.alphaScore = 0,
    this.betaScore = 0,
    this.charlieScore = 0,
    this.isCompleted = true,
  });

  void evaluateCompletion() {
    if (charlieScore > 0) {
      isCompleted = false;
    } else {
      isCompleted = true;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'alphaScore': alphaScore,
      'betaScore': betaScore,
      'charlieScore': charlieScore,
      'isCompleted': isCompleted,
    };
  }
}