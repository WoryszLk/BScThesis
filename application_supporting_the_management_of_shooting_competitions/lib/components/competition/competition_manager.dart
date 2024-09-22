import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competitionScores/competition_score_FBI.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';

class CompetitionManager {
  final CompetitionService _competitionService = CompetitionService();

  // Funkcja do pobierania historii zawodów
  Stream<List<CompetitionWithId>> getCompetitions() {
    return _competitionService.getCompetitions();
  }

  // Funkcja do ładowania odpowiedniego widoku punktacji na podstawie typu zawodów
  Widget loadCompetitionScorePage(CompetitionWithId competitionWithId) {
    final competitionType = competitionWithId.competition.competitionType;

    if (competitionType == 'FBI') {
      return CompetitionScoreFBI(competitionWithId: competitionWithId);
    }

    return const Center(
      child: Text('Brak obsługi punktacji dla tego typu zawodów.'),
    );
  }

  // Funkcja zapisywania wyników zawodów (logika zapisu punktacji)
  Future<void> saveCompetitionScores(String competitionId, List<dynamic> scores) async {
    await _competitionService.savePlayerScores(competitionId, scores);
  }

  // Funkcja obsługująca zakończenie zawodów
  Future<void> endCompetition(String competitionId) async {
    await _competitionService.endCompetition(competitionId);
  }

   Widget buildActionButtons(BuildContext context, String competitionId, List<dynamic> scores) {
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
              await endCompetition(competitionId);  // Zakończenie zawodów
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
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