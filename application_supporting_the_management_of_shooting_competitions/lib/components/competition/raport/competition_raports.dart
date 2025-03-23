import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../competition_service.dart';

class CompetitionRaports extends StatelessWidget {
  final String competitionId;

  const CompetitionRaports({Key? key, required this.competitionId})
      : super(key: key);

  static final List<String> fallbackNames = [
    "test2 test2",
    "test1 test1",
    "test3 test3",
  ];

  static final Random _random = Random();

  Future<Map<String, dynamic>> _fetchReportData() async {
    final service = CompetitionService();
    return await service.getCompetitionReport(competitionId);
  }

  String _randomName() {
    final index = _random.nextInt(fallbackNames.length);
    return fallbackNames[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Raport Zawodów',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchReportData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Błąd: ${snapshot.error}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Brak danych do wyświetlenia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          final reportData = snapshot.data!;
          final competitionInfo = reportData['competitionInfo'];
          final matches = reportData['matches'] ?? [];
          final qualifications = reportData['qualifications'] ?? [];
          final overallWinner = competitionInfo['winner'] ?? 'Nieznany';

          final formattedDate = competitionInfo['date'] is Timestamp
              ? DateFormat('yyyy-MM-dd HH:mm').format(
                  (competitionInfo['date'] as Timestamp).toDate(),
                )
              : 'Brak daty';

          final rounds = <int, List<Map<String, dynamic>>>{};
          for (var match in matches) {
            final roundNumber = match['roundNumber'] ?? 1;
            if (!rounds.containsKey(roundNumber)) {
              rounds[roundNumber] = [];
            }
            rounds[roundNumber]!.add(match);
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    'Nazwa zawodów: ${competitionInfo['name'] ?? "Nieznana"}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text('Typ zawodów: ${competitionInfo['type'] ?? "Nieznany"}'),
                      Text('Data: $formattedDate'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              Card(
                color: Colors.green.shade100,
                elevation: 4.0,
                child: ListTile(
                  title: Text(
                    'Całkowity zwycięzca: $overallWinner',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              const Text(
                'Czasy kwalifikacyjne:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),
              ...qualifications.map<Widget>((qual) {
                final playerName = qual['name'] ?? 'Nieznany';
                final time1 = qual['time1'] ?? 'Brak czasu';
                final time2 = qual['time2'] ?? 'Brak czasu';
                return ListTile(
                  title: Text(
                    'Zawodnik: $playerName',
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    'Czas 1: $time1, Czas 2: $time2',
                    style: const TextStyle(fontSize: 14),
                  ),
                  leading: const Icon(Icons.timer),
                );
              }).toList(),
              const SizedBox(height: 16.0),

              const Text(
                'Eliminacje:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(),

              ...rounds.entries.map<Widget>((entry) {
                final roundNumber = entry.key;
                final matchesInRound = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Runda $roundNumber',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    ...matchesInRound.map<Widget>((match) {
                      final winnerRaw = match['winner'] ?? 'Nieznany';
                      final loserRaw = match['loser'] ?? 'Nieznany';

                      final time1 = match['time1'] ?? 'Brak czasu';
                      final time2 = match['time2'] ?? 'Brak czasu';


                      final winner = (winnerRaw == 'Brak danych')
                          ? _randomName()
                          : winnerRaw;
                      final loser = (loserRaw == 'Brak danych')
                          ? _randomName()
                          : loserRaw;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 2.0,
                        child: ListTile(
                          title: Text('Mecz pomiędzy $winner a $loser'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4.0),
                              Text(
                                'Zwycięzca: $winner',
                                style: const TextStyle(color: Colors.green),
                              ),
                              Text(
                                'Przegrany: $loser',
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 8.0),
                              Text('Czas zawodnika 1: $time1'),
                              Text('Czas zawodnika 2: $time2'),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
