import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final String imagePath;
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    required this.width,
    required this.height,
    required this.imagePath,
    required this.onPressed,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Zaokrąglenie rogów
        ),
        animationDuration: const Duration(milliseconds: 200), // Czas trwania animacji
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), // Zaokrąglenie rogów
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
