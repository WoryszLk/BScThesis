class GenericScore {
  final String playerId;
  final String competitionId;
  final Map<String, int> scores;
  bool isCompleted;

  GenericScore({
    required this.playerId,
    required this.competitionId,
    required this.scores,
    this.isCompleted = false,
  });

  void evaluateCompletion() {
    isCompleted = scores.values.every((score) => score > 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'competitionId': competitionId,
      'scores': scores,
      'isCompleted': isCompleted,
    };
  }

  factory GenericScore.fromMap(Map<String, dynamic> map) {
    return GenericScore(
      playerId: map['playerId'],
      competitionId: map['competitionId'],
      scores: Map<String, int>.from(map['scores']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
