import 'package:flutter/material.dart';

class MedalSelectionPage extends StatelessWidget {
  final String username;
  final int score;

  const MedalSelectionPage({
    super.key,
    required this.username,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> medalColors = {
      'bronze': const Color(0xFFCD7F32),
      'prata': Colors.grey,
      'ouro': Colors.amber,
    };

    final primaryColor = const Color(0xFF0D47A1);
    final backgroundColor = const Color(0xFF0A3756);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Escolha a Liga'),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Veja os 5 melhores de cada liga:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ...medalColors.entries.map((entry) {
                final medal = entry.key;
                final color = entry.value;

                return Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    leading: Icon(Icons.emoji_events, color: color, size: 40),
                    title: Text(
                      medal[0].toUpperCase() + medal.substring(1),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor:
                            medal == 'prata' ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/ranking',
                          arguments: {
                            'username': username,
                            'score': score,
                            'medal': medal,
                          },
                        );
                      },
                      child: const Text('Ver Ranking'),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
