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
  'Shoot off': [
    'Faza Przedmeczu: Każdy zawodnik wykonuje minimum jedną próbę strzelecką do wyznaczonych celów (popperów). Możliwe są maksymalnie dwie próby. Na podstawie czasu z najlepszej próby, zawodnicy są dobierani w pary: najlepszy czas z najgorszym czasem, itd.',
    'Faza Pojedynków: Każda para rywalizuje, strzelając do 5 popperów na swojej stronie. Zawodnik, który jako pierwszy zbije wszystkie 5 popperów, wygrywa pojedynek. Przegrany odpada, a zwycięzca przechodzi do kolejnej fazy.',
    'Łączenie par: W kolejnych fazach zwycięzcy są łączeni w pary zgodnie z drabinką eliminacyjną.'
  ]
};

class CompetitionRulesPage extends StatelessWidget {
  final String selectedCompetition;
  final List<PlayerWithId> selectedPlayers;

  const CompetitionRulesPage({
    Key? key,
    required this.selectedCompetition,
    required this.selectedPlayers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rules = competitionRules[selectedCompetition] ?? ['Brak zasad dla wybranych zawodów'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Zasady zawodów: $selectedCompetition'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Zasady dla $selectedCompetition',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: rules.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.blueGrey.shade900,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      rules[index],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),

            const Divider(
              height: 40,
              thickness: 2,
              color: Colors.blueGrey,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Lista zawodników',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              itemCount: selectedPlayers.length,
              itemBuilder: (context, index) {
                final player = selectedPlayers[index].player;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        player.firstName[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      '${player.firstName} ${player.lastName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      player.age != null ? 'Wiek: ${player.age}' : 'Wiek: nie podano',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}