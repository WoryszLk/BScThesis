import 'dart:ui';
import 'package:application_supporting_the_management_of_shooting_competitions/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/pages/sign_in_screen.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/pages/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ClipPath(
                  clipper: _WaveClipper(), 
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.2,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF4A90E2), Color(0xFF007AFF)], // Niebieski gradient
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).size.height * 0.35,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'lib/images/shooterlogo.png',
                    height: 120,
                    width: 120,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: TabBar(
                          controller: tabController,
                          unselectedLabelColor: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.5),
                          labelColor: Theme.of(context).colorScheme.onBackground,
                          tabs: const [
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            const SignInScreen(),
                            BlocProvider<SignUpBloc>(
                              create: (context) => SignUpBloc(
                                userRepository:
                                context.read<AuthenticationBloc>().userRepository,
                              ),
                              child: const SignUpScreen(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
      size.width * 0.5, size.height, 
      size.width, size.height - 100,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
