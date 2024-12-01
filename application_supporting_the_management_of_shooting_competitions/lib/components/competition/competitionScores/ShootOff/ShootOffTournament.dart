import 'package:flutter/material.dart';

class ShootOffTournamentPhase extends StatelessWidget {
  final List<Map<String, dynamic>> bracket;
  final VoidCallback onEditMatch;
  final VoidCallback onEndCompetition;

  const ShootOffTournamentPhase({
    Key? key,
    required this.bracket,
    required this.onEditMatch,
    required this.onEndCompetition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: bracket.length,
            itemBuilder: (context, index) {
              final match = bracket[index];
              return ListTile(
                title: Text(
                  '${match['player1']['player'].player.firstName} '
                  'vs ${match['player2']['player'].player.firstName}',
                ),
                subtitle: Text(
                  'Czas (${match['player1']['player'].player.firstName}): ${match['time1']}, '
                  'Czas (${match['player2']['player'].player.firstName}): ${match['time2']}',
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: onEndCompetition,
          child: const Text('Zakończ turniej'),
        ),
      ],
    );
  }
}
