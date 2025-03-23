import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competitionScores/ShootOff/ShootOffQualification.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competitionScores/ShootOff/ShootOffTournament.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player.dart';

class ShootOffPage extends StatefulWidget {
  final List<PlayerWithId> selectedPlayers;
  final String competitionId;

  const ShootOffPage({
    Key? key,
    required this.selectedPlayers,
    required this.competitionId,
  }) : super(key: key);

  @override
  _ShootOffPageState createState() => _ShootOffPageState();
}

class _ShootOffPageState extends State<ShootOffPage> {
  late List<Map<String, dynamic>> playerResults = [];
  late List<Map<String, dynamic>> bracket = [];
  bool isQualificationPhase = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResultsFromFirestore();
  }

  Future<void> _loadResultsFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('competitions')
          .doc(widget.competitionId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        if (data['qualificationScores'] != null) {
          final scores = data['qualificationScores'] as List<dynamic>;
          setState(() {
            playerResults = scores.map((score) {
              final player = widget.selectedPlayers.firstWhere(
                (p) => p.id == score['playerId'],
                orElse: () => PlayerWithId(
                  id: score['playerId'] ?? 'unknown_id',
                  player: Player(
                    id: score['playerId'] ?? 'unknown_id',
                    firstName: 'Nieznany',
                    lastName: 'Nieznany',
                  ),
                ),
              );
              return {
                'player': player,
                'time1': score['time1'] ?? 0.0,
                'time2': score['time2'] ?? 0.0,
              };
            }).toList();
          });
        } else {
          _initializePlayerResults();
        }

        if (data['tournamentBracket'] != null) {
          final bracketData = data['tournamentBracket'] as List<dynamic>;
          setState(() {
            bracket = bracketData.map((match) {
              final player1 = widget.selectedPlayers.firstWhere(
                (p) => p.id == match['player1Id'],
                orElse: () => PlayerWithId(
                  id: 'unknown_id',
                  player: Player(
                    id: 'unknown_id',
                    firstName: 'Nieznany',
                    lastName: 'Nieznany',
                  ),
                ),
              );
              final player2 = widget.selectedPlayers.firstWhere(
                (p) => p.id == match['player2Id'],
                orElse: () => PlayerWithId(
                  id: 'unknown_id',
                  player: Player(
                    id: 'unknown_id',
                    firstName: 'Nieznany',
                    lastName: 'Nieznany',
                  ),
                ),
              );
              return {
                'player1': {'player': player1},
                'player2': {'player': player2},
                'time1': match['time1'] ?? 0.0,
                'time2': match['time2'] ?? 0.0,
                'winner': match['winner'],
                'roundNumber': match['roundNumber'] ?? 1,
              };
            }).toList();
          });
        }
      } else {
        _initializePlayerResults();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd podczas ładowania danych: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _initializePlayerResults() {
    setState(() {
      playerResults = widget.selectedPlayers.map((player) {
        return {
          'player': player,
          'time1': 0.0,
          'time2': 0.0,
        };
      }).toList();
    });
  }

  Future<void> _saveBracketToFirestore(List<Map<String, dynamic>> updatedBracket) async {
    try {
      final bracketData = updatedBracket.map((match) {
        final player1 = match['player1']?['player'];
        final player2 = match['player2']?['player'];
        final winner = match['winner'];
        final roundNumber = match['roundNumber'] ?? 1;

        return {
          'player1Id': player1?.id ?? null,
          'player2Id': player2?.id ?? null,
          'winner': winner,
          'time1': match['time1'] ?? 0.0,
          'time2': match['time2'] ?? 0.0,
          'roundNumber': roundNumber,
        };
      }).toList();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('competitions')
          .doc(widget.competitionId)
          .update({'tournamentBracket': bracketData});

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd zapisu drabinki: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _generateBracket() {
    setState(() {
      isQualificationPhase = false;
      bracket = [];
      int roundNumber = 1;

      for (int i = 0; i < playerResults.length ~/ 2; i++) {
        final player1 = playerResults[i]['player'];
        final player2 = playerResults[playerResults.length - i - 1]['player'];
        bracket.add({
          'player1': {'player': player1},
          'player2': {'player': player2},
          'time1': 0.0,
          'time2': 0.0,
          'winner': null,
          'roundNumber': roundNumber,
        });
      }
    });
    _saveBracketToFirestore(bracket);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Wczytywanie...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isQualificationPhase ? 'Faza Kwalifikacyjna' : 'Faza Turniejowa'),
      ),
      body: isQualificationPhase
          ? ShootOffQualificationPhase(
              playerResults: playerResults,
              onSaveResults: _saveBracketToFirestore,
              onGenerateBracket: _generateBracket,
            )
          : ShootOffTournamentPhase(
              bracket: bracket,
              onEditMatch: _saveBracketToFirestore,
              competitionId: widget.competitionId,
              selectedPlayers: widget.selectedPlayers,
            ),
    );
  }
}
