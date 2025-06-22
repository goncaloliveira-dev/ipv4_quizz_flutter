import 'package:flutter/material.dart';
import '../../db/db_helper.dart';
import '../../utils/question_generator.dart';

class QuizPage extends StatefulWidget {
  final int userId;
  final int difficulty;

  const QuizPage({super.key, required this.userId, required this.difficulty});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> _questions;
  int _iCurrentQuestion = 0;
  int _score = 0;
  int _correctAnswers = 0;
  bool _answered = false;
  String _feedback = '';
  String? _selectedOption;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _questions = QuestionGenerator.generate(widget.difficulty);
  }

  void _answerQuestion(String selectedAnswer) {
    if (_answered) return;

    final current = _questions[_iCurrentQuestion];
    final isCorrect = selectedAnswer == current.correctAnswer;

    int scoreDelta = 0;
    if (widget.difficulty == 1) {
      scoreDelta = isCorrect ? 10 : -5;
    } else if (widget.difficulty == 2) {
      scoreDelta = isCorrect ? 20 : -10;
    } else {
      scoreDelta = isCorrect ? 30 : -15;
    }

    setState(() {
      _answered = true;
      _selectedOption = selectedAnswer;
      _isCorrect = isCorrect;
      _feedback =
          isCorrect
              ? 'Correto!'
              : 'Errado. Resposta correta: ${current.correctAnswer}';
      _score += scoreDelta;
      if (isCorrect) _correctAnswers++;
    });

    DatabaseHelper.instance.insertScore(
      widget.userId,
      scoreDelta,
      widget.difficulty,
    );
  }

  void _nextQuestion() {
    if (_iCurrentQuestion < _questions.length - 1) {
      setState(() {
        _iCurrentQuestion++;
        _answered = false;
        _feedback = '';
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final passed = _correctAnswers >= 7;
    String message =
        passed
            ? 'Parabéns! Você desbloqueou o próximo nível!'
            : 'Quase! Tente novamente para desbloquear o próximo nível.';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('Fim do Quiz'),
            content: Text('$message\nPontuação final: $_score'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pop(context, true); // volta para level page
                },
                child: const Text('Voltar ao Menu'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_iCurrentQuestion];
    final primaryColor = Color(0xFF0D47A1);
    final backgroundColor = Color(0xFF0A3756);

    // criar botões das opções
    List<Widget> optionButtons = [];

    for (var option in question.options) {
      Color buttonColor = primaryColor;

      if (_answered) {
        if (option == question.correctAnswer) {
          buttonColor = Colors.green; // correto fica verde
        } else if (option != question.correctAnswer &&
            option == _selectedOption) {
          buttonColor = Colors.red; // errado fica vermelho
        } else {
          buttonColor = primaryColor; // outros ficam azuis normais
        }
      }

      optionButtons.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: ElevatedButton(
            onPressed: _answered ? null : () => _answerQuestion(option),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: Text(
              option,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nível ${widget.difficulty}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pergunta ${_iCurrentQuestion + 1} de ${_questions.length}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            // botões das opções
            ...optionButtons,

            const SizedBox(height: 16),
            Text(
              _feedback,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: _isCorrect ? Colors.green : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _answered ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _answered ? primaryColor : Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 6,
              ),
              child: Text(
                _iCurrentQuestion < _questions.length - 1
                    ? 'Próxima'
                    : 'Finalizar',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
