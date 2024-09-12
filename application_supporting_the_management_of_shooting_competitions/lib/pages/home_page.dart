import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/blocs/authentication_bloc/authentication_bloc.dart';
import 'competition_start_page.dart';
import 'player_list_selector_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); 
              },
            );
          },
        ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StarterCompetition()));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Lista zawodników'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayerList()));
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Historia zawodów'),
              onTap: () {
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainOptionCard(
              context,
              'Rozpocznij zawody',
              'lib/images/ZacznijZawody.jpg',
              Icons.flag,
              const StarterCompetition(),
            ),
            const SizedBox(height: 16),

            const Text(
              'Wybierz opcję',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180, 
              child: ListView(
                scrollDirection: Axis.horizontal, 
                children: [
                  _buildOptionCard(
                    context,
                    'Zawody które trwają',
                    'lib/images/PlayersList.jpg',
                    Icons.sports,
                    const PlayerList(),
                  ),
                  const SizedBox(width: 8), 
                  _buildOptionCard(
                    context,
                    'Historia zawodów',
                    'lib/images/buttonShooters.jpg',
                    Icons.history,
                    null, 
                  ),
                  const SizedBox(width: 8),
                  _buildOptionCard(
                    context,
                    'Testing',
                    null,
                    Icons.cloud_upload,
                    null, 
                  ),
                  const SizedBox(width: 8),  
                  _buildOptionCard(
                    context,
                    'New Option',
                    'lib/images/newImage.jpg',
                    Icons.new_releases,
                    null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildCompetitionHistoryCard('Zawody 1', '10 kwietnia 2023', 'Zakończone'),
                  _buildCompetitionHistoryCard('Zawody 2', '22 kwietnia 2023', 'Zakończone'),
                  _buildCompetitionHistoryCard('Zawody 3', '15 kwietnia 2023', 'Zakończone'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainOptionCard(BuildContext context, String title, String? imagePath, IconData icon, Widget? route) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => route));
        }
      },
      child: Container(
        width: double.infinity,  // Szerokość na cały ekran
        height: 200, // Wysokość większa niż zwykłe karty
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          image: imagePath != null
              ? DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                )
              : null, 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(icon, size: 50, color: Colors.white), // Większa ikona
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,  // Większy tekst
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, String? imagePath, IconData icon, Widget? route) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => route));
        }
      },
      child: Container(
        width: 180,  
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          image: imagePath != null
              ? DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                )
              : null, 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Testing
  Widget _buildCompetitionHistoryCard(String title, String date, String status) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          Text(
            status,
            style: TextStyle(
              color: status == 'Zakończone' ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
