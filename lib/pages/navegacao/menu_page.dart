import 'package:flutter/material.dart';
import '../../db/db_helper.dart';
import '../cadastro/login_page.dart';
import '/widgets/pulsating_medal_icon.dart';

class MenuPage extends StatefulWidget {
  final int userId;
  final String username;

  const MenuPage({required this.userId, required this.username, super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int totalScore = 0;
  String currentMedal = 'sem';

  @override
  void initState() {
    super.initState();
    _fetchUserScore();
  }

  Future<void> _fetchUserScore() async {
    int score = await DatabaseHelper.instance.getTotalScore(widget.userId);
    setState(() {
      totalScore = score;
      currentMedal = _calculateMedal(score);
    });
  }

  String _calculateMedal(int score) {
    if (score >= 300) {
      return 'ouro';
    } else if (score >= 200) {
      return 'prata';
    } else if (score > 0) {
      return 'bronze';
    } else {
      return 'sem';
    }
  }

  Widget _medalWidget(String medal) {
    Color color;
    String label;

    switch (medal.toLowerCase()) {
      case 'ouro':
        color = Colors.amber.shade700;
        label = 'Ouro';
        break;
      case 'prata':
        color = Colors.grey.shade400;
        label = 'Prata';
        break;
      case 'bronze':
        color = const Color.fromARGB(255, 158, 125, 40);
        label = 'Bronze';
        break;
      default:
        color = Colors.white70;
        label = 'Sem medalha\nJogue para conquistar!';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PulsatingMedalIcon(
          color: color,
          size: 100,
        ), // usa o widget com a cor do switch
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            shadows: [
              Shadow(
                blurRadius: 7,
                color: color.withOpacity(0.8),
                offset: const Offset(0, 0),
              ),
              Shadow(
                blurRadius: 0,
                color: color.withOpacity(0.6),
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmação'),
            content: const Text('Tem certeza que deseja sair da sua conta?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sair'),
              ),
            ],
          ),
    );

    if (shouldLogout == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  String _getMotivationalMessage() {
    if (totalScore == 0) {
      return "Pronto para aprender mais sobre IPv4? Comece o quiz!";
    } else if (totalScore < 150) {
      return "Bom progresso! Continue respondendo para melhorar seu score!";
    } else {
      return "Parabéns! Você é muito bom em IPv4!";
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0D47A1);
    final accentColor = Colors.white;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Bem-vindo, ${widget.username}',
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: accentColor),
            tooltip: 'Logout',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _medalWidget(currentMedal), // mantém seu widget atualizado
                const SizedBox(height: 24),
                Text(
                  'Pontuação atual: $totalScore',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: accentColor.withOpacity(0.6),
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _getMotivationalMessage(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: accentColor.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 40),
                _buildMenuButton(
                  icon: Icons.quiz,
                  label: 'Jogar Quiz',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/select_level',
                      arguments: {
                        'userId': widget.userId,
                        'username': widget.username,
                      },
                    ).then((_) {
                      _fetchUserScore();
                    });
                  },
                  accentColor: accentColor,
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  icon: Icons.leaderboard,
                  label: 'Ver Ranking',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/medal_selection',
                      arguments: {
                        'username': widget.username,
                        'score': totalScore,
                      },
                    );
                  },
                  accentColor: accentColor,
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  icon: Icons.score,
                  label: 'Ver Meus Scores',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/score',
                      arguments: {
                        'userId': widget.userId,
                        'username': widget.username,
                      },
                    );
                  },
                  accentColor: accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? accentColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28, color: accentColor ?? Colors.white),
        label: Text(
          label,
          style: TextStyle(fontSize: 18, color: accentColor ?? Colors.white),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              accentColor?.withOpacity(0.15) ?? Colors.blue.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          elevation: 5,
        ),
      ),
    );
  }
}
