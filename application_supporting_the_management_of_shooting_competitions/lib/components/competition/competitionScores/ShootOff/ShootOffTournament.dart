import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';
import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player.dart';

class ShootOffTournamentPhase extends StatefulWidget {
  final List<Map<String, dynamic>> bracket;
  final Future<void> Function(List<Map<String, dynamic>> updatedBracket) onEditMatch;
  final VoidCallback onEndCompetition;
  final List<PlayerWithId> selectedPlayers;

  const ShootOffTournamentPhase({
    Key? key,
    required this.bracket,
    required this.onEditMatch,
    required this.onEndCompetition,
    required this.selectedPlayers,
  }) : super(key: key);

  @override
  _ShootOffTournamentPhaseState createState() => _ShootOffTournamentPhaseState();
}

class _ShootOffTournamentPhaseState extends State<ShootOffTournamentPhase> {
  late List<Map<String, dynamic>> bracket;
  int currentPhase = 1;

  @override
  void initState() {
    super.initState();
    bracket = widget.bracket;
  }

  void _selectWinner(int matchIndex, String winnerField) {
    setState(() {
      final match = bracket[matchIndex];
      final player1 = match['player1']?['player'];
      final player2 = match['player2']?['player'];

      if (winnerField == 'player1' && player1 != null) {
        match['winner'] = player1.id;
      } else if (winnerField == 'player2' && player2 != null) {
        match['winner'] = player2.id;
      }

      _checkAndGenerateNextRound();
    });
    _saveBracketToFirestore();
  }

  void _checkAndGenerateNextRound() {
    bool allMatchesHaveWinners = bracket.every((match) => match['winner'] != null);

    if (allMatchesHaveWinners && bracket.length > 1) {
      List<Map<String, dynamic>> nextRound = [];
      for (int i = 0; i < bracket.length; i += 2) {
        final player1WinnerId = bracket[i]['winner'];
        final player2WinnerId = (i + 1 < bracket.length) ? bracket[i + 1]['winner'] : null;

        final player1Winner = widget.selectedPlayers.firstWhere((p) => p.id == player1WinnerId);

        if (player2WinnerId != null) {
          final player2Winner = widget.selectedPlayers.firstWhere((p) => p.id == player2WinnerId);
          nextRound.add({
            'player1': {'player': player1Winner},
            'player2': {'player': player2Winner},
            'winner': null,
          });
        } else {
          nextRound.add({
            'player1': {'player': player1Winner},
            'player2': null,
            'winner': player1WinnerId,
          });
        }
      }
      setState(() {
        bracket = nextRound;
        currentPhase++;
      });
    }
  }

  Future<void> _saveBracketToFirestore() async {
    try {
      final bracketData = bracket.map((match) {
        final player1 = match['player1']?['player'];
        final player2 = match['player2']?['player'];
        final winner = match['winner'];

        return {
          'player1Id': player1 != null ? player1.id : null,
          'player2Id': player2 != null ? player2.id : null,
          'winner': winner,
        };
      }).toList();

      await widget.onEditMatch(bracketData);
    } catch (e) {
      print("Error saving bracket data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Faza $currentPhase',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: bracket.length,
            itemBuilder: (context, index) {
              final match = bracket[index];
              final player1 = match['player1']?['player'];
              final player2 = match['player2']?['player'];
              final winner = match['winner'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: player1 != null ? () => _selectWinner(index, 'player1') : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: winner == player1?.id
                                        ? Colors.green.withOpacity(0.7)
                                        : (winner == player2?.id ? Colors.red.withOpacity(0.3) : Colors.white),
                                    border: Border.all(color: Colors.black, width: 1.0),
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: player1 != null
                                        ? Text(
                                            '${player1 is PlayerWithId ? player1.player.firstName : player1.firstName ?? ''} ${player1 is PlayerWithId ? player1.player.lastName : player1.lastName ?? ''}',
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: player2 != null
                                  ? const Text(
                                      'vs',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: GestureDetector(
                                onTap: player2 != null ? () => _selectWinner(index, 'player2') : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: winner == player2?.id
                                        ? Colors.green.withOpacity(0.7)
                                        : (winner == player1?.id ? Colors.red.withOpacity(0.3) : Colors.white),
                                    border: Border.all(color: Colors.black, width: 1.0),
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: player2 != null
                                        ? Text(
                                            '${player2 is PlayerWithId ? player2.player.firstName : player2.firstName ?? ''} ${player2 is PlayerWithId ? player2.player.lastName : player2.lastName ?? ''}',
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: widget.onEndCompetition,
          child: const Text('Zakończ turniej'),
        ),
      ],
    );
  }
}
