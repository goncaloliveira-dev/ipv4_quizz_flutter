import 'package:flutter/material.dart';
import '../../db/db_helper.dart';

class ScorePage extends StatefulWidget {
  final int userId;
  final String username;

  const ScorePage({super.key, required this.userId, required this.username});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  List<Map<String, dynamic>> _userScores = [];

  @override
  void initState() {
    super.initState();
    _loadUserScores();
  }

  Future<void> _loadUserScores() async {
    final scores = await DatabaseHelper.instance.getUserScores(widget.userId);
    setState(() {
      _userScores = scores;
    });
  }

  String timeAgo(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) return iso;

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'há ${difference.inSeconds} segundos';
    } else if (difference.inMinutes < 60) {
      final m = difference.inMinutes;
      return m == 1 ? 'há 1 minuto' : 'há $m minutos';
    } else if (difference.inHours < 24) {
      final h = difference.inHours;
      return h == 1 ? 'há 1 hora' : 'há $h horas';
    } else if (difference.inDays < 30) {
      final d = difference.inDays;
      return d == 1 ? 'há 1 dia' : 'há $d dias';
    } else if (difference.inDays < 365) {
      final m = (difference.inDays / 30).floor();
      return m == 1 ? 'há 1 mês' : 'há $m meses';
    } else {
      final y = (difference.inDays / 365).floor();
      return y == 1 ? 'há 1 ano' : 'há $y anos';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Os Meus Scores'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child:
            _userScores.isEmpty
                ? const Center(
                  child: Text(
                    'Ainda não tens pontuações.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                )
                : ListView.builder(
                  itemCount: _userScores.length,
                  itemBuilder: (context, index) {
                    final score = _userScores[index];
                    final isPositive = (score['score'] ?? 0) >= 0;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == _userScores.length - 1 ? 0 : 14,
                      ),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          leading: Icon(
                            Icons.bar_chart,
                            size: 36,
                            color: isPositive ? Colors.green : Colors.red,
                          ),
                          title: Text(
                            'Pontuação: ${score['score']} pts',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color:
                                  isPositive
                                      ? Colors.green[700]
                                      : Colors.red[700],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Nível: ${score['difficulty']}   •   ${timeAgo(score['created_at'])}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
