import 'package:flutter/material.dart';

class CompetitionList extends StatefulWidget {
  const CompetitionList({super.key});

  @override
  _CompetitionListState createState() => _CompetitionListState(); // Dodanie implementacji createState
}

class _CompetitionListState extends State<CompetitionList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competition List'),
      ),
      body: Center(
        child: Text('No competitions available.'),
      ),
    );
  }
}