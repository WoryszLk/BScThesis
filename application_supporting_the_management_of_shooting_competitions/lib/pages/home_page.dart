import 'package:flutter/material.dart';
import 'competition_selector_page.dart';  // Dodaj import nowego widoku

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Przejście do widoku CompetitionSelector
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CompetitionSelector()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Image.asset(
            'lib/images/buttonShooters.jpg', // Poprawiona ścieżka
            width: 400,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
