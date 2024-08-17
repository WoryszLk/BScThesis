import 'package:flutter/material.dart';
import 'competition_selector_page.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Lewa kolumna (duży kafelek)
            Expanded(
              flex: 2,
              child: CustomButton(
                width: double.infinity,
                height: double.infinity,
                imagePath: 'lib/images/buttonShooters.jpg',
                text: 'Wybierz typ zawodów',
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => const CompetitionSelector()));
                },
              ),
            ),
            const SizedBox(width: 8), // Przerwa między kolumnami
            // Prawa kolumna (trzy mniejsze kafelki)
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  // Górny kafelek
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      imagePath: 'lib/images/buttonShooters.jpg',
                      text: 'Tile 1',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 8), // Przerwa między kafelkami
                  // Środkowy kafelek
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      imagePath: 'lib/images/buttonShooters.jpg',
                      text: 'Tile 2',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 8), // Przerwa między kafelkami
                  // Dolny kafelek
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      imagePath: 'lib/images/buttonShooters.jpg',
                      text: 'Tile 3',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}