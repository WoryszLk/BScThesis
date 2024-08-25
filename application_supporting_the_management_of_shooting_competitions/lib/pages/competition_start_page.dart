import 'package:application_supporting_the_management_of_shooting_competitions/pages/player_list_selector_page.dart';
import 'package:flutter/material.dart';
import 'competition_selector_page.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/custom_button.dart';

class StarterCompetition extends StatefulWidget {
  const StarterCompetition({super.key});

  @override
  _StarterCompetitionState createState() => _StarterCompetitionState();
}

class _StarterCompetitionState extends State<StarterCompetition> {
  int? _selectedCompetitionIndex;

  final List<String> _competitionNames = [
    'Tryb zawodów 1',
    'Tryb zawodów 2',
    'Tryb zawodów 3',
    'Tryb zawodów 4',
    'Tryb zawodów 5',
  ];

  void _navigateToCompetitionSelector() async {
    final selectedIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (context) => const CompetitionSelector()),
    );

    if (selectedIndex != null) {
      setState(() {
        _selectedCompetitionIndex = selectedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomButton(
                width: double.infinity,
                height: double.infinity,
                imagePath: _selectedCompetitionIndex != null
                    ? 'lib/images/selectedCompetition${_selectedCompetitionIndex! + 1}.jpg'
                    : 'lib/images/buttonShooters.jpg',
                text: _selectedCompetitionIndex != null
                    ? _competitionNames[_selectedCompetitionIndex!]
                    : 'Wybierz typ zawodów',
                onPressed: _navigateToCompetitionSelector,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      imagePath: 'lib/images/PlayersList.jpg',
                      text: 'Lista zawodników',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PlayerList()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      imagePath: 'lib/images/buttonShooters.jpg',
                      text: 'Tile 2',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      imagePath: 'lib/images/buttonShooters.jpg',
                      text: 'Tile 3',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
