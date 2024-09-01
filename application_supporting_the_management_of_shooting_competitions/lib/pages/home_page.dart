import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/blocs/authentication_bloc/authentication_bloc.dart';
import 'competition_start_page.dart';
import 'player_list_selector_page.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state.status == AuthenticationStatus.authenticated && state.user != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menu',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Zalogowany jako:',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          state.user!.displayName ?? state.user!.email!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          state.user!.email!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text(
                      'Niezalogowany',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                      ),
                    );
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Strona główna'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.sports),
              title: Text('Rozpocznij zawody'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const StarterCompetition()));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Lista zawodników'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PlayerList()));
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Historia zawodów'),
              onTap: () {
                // Implementacja dla historii zawodów
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomButton(
              width: double.infinity,
              height: 450,
              imagePath: 'lib/images/ZacznijZawody.jpg',
              text: 'Rozpocznij zawody',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const StarterCompetition()));
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      imagePath: 'lib/images/PlayersList.jpg',
                      text: 'Zawody które trwają',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const PlayerList()));
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: CustomButton(
                            width: double.infinity,
                            height: double.infinity,
                            imagePath: 'lib/images/buttonShooters.jpg',
                            text: 'Historia 3',
                            onPressed: () {
                              // Implementacja dla historii 3
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: CustomButton(
                            width: double.infinity,
                            height: double.infinity,
                            imagePath: 'lib/images/buttonShooters.jpg',
                            text: 'Tile 4',
                            onPressed: () {
                              // Implementacja dla Tile 4
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
