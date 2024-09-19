import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';

class CompetitionScoreFBI extends StatefulWidget {
  final CompetitionWithId competitionWithId;

  const CompetitionScoreFBI({Key? key, required this.competitionWithId}) : super(key: key);

  @override
  _CompetitionScoreFBIState createState() => _CompetitionScoreFBIState();
}

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

class _CompetitionScoreFBIState extends State<CompetitionScoreFBI> {
  final CompetitionService _competitionService = CompetitionService();
  late List<PlayerScoreFBI> _scores;

  @override
  void initState() {
    super.initState();
    // Użycie PlayerWithId, który posiada pole 'id'
    _scores = widget.competitionWithId.competition.players.map((player) {
      return PlayerScoreFBI(playerId: player.id);  // Zmienione na PlayerWithId
    }).toList();
  }

  void _saveScores() async {
    await _competitionService.savePlayerScores(widget.competitionWithId.id, _scores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punktacja FBI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveScores,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _scores.length,
        itemBuilder: (context, index) {
          final score = _scores[index];
          return ListTile(
            title: Text('Zawodnik: ${score.playerId}'),
            subtitle: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => score.alphaScore = int.parse(value)),
                  decoration: const InputDecoration(labelText: 'Alpha Score'),
                ),
                TextField(
                  onChanged: (value) => setState(() => score.betaScore = int.parse(value)),
                  decoration: const InputDecoration(labelText: 'Beta Score'),
                ),
                TextField(
                  onChanged: (value) => setState(() => score.charlieScore = int.parse(value)),
                  decoration: const InputDecoration(labelText: 'Charlie Score'),
                ),
                Text('Status: ${score.isCompleted ? "Zaliczone" : "Niezaliczone"}'),
              ],
            ),
          );
        },
      ),
    );
  }
}