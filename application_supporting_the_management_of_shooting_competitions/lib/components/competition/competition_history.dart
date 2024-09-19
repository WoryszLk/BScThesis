import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_manager.dart';
import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_service.dart';

class CompetitionHistory extends StatelessWidget {
  final CompetitionManager _competitionManager = CompetitionManager(); // Inicjalizacja menedżera

  CompetitionHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildRecentCompetitions(context);
  }

  Widget _buildRecentCompetitions(BuildContext context) {
    return StreamBuilder<List<CompetitionWithId>>(
      stream: _competitionManager.getCompetitions(), // Pobieranie zawodów z CompetitionManager
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final competitions = snapshot.data!.take(5).toList();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: competitions.length,
            itemBuilder: (context, index) {
              final competition = competitions[index].competition;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text('Punktacja dla ${competition.competitionType}'),
                        ),
                        body: _competitionManager.loadCompetitionScorePage(competitions[index]),
                      ),
                    ),
                  );
                },
                child: _buildCompetitionHistoryCard(
                  competition.competitionType,
                  competition.startDate.toLocal().toString().split(' ')[0],
                  'Zakończone', // do dynamicznej zmiany
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