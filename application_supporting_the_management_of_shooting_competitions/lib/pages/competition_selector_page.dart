import 'package:flutter/material.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/custom_competition_button.dart';

class CompetitionSelector extends StatefulWidget {
  const CompetitionSelector({super.key});

  @override
  _CompetitionSelectorState createState() => _CompetitionSelectorState();
}

class _CompetitionSelectorState extends State<CompetitionSelector> {
  int _selectedIndex = -1;

  final List<Map<String, String>> _competitions = [
    {'text': 'FBI', 'imagePath': 'lib/images/fbi.jpg'},
    {'text': 'PIRO', 'imagePath': 'lib/images/piro.jpg'},
    {'text': 'Shoot off', 'imagePath': 'lib/images/shootOff.jpg'},
    {'text': 'BTG', 'imagePath': 'lib/images/btg.jpg'},
    {'text': 'NRA', 'imagePath': 'lib/images/nra.jpg'},
    {'text': 'Top Gun', 'imagePath': 'lib/images/top_gun.jpg'},
    
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context, _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz dyscyplinę'),
      ),
      backgroundColor: Colors.grey[300],
      body: ListWheelScrollView(
        itemExtent: 250,
        physics: const FixedExtentScrollPhysics(),
        children: List.generate(_competitions.length, (index) {
          return CustomCompetitionButton(
            text: _competitions[index]['text']!,
            imagePath: _competitions[index]['imagePath']!,
            isSelected: _selectedIndex == index,
            onTap: () => _onItemSelected(index),
          );
        }),
      ),
    );
  }
}