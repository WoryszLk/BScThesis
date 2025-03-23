import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/generic_score.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player.dart';

class CompetitionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> addCompetition({
    required String competitionType,
    required List<PlayerWithId> players,
    required DateTime startDate,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      final competitionRef = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('competitions')
          .add({
        'competitionType': competitionType,
        'startDate': startDate,
        'players': players.map((p) => p.player.toMap()).toList(),
        'status': 'Ongoing',
      });
      return competitionRef.id;
    }
    throw Exception('User not authenticated');
  }

  Stream<List<CompetitionWithId>> getCompetitions() {
    final user = _auth.currentUser;
    if (user != null) {
      return firestore
          .collection('users')
          .doc(user.uid)
          .collection('competitions')
          .orderBy('startDate', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return CompetitionWithId(
            id: doc.id,
            competition: Competition.fromMap(doc.data() as Map<String, dynamic>),
          );
        }).toList();
      });
    }
    return const Stream.empty();
  }

  Future<void> savePlayerScores({
    required String competitionId,
    required List<GenericScore> playerScores,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      final ref = firestore
          .collection('users')
          .doc(user.uid)
          .collection('competitions')
          .doc(competitionId);
      await ref.update({
        'scores': playerScores.map((s) => s.toMap()).toList(),
      });
    }
  }

  Future<void> endCompetition(String competitionId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final ref = firestore
          .collection('users')
          .doc(user.uid)
          .collection('competitions')
          .doc(competitionId);
      await ref.update({
        'status': 'Zakończone',
      });
    }
  }

  Future<Map<String, dynamic>> getCompetitionReport(String competitionId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final competitionDoc = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('competitions')
          .doc(competitionId)
          .get();

      if (competitionDoc.exists) {
        final competitionData = competitionDoc.data()!;
        final competitionType =
            competitionData['competitionType']?.toLowerCase() ?? '';
        if (competitionType == 'shoot off') {
          final snapshot = await firestore
              .collection('users')
              .doc(user.uid)
              .collection('competitions')
              .doc(competitionId)
              .get();

          final playersMap = {
            for (var p in competitionData['players'] ?? []) p['id']: p
          };

          final bracket = (snapshot.data()?['tournamentBracket'] as List<dynamic>? ?? []);
          final shootOffMatches = bracket.map((match) {
            final p1Id = match['player1Id'];
            final p2Id = match['player2Id'];
            final wId = match['winner'];
            final lId = match['loser'];
            final p1Name = match['player1Name'] as String?;
            final p2Name = match['player2Name'] as String?;
            final wName = match['winnerName'] as String?;
            final lName = match['loserName'] as String?;
            final fallbackP1 = (p1Id != null && playersMap[p1Id] != null)
                ? '${playersMap[p1Id]['firstName']} ${playersMap[p1Id]['lastName']}'
                : 'Nieznany';
            final fallbackP2 = (p2Id != null && playersMap[p2Id] != null)
                ? '${playersMap[p2Id]['firstName']} ${playersMap[p2Id]['lastName']}'
                : 'Nieznany';
            final fallbackW = (wId != null && playersMap[wId] != null)
                ? '${playersMap[wId]['firstName']} ${playersMap[wId]['lastName']}'
                : 'Brak danych';
            final fallbackL = (lId != null && playersMap[lId] != null)
                ? '${playersMap[lId]['firstName']} ${playersMap[lId]['lastName']}'
                : 'Brak danych';

            final time1 = match['time1'] != null ? match['time1'].toString() : 'Brak czasu';
            final time2 = match['time2'] != null ? match['time2'].toString() : 'Brak czasu';

            return {
              'player1': p1Name ?? fallbackP1,
              'player2': p2Name ?? fallbackP2,
              'winner': wName ?? fallbackW,
              'loser': lName ?? fallbackL,
              'time1': time1,
              'time2': time2,
              'roundNumber': match['roundNumber'] ?? 1,
            };
          }).toList();

          final qualifications = (snapshot.data()?['qualificationScores'] as List<dynamic>? ?? []).map((qual) {
            final player = playersMap[qual['playerId']];
            return {
              'name': player != null
                  ? '${player['firstName']} ${player['lastName']}'
                  : 'Nieznany',
              'time1': qual.containsKey('time1') ? qual['time1'].toString() : 'Brak czasu',
              'time2': qual.containsKey('time2') ? qual['time2'].toString() : 'Brak czasu',
            };
          }).toList();

          final winner = competitionData['winner'] ?? 'Nieznany';
          return {
            'competitionInfo': {
              'name': competitionData['name'] ?? 'Nieznana',
              'type': competitionData['competitionType'] ?? 'Nieznany',
              'date': competitionData['startDate'] ?? 'Brak daty',
              'winner': winner,
            },
            'matches': shootOffMatches,
            'qualifications': qualifications,
          };
        }
        throw Exception('Nieobsługiwany typ zawodów: ${competitionData['competitionType']}');
      }
    }
    throw Exception('User not authenticated or competition not found');
  }
}

class CompetitionWithId {
  final String id;
  final Competition competition;

  CompetitionWithId({
    required this.id,
    required this.competition,
  });
}

class Competition {
  final String competitionType;
  final DateTime startDate;
  final List<Player> players;
  final String status;

  Competition({
    required this.competitionType,
    required this.startDate,
    required this.players,
    this.status = 'Ongoing',
  });

  Map<String, dynamic> toMap() {
    return {
      'competitionType': competitionType,
      'startDate': startDate.toIso8601String(),
      'players': players.map((p) => p.toMap()).toList(),
      'status': status,
    };
  }

  factory Competition.fromMap(Map<String, dynamic> map) {
    return Competition(
      competitionType: map['competitionType'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      players: (map['players'] as List<dynamic>)
          .map((item) => Player.fromMap(item as Map<String, dynamic>))
          .toList(),
      status: map['status'] ?? 'Ongoing',
    );
  }
}
