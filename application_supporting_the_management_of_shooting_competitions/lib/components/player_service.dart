import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'player.dart';

class PlayerService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPlayer(Player player) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('players')
          .add(player.toMap());
    }
  }

  Future<void> deletePlayer(String playerId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('players')
          .doc(playerId)
          .delete();
    }
  }

  Stream<List<PlayerWithId>> getPlayers() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('players')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => PlayerWithId(
                  id: doc.id,
                  player: Player.fromMap(doc.data() as Map<String, dynamic>)))
              .toList());
    }
    return const Stream.empty();
  }
}

class PlayerWithId {
  final String id;
  final Player player;

  PlayerWithId({
    required this.id,
    required this.player,
  });
}