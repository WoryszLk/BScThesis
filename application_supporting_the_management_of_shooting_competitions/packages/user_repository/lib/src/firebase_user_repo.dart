import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class firebaseUserRepo implements UserRepository{
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('user');

  firebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user => throw UnimplementedError();

  @override
  Future<void> signIn(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) {
    throw UnimplementedError();
  }

   @override
  Future<void> setUserData(MyUser user) {
    throw UnimplementedError();
  }
}