import 'package:flutter/material.dart';
import '../../db/db_helper.dart';

class RankingPage extends StatefulWidget {
  final String username;
  final int score;
  final String medal;

  const RankingPage({
    super.key,
    required this.username,
    required this.score,
    required this.medal,
  });

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Map<String, dynamic>> _topScores = [];

  @override
  void initState() {
    super.initState();
    _loadTopScores();
  }

  Future<void> _loadTopScores() async {
    final scores = await DatabaseHelper.instance.getTopScoresByMedal(
      widget.medal,
      5,
    );
    setState(() {
      _topScores = scores;
    });
  }

  Color _getMedalColor(String medal) {
    switch (medal) {
      case 'ouro':
        return Colors.amber;
      case 'prata':
        return Colors.grey;
      case 'bronze':
      default:
        return const Color(0xFFCD7F32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0D47A1);
    final backgroundColor = const Color(0xFF0A3756);
    final medalColor = _getMedalColor(widget.medal);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          'Ranking - Liga ${widget.medal.toUpperCase()}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: medalColor, size: 80),
              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.score} pts',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 300,
                width: 350,
                child:
                    _topScores.isEmpty
                        ? const Center(
                          child: Text(
                            'Ainda não há ranking nesta liga.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _topScores.length,
                          itemBuilder: (context, index) {
                            final score = _topScores[index];
                            final isCurrentUser =
                                score['username'] == widget.username;

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == _topScores.length - 1 ? 0 : 10,
                              ),
                              child: Card(
                                color:
                                    isCurrentUser
                                        ? Colors.blue.shade100
                                        : Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: medalColor,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    score['username'],
                                    style: TextStyle(
                                      fontWeight:
                                          isCurrentUser
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          isCurrentUser
                                              ? Colors.blue
                                              : Colors.black,
                                    ),
                                  ),
                                  trailing: Text(
                                    '${score['total']} pts',
                                    style: TextStyle(
                                      fontWeight:
                                          isCurrentUser
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          isCurrentUser
                                              ? Colors.blue
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
