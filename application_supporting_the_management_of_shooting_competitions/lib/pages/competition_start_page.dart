import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/pages/competition_rules_page.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/pages/home_page.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/pages/player_list_selector_page.dart';
import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/custom_button.dart';
import 'competition_selector_page.dart';

class StarterCompetition extends StatefulWidget {
  const StarterCompetition({super.key});

  @override
  _StarterCompetitionState createState() => _StarterCompetitionState();
}

class _StarterCompetitionState extends State<StarterCompetition> {
  int? _selectedCompetitionIndex;
  List<PlayerWithId> _selectedPlayers = [];
  final CompetitionService _competitionService = CompetitionService();

  final List<String> _competitionNames = [
    'FBI',
    'PIRO',
    'Shoot off',
    'Piromanek',
    'Top Gun',
    'BTG',
  ];

  final List<String> _imagePaths = [
    'lib/images/fbi.jpg',
    'lib/images/piro.jpg',
    'lib/images/ShootOff.jpg',
    'lib/images/btg.jpg',
    'lib/images/nra.jpg',
    'lib/images/top_gun.jpg',
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
    final selectedPlayers = await Navigator.push<List<PlayerWithId>>(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerListSelector(
          selectedPlayers: _selectedPlayers,
        ),
      ),
    );

    if (selectedPlayers != null) {
      setState(() {
        _selectedPlayers = selectedPlayers;
      });
    }
  }

  void _navigateToRulesSelector() async {
    if (_selectedCompetitionIndex != null) {
      final selectedCompetition = _competitionNames[_selectedCompetitionIndex!];
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompetitionRulesPage(
            selectedCompetition: selectedCompetition,
            selectedPlayers: _selectedPlayers,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wybierz najpierw zawody')),
      );
    }
  }

  void _startCompetition() async {
    if (_selectedCompetitionIndex != null && _selectedPlayers.isNotEmpty) {
      final selectedCompetition = _competitionNames[_selectedCompetitionIndex!];

      await _competitionService.addCompetition(
        competitionType: selectedCompetition,
        players: _selectedPlayers,
        startDate: DateTime.now(),
      );

      setState(() {
        _selectedPlayers = [];
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wybierz typ zawodów i zawodników')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rozpocznij zawody'),
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
                      imagePath: 'lib/images/zawodnicy.jpg',
                      text: 'Zawodnicy',
                      onPressed: _navigateToPlayersSelector,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      imagePath: 'lib/images/zasady.jpg',
                      text: 'Zasady',
                      onPressed: _navigateToRulesSelector,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
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
