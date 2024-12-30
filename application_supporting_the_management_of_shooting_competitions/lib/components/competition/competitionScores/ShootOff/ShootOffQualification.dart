import 'package:flutter/material.dart';

class ShootOffQualificationPhase extends StatefulWidget {
  final List<Map<String, dynamic>> playerResults;
  final Future<void> Function(List<Map<String, dynamic>> updatedResults) onSaveResults;
  final VoidCallback onGenerateBracket;

  const ShootOffQualificationPhase({
    Key? key,
    required this.playerResults,
    required this.onSaveResults,
    required this.onGenerateBracket,
  }) : super(key: key);

  @override
  _ShootOffQualificationPhaseState createState() => _ShootOffQualificationPhaseState();
}

class _ShootOffQualificationPhaseState extends State<ShootOffQualificationPhase> {
  late List<Map<String, dynamic>> playerResults;
  late List<TextEditingController> time1Controllers;
  late List<TextEditingController> time2Controllers;

  @override
  void initState() {
    super.initState();
    playerResults = widget.playerResults;

    time1Controllers = playerResults.map((result) {
      return TextEditingController(text: result['time1'].toString());
    }).toList();

    time2Controllers = playerResults.map((result) {
      return TextEditingController(text: result['time2'].toString());
    }).toList();
  }

  void _updateTime(int index, String timeField, String value) {
    setState(() {
      playerResults[index][timeField] = double.tryParse(value) ?? 0.0;
    });
    _saveResultsToFirestore();
  }

  Future<void> _saveResultsToFirestore() async {
    await widget.onSaveResults(playerResults);
  }

  void _sortPlayersByBestTime() {
    setState(() {
      playerResults.sort((a, b) {
        double minTimeA = a['time1'] < a['time2'] ? a['time1'] : a['time2'];
        double minTimeB = b['time1'] < b['time2'] ? b['time1'] : b['time2'];
        return minTimeA.compareTo(minTimeB);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: playerResults.length,
            itemBuilder: (context, index) {
              final result = playerResults[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${result['player'].player.firstName} ${result['player'].player.lastName}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Czas 1',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => _updateTime(index, 'time1', value),
                                controller: time1Controllers[index],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Czas 2',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => _updateTime(index, 'time2', value),
                                controller: time2Controllers[index],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _sortPlayersByBestTime,
              child: const Text('Sortuj wyniki'),
            ),
            ElevatedButton(
              onPressed: widget.onGenerateBracket,
              child: const Text('Przejdź do turnieju'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in time1Controllers) {
      controller.dispose();
    }
    for (var controller in time2Controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
