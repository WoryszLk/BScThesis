import 'package:application_supporting_the_management_of_shooting_competitions/pages/player_list_selector_page.dart';
import 'package:flutter/material.dart';
import 'competition_start_page.dart';
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
        child: Column(
          children: [
            // Górny button (Wybierz typ zawodów)
            CustomButton(
              width: double.infinity,
              height: 450, // Możesz dostosować wysokość według potrzeb
              imagePath: 'lib/images/ZacznijZawody.jpg',
              text: 'Rozpocznij zawody',
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StarterCompetition()));
              },
            ),
            const SizedBox(height: 8), // Przerwa między rzędem górnym a dolnym
            // Dolny rząd z dwoma kolumnami
            Expanded(
              child: Row(
                children: [
                  // Lewa kolumna (Lista zawodników)
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      width: double.infinity,
                      height: double.infinity,
                      imagePath: 'lib/images/PlayersList.jpg',
                      text: 'Zawody które trwają',
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const PlayerList()));
                      },
                    ),
                  ),
                  const SizedBox(width: 8), // Przerwa między kolumnami
                  // Prawa kolumna z dwoma kafelkami (Tile 3 i Tile 4)
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // Tile 3 (górny kafelek)
                        Expanded(
                          child: CustomButton(
                            width: double.infinity,
                            height: double.infinity,
                            imagePath: 'lib/images/buttonShooters.jpg',
                            text: 'historia 3',
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 8), // Przerwa między kafelkami
                        // Tile 4 (dolny kafelek)
                        Expanded(
                          child: CustomButton(
                            width: double.infinity,
                            height: double.infinity,
                            imagePath: 'lib/images/buttonShooters.jpg',
                            text: 'Tile 4',
                            onPressed: () {},
                          ),
                        ),
                      ],
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
