import 'package:application_supporting_the_management_of_shooting_competitions/pages/competition_rules_page.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/custom_button.dart';
import 'competition_selector_page.dart';
import 'player_list_selector_page.dart';

class StarterCompetition extends StatefulWidget {
  const StarterCompetition({super.key});

  @override
  _StarterCompetitionState createState() => _StarterCompetitionState();
}

class _StarterCompetitionState extends State<StarterCompetition> {
  int? _selectedCompetitionIndex;

  final List<String> _competitionNames = [
    'FBI',
    'PIRO',
    '2guns 2pistols',
    'Piromanek',
    'Top Gun',
    'BTG',
  ];

  final List<String> _imagePaths = [
    'lib/images/fbi.jpg',
    'lib/images/piro.jpg',
    'lib/images/2guns_2pistols.jpg',
    'lib/images/piromanek.jpg',
    'lib/images/top_gun.jpg',
    'lib/images/btg.jpg',
  ];

  void _navigateToCompetitionSelector() async {
    final selectedIndex = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => const CompetitionSelector(),
      ),
    );

    if (selectedIndex != null) {
      setState(() {
        _selectedCompetitionIndex = selectedIndex;
      });
    }
  }

  void _navigateToPlayersSelector() async {
    await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (context) => const PlayerList()),
    );
  }

   void _navigateToRulesSelector() async {
    if (_selectedCompetitionIndex != null) {
      final selectedCompetition = _competitionNames[_selectedCompetitionIndex!];
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompetitionRulesPage(selectedCompetition: selectedCompetition), 
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wybierz najpierw zawody')),
      );
    }
  }

  void _startCompetition() async{
    await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );  
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
                    ? _imagePaths[_selectedCompetitionIndex!]
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
                      imagePath: 'lib/images/buttonShooters.jpg',
                      text: 'Zawodnicy',
                      onPressed: _navigateToPlayersSelector,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      imagePath: 'lib/images/buttonShooters.jpg',
                      text: 'Zasady',
                      onPressed: () {
                        _navigateToRulesSelector();
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Zmniejszenie szerokości przycisku "Start"
                  SizedBox(
                    height: 100, // Ustawienie wysokości na bardziej kompaktową
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      backgroundColor: Colors.black,
                      text: 'Start',
                      onPressed: _startCompetition,
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