import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/app.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'simple_bloc_observer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();

  final userRepository = FirebaseUserRepo();

  runApp(
    BlocProvider(
      create: (context) => SignInBloc(userRepository: userRepository), 
      child: App(userRepository),
    ),
  );
}