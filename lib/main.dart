import 'package:flutter/material.dart';
import 'package:tp02_ipv4/pages/ranking/medal_selection_page.dart';
import 'package:tp02_ipv4/pages/navegacao/menu_page.dart';
import 'package:tp02_ipv4/pages/score/score_page.dart';
import 'pages/cadastro/login_page.dart';
import 'pages/cadastro/register_page.dart';
import 'pages/quiz/quiz_page.dart';
import 'pages/ranking/ranking_page.dart';
import 'pages/navegacao/select_level_page.dart';
import 'anim/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPv4 Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),

      // começa pelo loading em anim
      home: const LoadingPage(),

      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/score': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return ScorePage(userId: args['userId'], username: args['username']);
        },

        '/ranking': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return RankingPage(
            username: args['username'],
            score: args['score'],
            medal: args['medal'],
          );
        },

        '/select_level': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return SelectLevelPage(
            userId: args['userId'],
            username: args['username'],
          );
        },
        '/quiz': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return QuizPage(
            userId: args['userId'],
            difficulty: args['difficulty'],
          );
        },
        '/menu': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return MenuPage(userId: args['userId'], username: args['username']);
        },

        '/medal_selection': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return MedalSelectionPage(
            username: args['username'],
            score: args['score'],
          );
        },
      },
    );
  }
}
