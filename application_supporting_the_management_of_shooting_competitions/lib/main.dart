import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/app.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'simple_bloc_observer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "keys.env");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow;
    }
  }

  Bloc.observer = SimpleBlocObserver();
  final userRepository = FirebaseUserRepo();

  runApp(
    BlocProvider(
      create: (context) => SignInBloc(userRepository: userRepository),
      child: App(userRepository),
    ),
  );
}
