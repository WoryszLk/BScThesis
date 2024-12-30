import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HorizontalButtonList extends StatelessWidget {
  const HorizontalButtonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildImageButton(
            context,
            'Mój klub',
            'lib/images/sts.jpg',
            () => _launchURL('https://sts.org.pl/'),
          ),
          _buildImageButton(
            context,
            'PZSS',
            'lib/images/pzss.jpg',
            () => _launchURL('https://www.pzss.org.pl/'),
          ),
          _buildImageButton(
            context,
            'System PZSS',
            'lib/images/PlayersList.jpg',
            () => _launchURL('https://portal.pzss.org.pl/'),
          ),
          _buildTextButton(context, 'Zbrojownia'),
          _buildTextButton(context, 'Raporty'),
          _buildTextButton(context, 'Wyniki'),
        ],
      ),
    );
  }

  Widget _buildImageButton(BuildContext context, String label, String imagePath, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
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

  Widget _buildTextButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
        },
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Theme.of(context).primaryColor,
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}
