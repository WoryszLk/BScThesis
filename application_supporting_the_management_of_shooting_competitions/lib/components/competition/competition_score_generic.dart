import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';
import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_manager.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competitionScores/ShootOff/competition_score_ShootOff.dart';
import 'generic_score.dart';

class CompetitionScoreGeneric extends StatefulWidget {
  final CompetitionWithId competitionWithId;

  const CompetitionScoreGeneric({Key? key, required this.competitionWithId}) : super(key: key);

  @override
  _CompetitionScoreGenericState createState() => _CompetitionScoreGenericState();
}

class _CompetitionScoreGenericState extends State<CompetitionScoreGeneric> {
  final CompetitionManager _competitionManager = CompetitionManager();
  late List<GenericScore> _scores;

  @override
  void initState() {
    super.initState();

    if (widget.competitionWithId.competition.competitionType == 'Shoot off') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ShootOffPage(
              selectedPlayers: widget.competitionWithId.competition.players
                  .map((player) => PlayerWithId(id: player.id, player: player))
                  .toList(),
              competitionId: widget.competitionWithId.id,
            ),
          ),
        );
      });
    } else {
      _initializeScores();
    }
  }

  void _initializeScores() {
    _scores = widget.competitionWithId.competition.players.map((player) {
      return GenericScore(
        playerId: player.id,
        competitionId: widget.competitionWithId.id,
        scores: _initializeScoresForType(widget.competitionWithId.competition.competitionType),
      );
    }).toList();
  }

  Map<String, int> _initializeScoresForType(String type) {
    if (type == 'FBI') {
      return {'Alpha': 0, 'Beta': 0, 'Charlie': 0};
    } else if (type == 'Piro') {
      return {'Hits': 0, 'Misses': 0, 'Explosions': 0};
    } else {
      return {'Score': 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Punktacja dla ${widget.competitionWithId.competition.competitionType}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _scores.length,
              itemBuilder: (context, index) {
                final score = _scores[index];
                return ListTile(
                  title: Text('Zawodnik: ${_getPlayerName(score.playerId)}'),
                  subtitle: Column(
                    children: [
                      ...score.scores.keys.map((scoreType) {
                        return TextField(
                          onChanged: (value) {
                            setState(() {
                              score.scores[scoreType] = int.tryParse(value) ?? 0;
                              score.evaluateCompletion();
                            });
                          },
                          decoration: InputDecoration(labelText: '$scoreType Score'),
                          keyboardType: TextInputType.number,
                        );
                      }).toList(),
                      Text('Status: ${score.isCompleted ? "Zaliczone" : "Niezaliczone"}'),
                    ],
                  ),
                );
              },
            ),
          ),
          _competitionManager.buildActionButtons(
            context,
            widget.competitionWithId.id,
            _scores,
          ),
        ],
      ),
    );
  }

  String _getPlayerName(String playerId) {
    final player = widget.competitionWithId.competition.players.firstWhere((p) => p.id == playerId);
    return '${player.firstName} ${player.lastName}';
  }
}
