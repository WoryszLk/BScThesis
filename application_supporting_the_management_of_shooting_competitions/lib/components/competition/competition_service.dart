import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/generic_score.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/players/player.dart';

class CompetitionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addCompetition({
    required String competitionType,
    required List<PlayerWithId> players,
    required DateTime startDate,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      await firestore.collection('users').doc(user.uid).collection('competitions').add({
        'competitionType': competitionType,
        'startDate': startDate,
        'players': players.map((playerWithId) => playerWithId.player.toMap()).toList(),
        'status': 'Ongoing',
      });
    }
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
      final competitionRef = firestore.collection('users').doc(user.uid).collection('competitions').doc(competitionId);
      await competitionRef.update({
        'scores': playerScores.map((score) => score.toMap()).toList(),
      });
    }
  }

  Future<void> endCompetition(String competitionId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final competitionRef = firestore.collection('users').doc(user.uid).collection('competitions').doc(competitionId);
      await competitionRef.update({
        'status': 'Zakończone',
      });
    }
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
      'players': players.map((player) => player.toMap()).toList(),
      'status': status,
    };
  }

  factory Competition.fromMap(Map<String, dynamic> map) {
    return Competition(
      competitionType: map['competitionType'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      players: (map['players'] as List<dynamic>).map((item) => Player.fromMap(item as Map<String, dynamic>)).toList(),
      status: map['status'] ?? 'Ongoing',
    );
  }
}
