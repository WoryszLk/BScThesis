import 'package:application_supporting_the_management_of_shooting_competitions/components/burgerMenu/burger_menu.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_details.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/pages/competition_start_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final burgerMenu = BurgerMenu();

    return Scaffold(
      appBar: burgerMenu.buildAppBar(context),
      drawer: burgerMenu, 
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

            // Wyświetlanie ostatnich zawodów
            Expanded(
              child: _buildRecentCompetitions(context),
            ),
          ],
        ),
      ),
    );
  }

  // Funkcja budująca widok ostatnich zawodów
  Widget _buildRecentCompetitions(BuildContext context) {
    final CompetitionService competitionService = CompetitionService();

    return StreamBuilder<List<CompetitionWithId>>(
      stream: competitionService.getCompetitions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final competitions = snapshot.data!.take(5).toList();
          return ListView.builder(
            itemCount: competitions.length,
            itemBuilder: (context, index) {
              final competition = competitions[index].competition;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompetitionDetailsPage(competitionWithId: competitions[index]),
                    ),
                  );
                },
                child: _buildCompetitionHistoryCard(
                  competition.competitionType,
                  competition.startDate.toLocal().toString().split(' ')[0],
                  'Zakończone', // DO zmiany - > dynamiczny status
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Błąd: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
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
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

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