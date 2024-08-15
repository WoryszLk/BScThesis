import 'package:flutter/material.dart';
import '';
class CompetitionSelector extends StatelessWidget {
  const CompetitionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competition Selector'),
      ),
      backgroundColor: Colors.grey[300],
      body: ListWheelScrollView(
        itemExtent: 250,
        physics: FixedExtentScrollPhysics(),
        children: [
          Text("1 Tryb zawodów"),
          Text("2 tryb zawodów"),
          Text("3 tryb zawodów"),
          Text("4 tryb zawodów"),
          Text("5 tryb zawodów")
        ],
      ),
    );
  }
}
