
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';

class CompetitionManager {
  final CompetitionService _competitionService = CompetitionService();

  Stream<List<CompetitionWithId>> getCompetitions()
  {
    return _competitionService.getCompetitions();
  }
}