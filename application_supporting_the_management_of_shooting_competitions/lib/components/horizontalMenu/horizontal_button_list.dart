import 'package:application_supporting_the_management_of_shooting_competitions/pages/home_page.dart';
import 'package:flutter/material.dart';

class HorizontalButtonList extends StatelessWidget {
  const HorizontalButtonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // testingna ten moment
          _buildCustomButton(context, 'Test 1', 'lib/images/PlayersList.jpg', HomePage()),
          _buildCustomButton(context, 'Test 1', 'lib/images/PlayersList.jpg', HomePage()),
          _buildCustomButton(context, 'Test 1', 'lib/images/PlayersList.jpg', HomePage()),
          _buildCustomButton(context, 'Test 1', 'lib/images/PlayersList.jpg', HomePage()),
          _buildCustomButton(context, 'Test 1', 'lib/images/PlayersList.jpg', HomePage()),
          _buildCustomButton(context, 'Test 1', 'lib/images/PlayersList.jpg', HomePage()),

        ],
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, String label, String imagePath, Widget routePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => routePath),
          );
        },
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3.0,
                    color: Colors.black54,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}