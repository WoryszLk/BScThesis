// ShootOffTournamentPhase.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';

class ShootOffTournamentPhase extends StatefulWidget {
  final List<Map<String, dynamic>> bracket;
  final Future<void> Function(List<Map<String, dynamic>> updatedBracket) onEditMatch;
  final String competitionId;
  final List<PlayerWithId> selectedPlayers;

  const ShootOffTournamentPhase({
    Key? key,
    required this.bracket,
    required this.onEditMatch,
    required this.competitionId,
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
    if (bracket.isNotEmpty) {
      currentPhase = bracket
          .map((m) => m['roundNumber'] ?? 1)
          .reduce((a, b) => a > b ? a : b);
    }
  }

  void _selectWinner(int matchIndex, String winnerField) {
    final currentMatches = _currentRoundMatches();
    final match = currentMatches[matchIndex];
    setState(() {
      final player1 = match['player1']?['player'];
      final player2 = match['player2']?['player'];

      if (winnerField == 'player1' && player1 != null) {
        match['winner'] = player1.id;
        match['winnerName'] = '${player1.player.firstName} ${player1.player.lastName}';
        match['loser'] = player2?.id;
        match['loserName'] = player2 != null
            ? '${player2.player.firstName} ${player2.player.lastName}'
            : null;
      } else if (winnerField == 'player2' && player2 != null) {
        match['winner'] = player2.id;
        match['winnerName'] = '${player2.player.firstName} ${player2.player.lastName}';
        match['loser'] = player1?.id;
        match['loserName'] = player1 != null
            ? '${player1.player.firstName} ${player1.player.lastName}'
            : null;
      }
    });
    _saveBracketToFirestore();
    _checkAndGenerateNextRound();
  }

  void _checkAndGenerateNextRound() {
    final currentMatches = _currentRoundMatches();
    final allHaveWinners = currentMatches.every((m) => m['winner'] != null);

    if (allHaveWinners && currentMatches.length > 1) {
      List<Map<String, dynamic>> nextRound = [];
      for (int i = 0; i < currentMatches.length; i += 2) {
        final p1Id = currentMatches[i]['winner'];
        final p1Name = currentMatches[i]['winnerName'];
        final p2Id = (i + 1 < currentMatches.length) ? currentMatches[i + 1]['winner'] : null;
        final p2Name = (i + 1 < currentMatches.length) ? currentMatches[i + 1]['winnerName'] : null;

        final player1Winner = widget.selectedPlayers.firstWhere(
          (p) => p.id == p1Id,
          orElse: () => PlayerWithId(
            id: 'unknown_id',
            player: Player(
              id: 'unknown_id',
              firstName: 'Nieznany',
              lastName: 'Nieznany',
            ),
          ),
        );

        if (p2Id != null) {
          final player2Winner = widget.selectedPlayers.firstWhere(
            (p) => p.id == p2Id,
            orElse: () => PlayerWithId(
              id: 'unknown_id',
              player: Player(
                id: 'unknown_id',
                firstName: 'Nieznany',
                lastName: 'Nieznany',
              ),
            ),
          );
          nextRound.add({
            'player1': {'player': player1Winner},
            'player1Name': p1Name,
            'player2': {'player': player2Winner},
            'player2Name': p2Name,
            'winner': null,
            'loser': null,
            'winnerName': null,
            'loserName': null,
            'roundNumber': currentPhase + 1,
          });
        } else {
          nextRound.add({
            'player1': {'player': player1Winner},
            'player1Name': p1Name,
            'player2': null,
            'player2Name': null,
            'winner': p1Id,
            'loser': null,
            'winnerName': p1Name,
            'loserName': null,
            'roundNumber': currentPhase + 1,
          });
        }
      }
      setState(() {
        bracket.addAll(nextRound);
        currentPhase++;
      });
      _saveBracketToFirestore();
    }
  }

  List<Map<String, dynamic>> _currentRoundMatches() {
    return bracket
        .where((m) => (m['roundNumber'] ?? 1) == currentPhase)
        .toList();
  }

  Future<void> _saveBracketToFirestore() async {
    try {
      final bracketData = bracket.map((m) {
        final p1 = m['player1']?['player'];
        final p2 = m['player2']?['player'];
        return {
          'player1Id': p1 != null ? p1.id : null,
          'player2Id': p2 != null ? p2.id : null,
          'winner': m['winner'],
          'loser': m['loser'],
          'winnerName': m['winnerName'],
          'loserName': m['loserName'],
          'roundNumber': m['roundNumber'],
          'player1Name': m['player1Name'],
          'player2Name': m['player2Name'],
        };
      }).toList();
      await widget.onEditMatch(bracketData);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onEndCompetition(BuildContext context) async {
    try {
      if (bracket.isEmpty) {
        throw Exception('Drabinka jest pusta.');
      }
      final maxRound = bracket
          .map((m) => m['roundNumber'] ?? 1)
          .reduce((a, b) => a > b ? a : b);
      final lastMatches = bracket
          .where((m) => m['roundNumber'] == maxRound)
          .toList();
      if (lastMatches.isEmpty) {
        throw Exception('Brak meczu w ostatniej rundzie.');
      }
      final lastMatch = lastMatches.last;
      final winnerId = lastMatch['winner'];
      if (winnerId == null) {
        throw Exception('Brak zwycięzcy w ostatnim meczu.');
      }
      final winner = widget.selectedPlayers.firstWhere(
        (p) => p.id == winnerId,
        orElse: () => PlayerWithId(
          id: 'unknown_id',
          player: Player(
            id: 'unknown_id',
            firstName: 'Nieznany',
            lastName: 'Nieznany',
          ),
        ),
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Brak zalogowanego użytkownika.');
      }
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('competitions')
          .doc(widget.competitionId);
      await ref.update({
        'status': 'Zakończone',
        'winner': '${winner.player.firstName} ${winner.player.lastName}',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zawody zostały zakończone.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final matches = _currentRoundMatches();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Faza $currentPhase',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final m = matches[index];
              final p1 = m['player1']?['player'];
              final p2 = m['player2']?['player'];
              final w = m['winner'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: p1 != null
                                ? () => _selectWinner(index, 'player1')
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: w == p1?.id
                                    ? Colors.green.withOpacity(0.7)
                                    : (w == p2?.id
                                        ? Colors.red.withOpacity(0.3)
                                        : Colors.white),
                                border: Border.all(color: Colors.black, width: 1),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                child: p1 != null
                                    ? Text(
                                        '${p1.player.firstName} ${p1.player.lastName}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const Text('---'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (p2 != null)
                          const Text(
                            'vs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: p2 != null
                                ? () => _selectWinner(index, 'player2')
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: w == p2?.id
                                    ? Colors.green.withOpacity(0.7)
                                    : (w == p1?.id
                                        ? Colors.red.withOpacity(0.3)
                                        : Colors.white),
                                border: Border.all(color: Colors.black, width: 1),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                child: p2 != null
                                    ? Text(
                                        '${p2.player.firstName} ${p2.player.lastName}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const Text('---'),
                              ),
                            ),
                          ),
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
          onPressed: () => _onEndCompetition(context),
          child: const Text('Zakończ turniej'),
        ),
      ],
    );
  }
}
