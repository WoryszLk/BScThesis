import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_details.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';

class CompetitionHistory extends StatelessWidget {
  const CompetitionHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildRecentCompetitions(context);
  }

  // Funkcja budująca widok ostatnich zawodów
  Widget _buildRecentCompetitions(BuildContext context) {
    final CompetitionService competitionService = CompetitionService();

    return StreamBuilder<List<CompetitionWithId>>(
      stream: competitionService.getCompetitions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final competitions = snapshot.data!.take(5).toList();  // Wyświetlamy ostatnie 5 zawodów
          return ListView.builder(
            shrinkWrap: true,  // Dostosowanie do przestrzeni
            physics: const NeverScrollableScrollPhysics(),  // Wyłączenie przewijania (zarządzanie przewijaniem jest w głównym widoku)
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
                  'Zakończone',  // Może być dynamicznie zmieniane
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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