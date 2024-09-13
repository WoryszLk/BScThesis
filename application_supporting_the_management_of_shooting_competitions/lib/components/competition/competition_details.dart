import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';
import 'package:flutter/material.dart';

class CompetitionDetailsPage extends StatelessWidget {
  final CompetitionWithId competitionWithId;

  const CompetitionDetailsPage({Key? key, required this.competitionWithId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final competition = competitionWithId.competition;

    return Scaffold(
      appBar: AppBar(
        title: Text('Szczegóły zawodów: ${competition.competitionType}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Typ zawodów: ${competition.competitionType}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Data rozpoczęcia: ${competition.startDate.toLocal()}'),
            const SizedBox(height: 16),
            const Text(
              'Lista zawodników:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: competition.players.length,
                itemBuilder: (context, index) {
                  final player = competition.players[index];
                  return ListTile(
                    title: Text('${player.firstName} ${player.lastName}'),
                    subtitle: Text(player.age != null ? 'Wiek: ${player.age}' : 'Wiek: nie podano'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
