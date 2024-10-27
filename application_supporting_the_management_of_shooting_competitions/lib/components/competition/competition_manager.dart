import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_score_generic.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/generic_score.dart';
import 'package:flutter/material.dart';

class CompetitionManager {
  final CompetitionService _competitionService = CompetitionService();

  Stream<List<CompetitionWithId>> getCompetitions() {
    return _competitionService.getCompetitions();
  }

  Widget loadCompetitionScorePage(CompetitionWithId competitionWithId) {
    return CompetitionScoreGeneric(competitionWithId: competitionWithId);
  }

  Future<void> saveCompetitionScores(String competitionId, List<GenericScore> scores) async {
    await _competitionService.savePlayerScores(competitionId: competitionId, playerScores: scores);
  }

  Future<void> endCompetition(String competitionId) async {
    await _competitionService.endCompetition(competitionId);
  }

  Widget buildActionButtons(BuildContext context, String competitionId, List<GenericScore> scores) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              saveCompetitionScores(competitionId, scores);
            },
            icon: const Icon(Icons.save),
            label: const Text('Zapisz'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await endCompetition(competitionId);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.stop),
            label: const Text('Zakończ'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
