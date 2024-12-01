import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  late List<List<Map<String, dynamic>>> tournamentRounds;
  bool isQualificationPhase = true;

  @override
  void initState() {
    super.initState();
    _loadResultsFromFirestore();
    tournamentRounds = [];
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
          final scores = List<Map<String, dynamic>>.from(snapshot.data()!['qualificationScores']);
          setState(() {
            playerResults = scores.map((score) {
              final player = widget.selectedPlayers.firstWhere(
                (p) => p.id == score['playerId'],
              );
              return {
                'player': player,
                'time1': score['time1'] ?? 0.0,
                'time2': score['time2'] ?? 0.0,
                'total': score['total'] ?? 0.0,
              };
            }).toList();
          });
        } else {
          _initializePlayerResults();
        }

        if (snapshot.data()!['tournamentRounds'] != null) {
          final rounds = List<dynamic>.from(snapshot.data()!['tournamentRounds']);
          setState(() {
            tournamentRounds = rounds.map((round) {
              return List<Map<String, dynamic>>.from(round.map((match) {
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
              }));
            }).toList();
          });
        }
      } else {
        _initializePlayerResults();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd podczas ładowania wyników: $e')),
      );
    }
  }

  void _initializePlayerResults() {
    setState(() {
      playerResults = widget.selectedPlayers.map((player) {
        return {
          'player': player,
          'time1': 0.0,
          'time2': 0.0,
          'total': 0.0,
        };
      }).toList();
    });
  }

  Future<void> _saveResultsToFirestore() async {
    final scores = playerResults.map((result) {
      return {
        'playerId': result['player'].id,
        'time1': result['time1'],
        'time2': result['time2'],
        'total': result['total'],
      };
    }).toList();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('competitions')
        .doc(widget.competitionId)
        .update({'qualificationScores': scores});
  }

  Future<void> _saveTournamentRoundsToFirestore() async {
    final roundsData = tournamentRounds.map((round) {
      return round.map((match) {
        return {
          'player1Id': match['player1']['player'].id,
          'player2Id': match['player2']['player'].id,
          'time1': match['time1'],
          'time2': match['time2'],
          'winner': match['winner'] != null ? match['winner'].id : null,
        };
      }).toList();
    }).toList();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('competitions')
        .doc(widget.competitionId)
        .update({'tournamentRounds': roundsData});
  }

  void _removePlayer(int index) {
    setState(() {
      playerResults.removeAt(index);
    });
    _saveResultsToFirestore();
  }

  void _sortResults() {
    setState(() {
      playerResults.sort((a, b) {
        final bestA = a['time1'] < a['time2'] ? a['time1'] : a['time2'];
        final bestB = b['time1'] < b['time2'] ? b['time1'] : b['time2'];
        return bestA.compareTo(bestB);
      });
    });
    _saveResultsToFirestore();
  }

  void _generateBracket() {
    if (playerResults.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brak wyników do wygenerowania turnieju!')),
      );
      return;
    }

    setState(() {
      isQualificationPhase = false;
      tournamentRounds = [];
      final firstRound = <Map<String, dynamic>>[];
      for (int i = 0; i < playerResults.length ~/ 2; i++) {
        firstRound.add({
          'player1': playerResults[i],
          'player2': playerResults[playerResults.length - i - 1],
          'time1': 0.0,
          'time2': 0.0,
          'winner': null,
        });
      }
      tournamentRounds.add(firstRound);
    });
    _saveTournamentRoundsToFirestore();
  }

  void _generateNextRound() {
    final currentRound = tournamentRounds.last;
    final nextRound = <Map<String, dynamic>>[];

    for (final match in currentRound) {
      if (match['winner'] != null) {
        nextRound.add({'player': match['winner'], 'time1': 0.0, 'time2': 0.0});
      }
    }

    if (nextRound.length > 1) {
      setState(() {
        tournamentRounds.add([]);
        for (int i = 0; i < nextRound.length ~/ 2; i++) {
          tournamentRounds.last.add({
            'player1': nextRound[i],
            'player2': nextRound[nextRound.length - i - 1],
            'time1': 0.0,
            'time2': 0.0,
            'winner': null,
          });
        }
      });
    } else {
      _endCompetition();
    }

    _saveTournamentRoundsToFirestore();
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

  Widget _buildQualificationPhase() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: playerResults.length,
            itemBuilder: (context, index) {
              final result = playerResults[index];
              return ListTile(
                title: Text(
                  '${result['player'].player.firstName} ${result['player'].player.lastName}',
                ),
                subtitle: Text(
                  'Czas 1: ${result['time1']}, Czas 2: ${result['time2']}, Total: ${result['total']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editPlayerTimes(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removePlayer(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _sortResults,
              child: const Text('Sortuj wyniki'),
            ),
            ElevatedButton(
              onPressed: _generateBracket,
              child: const Text('Przejdź do turnieju'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTournamentPhase() {
    final List<Map<String, dynamic>> currentRound = tournamentRounds.isNotEmpty
        ? List<Map<String, dynamic>>.from(tournamentRounds.last)
        : [];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: currentRound.length,
            itemBuilder: (context, index) {
              final match = currentRound[index];
              return ListTile(
                title: Text(
                  '${match['player1']['player'].player.firstName} '
                  'vs ${match['player2']['player'].player.firstName}',
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Czas (${match['player1']['player'].player.firstName}): ${match['time1']}'),
                    Text('Czas (${match['player2']['player'].player.firstName}): ${match['time2']}'),
                    if (match['winner'] != null)
                      Text(
                        'Zwycięzca: ${match['winner'].firstName} ${match['winner'].lastName}',
                        style: const TextStyle(color: Colors.green),
                      ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editMatchTimes(index, currentRound),
                ),
              );
            },
          ),
        ),
        if (currentRound.length > 1)
          ElevatedButton(
            onPressed: _generateNextRound,
            child: const Text('Przejdź do następnej rundy'),
          ),
        if (currentRound.length == 1)
          ElevatedButton(
            onPressed: _endCompetition,
            child: const Text('Zakończ turniej'),
          ),
      ],
    );
  }

  void _editPlayerTimes(int index) {
    final player = playerResults[index];
    final time1Controller = TextEditingController(text: player['time1'].toString());
    final time2Controller = TextEditingController(text: player['time2'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edytuj czasy: ${player['player'].player.firstName} ${player['player'].player.lastName}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: time1Controller,
                decoration: const InputDecoration(labelText: 'Czas 1'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: time2Controller,
                decoration: const InputDecoration(labelText: 'Czas 2'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  player['time1'] = double.tryParse(time1Controller.text) ?? 0.0;
                  player['time2'] = double.tryParse(time2Controller.text) ?? 0.0;
                  player['total'] = player['time1'] + player['time2'];
                });
                _saveResultsToFirestore();
                Navigator.pop(context);
              },
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    );
  }

  void _editMatchTimes(int index, List<Map<String, dynamic>> round) {
    final match = round[index];
    final time1Controller = TextEditingController(text: match['time1'].toString());
    final time2Controller = TextEditingController(text: match['time2'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edytuj wyniki meczu: ${match['player1']['player'].player.firstName} '
            'vs ${match['player2']['player'].player.firstName}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: time1Controller,
                decoration: InputDecoration(
                  labelText: 'Czas (${match['player1']['player'].player.firstName})',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: time2Controller,
                decoration: InputDecoration(
                  labelText: 'Czas (${match['player2']['player'].player.firstName})',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  match['time1'] = double.tryParse(time1Controller.text) ?? 0.0;
                  match['time2'] = double.tryParse(time2Controller.text) ?? 0.0;

                  if (match['time1'] < match['time2']) {
                    match['winner'] = match['player1']['player'];
                  } else {
                    match['winner'] = match['player2']['player'];
                  }
                });
                _saveTournamentRoundsToFirestore();
                Navigator.pop(context);
              },
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isQualificationPhase ? 'Faza Kwalifikacyjna' : 'Faza Turniejowa'),
      ),
      body: isQualificationPhase ? _buildQualificationPhase() : _buildTournamentPhase(),
    );
  }
}
