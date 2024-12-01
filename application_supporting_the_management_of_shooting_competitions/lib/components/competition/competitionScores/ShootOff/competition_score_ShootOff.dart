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
  late List<Map<String, dynamic>> playerResults;
  late List<Map<String, dynamic>> bracket;
  bool isQualificationPhase = true;

  @override
  void initState() {
    super.initState();
    _loadResultsFromFirestore();
    bracket = [];
  }

  Future<void> _loadResultsFromFirestore() async {
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
              'winner': match['winner'] != null
                  ? widget.selectedPlayers.firstWhere((p) => p.id == match['winner'])
                  : null,
            };
          }).toList();
        });
      }
    } else {
      _initializePlayerResults();
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

  Future<void> _saveBracketToFirestore() async {
    final bracketData = bracket.map((match) {
      return {
        'player1Id': match['player1']['player'].id,
        'player2Id': match['player2']['player'].id,
        'time1': match['time1'],
        'time2': match['time2'],
        'winner': match['winner'] != null ? match['winner'].id : null,
      };
    }).toList();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('competitions')
        .doc(widget.competitionId)
        .update({'tournamentBracket': bracketData});
  }

  void _generateBracket() {
    setState(() {
      isQualificationPhase = false;
      bracket = [];
      for (int i = 0; i < playerResults.length ~/ 2; i++) {
        bracket.add({
          'player1': playerResults[i],
          'player2': playerResults[playerResults.length - i - 1],
          'time1': 0.0,
          'time2': 0.0,
          'winner': null,
        });
      }
    });
    _saveBracketToFirestore();
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
            ),
    );
  }
}
