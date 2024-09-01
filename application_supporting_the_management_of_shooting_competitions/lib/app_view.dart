import 'package:application_supporting_the_management_of_shooting_competitions/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/pages/home_page.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/screens/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/sign_in_bloc/sign_in_bloc.dart';


class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth',
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if(state.status == AuthenticationStatus.authenticated) {
            return const HomePage();
          }
          else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}