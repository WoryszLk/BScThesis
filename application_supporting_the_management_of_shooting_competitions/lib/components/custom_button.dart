import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final String? imagePath;  // Używamy nullable String dla obrazu
  final Color? backgroundColor;  // Nowy parametr dla koloru tła
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    required this.width,
    required this.height,
    this.imagePath,  // Obraz jest teraz opcjonalny
    this.backgroundColor,  // Kolor tła jest teraz opcjonalny
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
          borderRadius: BorderRadius.circular(16),
        ),
        animationDuration: const Duration(milliseconds: 200),
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor,  // Ustawiamy kolor tła
          image: imagePath != null  // Ustawiamy obraz tylko, jeśli został podany
              ? DecorationImage(
                  image: AssetImage(imagePath!),
                  fit: BoxFit.cover,
                )
              : null,
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
