import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/app.dart';
import 'simple_bloc_observer.dart';
import 'firebase_options.dart';


void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
	Bloc.observer = SimpleBlocObserver();
  runApp(App(FirebaseUserRepo()));
}