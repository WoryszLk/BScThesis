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

  Future<void> saveCompetitionScores(
    BuildContext context,
    String competitionId,
    List<GenericScore> scores,
  ) async {
    try {
      await _competitionService.savePlayerScores(
        competitionId: competitionId,
        playerScores: scores,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wyniki zawodników zostały zapisane pomyślnie.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd podczas zapisywania wyników: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> endCompetition(BuildContext context, String competitionId) async {
    try {
      await _competitionService.endCompetition(competitionId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Zawody zostały zakończone.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd podczas kończenia zawodów: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void createReport(BuildContext context, String competitionId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Raport został utworzony.'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget buildActionButtons(
    BuildContext context,
    String competitionId,
    List<GenericScore> scores,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              saveCompetitionScores(context, competitionId, scores);
            },
            icon: const Icon(Icons.save),
            label: const Text('Zapisz'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          ElevatedButton.icon(
            onPressed: () {
              createReport(context, competitionId);
            },
            icon: const Icon(Icons.description),
            label: const Text('Stwórz Raport'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await endCompetition(context, competitionId);
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
