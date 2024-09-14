import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';
import 'package:flutter/material.dart';

const Map<String, List<String>> competitionRules = {
  'FBI': [
    'Zadanie 1: 2,7 m - 6 strzałów (1 magazynek). Broń w kaburze. 3 strzały - tylko silna ręka i 3 strzały - tylko ręka wspomagająca - czas 6 sek.',
    'Zadanie 2: 4,6 m - 12 strzałów (2 magazynki po 6 naboi). Broń w kaburze. 3 strzały - czas 3 sek.',
    'Zadanie 3: 6,4 m - 18 strzałów (2 magazynki po 5 naboi). 5 strzałów - czas 5 sek.',
    'Zadanie 4: 13,7 m - 6 strzałów (1 magazynek). 3 strzały - czas 6 sek.',
    'Zadanie 5: 22,8 m - 8 strzałów (1 magazynek). 4 strzały stojąc i 4 strzały klęcząc - czas 20 sek.'
  ],
  'PIRO': [
    'Zadanie 1: XYZ',
    'Zadanie 2: ABC'
  ],
};

class CompetitionRulesPage extends StatelessWidget {
  final String selectedCompetition;
  final List<PlayerWithId> selectedPlayers;

  const CompetitionRulesPage({
    Key? key,
    required this.selectedCompetition,
    required this.selectedPlayers, // Przechwycenie wybranych zawodników
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rules = competitionRules[selectedCompetition] ?? ['Brak zasad dla wybranych zawodów'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Zasady zawodów: $selectedCompetition'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: rules.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      rules[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          // Wyświetlanie wybranych zawodników
          Expanded(
            child: ListView.builder(
              itemCount: selectedPlayers.length,
              itemBuilder: (context, index) {
                final player = selectedPlayers[index].player;
                return ListTile(
                  title: Text('${player.firstName} ${player.lastName}'),
                  subtitle: Text(player.age != null ? 'Wiek: ${player.age}' : 'Wiek: nie podano'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}