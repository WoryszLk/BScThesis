import 'package:application_supporting_the_management_of_shooting_competitions/components/burgerMenu/burger_menu.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/competition/competition_history.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/components/horizontalMenu/horizontal_button_list.dart';
import 'package:application_supporting_the_management_of_shooting_competitions/pages/competition_start_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final burgerMenu = BurgerMenu();

    return Scaffold(
      appBar: burgerMenu.buildAppBar(context),
      drawer: burgerMenu, 
      body: SingleChildScrollView(  // Dodanie przewijania na całe body
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Karta do rozpoczęcia zawodów
            _buildMainOptionCard(
              context,
              'Rozpocznij zawody',
              'lib/images/ZacznijZawody.jpg',
              Icons.flag,
              const StarterCompetition(),
            ),
            const SizedBox(height: 16),

            const Text(
              'Wybierz opcję',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Lista przycisków przewijanych poziomo
            const HorizontalButtonList(),
            const SizedBox(height: 16), // Dodaj trochę miejsca

            const Text(
              'Historia',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Wyświetlanie historii zawodów
            const CompetitionHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainOptionCard(BuildContext context, String title, String? imagePath, IconData icon, Widget? route) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => route));
        }
      },
      child: Container(
        width: double.infinity,
        height: 200,  // Wysokość większa niż zwykłe karty
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          image: imagePath != null
              ? DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                )
              : null, 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}