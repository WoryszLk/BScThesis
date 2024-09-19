
import 'dart:ffi';

import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competitionScores/competition_score_FBI.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class CompetitionManager {
  final CompetitionService _competitionService = CompetitionService();

  // Pobieranie Historii zawodów
  Stream<List<CompetitionWithId>> getCompetitions()
  {
    return _competitionService.getCompetitions();
  }

  Widget loadCompetitionScorePage(CompetitionWithId competitionWithId)
  {
    final competitionType = competitionWithId.competition.competitionType;
    if(competitionType == "FBI")
    {
      return CompetitionScoreFBI(competitionWithId: competitionWithId);
    }

     return const Center(
      child: Text('Brak obsługi punktacji dla tego typu zawodów.'),
    );
  }

}