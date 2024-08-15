import 'package:flutter/material.dart';

class CompetitionSelector extends StatelessWidget {
  const CompetitionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competition Selector'),
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Text(
          'Select a competition',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
