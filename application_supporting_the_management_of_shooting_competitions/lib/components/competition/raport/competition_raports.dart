import 'package:flutter/material.dart';

class CompetitionRaports extends StatelessWidget {
  final String competitionId;

  const CompetitionRaports({Key? key, required this.competitionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raport Zawodów'),
      ),
      body: Center(
        child: Text('Rapord o ID - : $competitionId'),
      ),
    );
  }
}
