import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/custom_competition_button.dart';

class CompetitionSelector extends StatefulWidget {
  const CompetitionSelector({super.key});

  @override
  _CompetitionSelectorState createState() => _CompetitionSelectorState();
}

class _CompetitionSelectorState extends State<CompetitionSelector> {
  int _selectedIndex = -1;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context, _selectedIndex); // Zwraca wybrany indeks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competition Selector'),
      ),
      backgroundColor: Colors.grey[300],
      body: ListWheelScrollView(
        itemExtent: 250,
        physics: const FixedExtentScrollPhysics(),
        children: List.generate(5, (index) {
          return CustomCompetitionButton(
            text: '${index + 1} Tryb zawodów',
            imagePath: 'lib/images/competition_image_$index.jpg', // Zakładając, że masz różne obrazy
            isSelected: _selectedIndex == index,
            onTap: () => _onItemSelected(index),
          );
        }),
      ),
    );
  }
}
