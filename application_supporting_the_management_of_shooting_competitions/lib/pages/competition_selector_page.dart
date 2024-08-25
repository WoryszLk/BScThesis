import 'package:flutter/material.dart';

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
          return GestureDetector(
            onTap: () => _onItemSelected(index),
            child: Container(
              alignment: Alignment.center,
              color: _selectedIndex == index ? Colors.blue : Colors.white,
              child: Text(
                '${index + 1} Tryb zawodów',
                style: TextStyle(
                  fontSize: 24,
                  color: _selectedIndex == index ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
