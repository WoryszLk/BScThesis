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
        if (snapshot.data()!['qualificationScores'] != null) {
          final scores = snapshot.data()!['qualificationScores'] as List<dynamic>;
          setState(() {
            playerResults = scores.map((score) {
              final player = widget.selectedPlayers.firstWhere(
                (p) => p.id == score['playerId'],
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

        if (snapshot.data()!['tournamentBracket'] != null) {
          final bracketData = snapshot.data()!['tournamentBracket'] as List<dynamic>;
          setState(() {
            bracket = bracketData.map((match) {
              final player1 = widget.selectedPlayers.firstWhere(
                (p) => p.id == match['player1Id'],
              );
              final player2 = widget.selectedPlayers.firstWhere(
                (p) => p.id == match['player2Id'],
              );
              return {
                'player1': {'player': player1},
                'player2': {'player': player2},
                'time1': match['time1'] ?? 0.0,
                'time2': match['time2'] ?? 0.0,
                'winner': match['winner'],
              };
            }).toList();
          });
        }
      } else {
        _initializePlayerResults();
      }
    } catch (e) {
      print("Error loading data: $e");
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

  Future<void> _saveResultsToFirestore(List<Map<String, dynamic>> updatedResults) async {
    final scores = updatedResults.map((result) {
      return {
        'playerId': result['player'].id,
        'time1': result['time1'],
        'time2': result['time2'],
      };
    }).toList();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('competitions')
        .doc(widget.competitionId)
        .update({'qualificationScores': scores});
  }

  Future<void> _saveBracketToFirestore(List<Map<String, dynamic>> updatedBracket) async {
    try {
      print("Saving bracket data: $updatedBracket");

      final bracketData = updatedBracket.map((match) {
        final player1 = match['player1']?['player'];
        final player2 = match['player2']?['player'];
        final winner = match['winner'];

        return {
          'player1Id': player1 != null ? player1.id : null,
          'player2Id': player2 != null ? player2.id : null,
          'winner': winner,
        };
      }).toList();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('competitions')
          .doc(widget.competitionId)
          .update({'tournamentBracket': bracketData});

      print("Bracket data saved successfully");
    } catch (e) {
      print("Error saving bracket data: $e");
    }
  }

  void _generateBracket() {
    setState(() {
      isQualificationPhase = false;
      bracket = [];
      for (int i = 0; i < playerResults.length ~/ 2; i++) {
        bracket.add({
          'player1': playerResults[i],
          'player2': playerResults[playerResults.length - i - 1],
          'winner': null,
        });
      }
    });
    _saveBracketToFirestore(bracket);
  }

  Future<void> _endCompetition() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('competitions')
          .doc(widget.competitionId)
          .update({'status': 'Zakończone'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Zawody zostały zakończone.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd podczas kończenia zawodów: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Wczytywanie...'),
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
              onSaveResults: _saveResultsToFirestore,
              onGenerateBracket: _generateBracket,
            )
          : ShootOffTournamentPhase(
              bracket: bracket,
              onEditMatch: _saveBracketToFirestore,
              onEndCompetition: _endCompetition,
              selectedPlayers: widget.selectedPlayers,
            ),
    );
  }
}
