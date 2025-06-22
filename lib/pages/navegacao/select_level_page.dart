import 'package:flutter/material.dart';
import '../../db/db_helper.dart';

class SelectLevelPage extends StatefulWidget {
  final int userId;
  final String username;

  const SelectLevelPage({
    super.key,
    required this.userId,
    required this.username,
  });

  @override
  State<SelectLevelPage> createState() => _SelectLevelPageState();
}

class _SelectLevelPageState extends State<SelectLevelPage> {
  bool nivel2Desbloqueado = false;
  bool nivel3Desbloqueado = false;

  @override
  void initState() {
    super.initState();
    verificarDesbloqueios();
  }

  Future<void> verificarDesbloqueios() async {
    final db = DatabaseHelper.instance;
    final acertosNivel1 = await db.getCorrectAnswersByLevel(widget.userId, 1);
    final acertosNivel2 = await db.getCorrectAnswersByLevel(widget.userId, 2);

    //acima de 7 acertos no nível desbloqueia o próximo
    setState(() {
      nivel2Desbloqueado = acertosNivel1 >= 7;
      nivel3Desbloqueado = acertosNivel2 >= 7;
    });
  }

  void iniciarQuiz(int level) {
    Navigator.pushNamed(
      context,
      '/quiz',
      arguments: {'userId': widget.userId, 'difficulty': level},
    ).then((_) {
      verificarDesbloqueios(); // atualiza os níveis desbloqueados ao voltar
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0D47A1);
    final backgroundColor = const Color(0xFF0A3756);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 2,
        title: const Text(
          'Escolher Nível',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min, // reduz altura da column
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.quiz, size: 100, color: const Color.fromARGB(255, 255, 255, 255)),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => iniciarQuiz(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Nível 1 - IPv4 /8 /16 /24',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: nivel2Desbloqueado ? () => iniciarQuiz(2) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      nivel2Desbloqueado ? primaryColor : Colors.grey.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: nivel2Desbloqueado ? 4 : 0,
                ),
                child: const Text(
                  'Nível 2 - Sub-redes',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: nivel3Desbloqueado ? () => iniciarQuiz(3) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      nivel3Desbloqueado ? primaryColor : Colors.grey.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: nivel3Desbloqueado ? 4 : 0,
                ),
                child: const Text(
                  'Nível 3 - Super-redes',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                nivel3Desbloqueado
                    ? 'Parabéns! Você desbloqueou todos os níveis!'
                    : 'Acerta pelo menos 7 perguntas por nível para desbloquear o seguinte.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                      nivel3Desbloqueado ? Colors.green[400] : Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
