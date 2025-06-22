import 'dart:math';

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class QuestionGenerator {
  static List<Question> generate(int difficulty) {
    switch (difficulty) {
      case 1:
        return _generateLevel1();
      case 2:
        return _generateLevel2();
      case 3:
        return _generateLevel3();
      default:
        return [];
    }
  }

  static List<Question> _generateLevel1() {
    List<Question> questions = [];
    final List<String> exemplos = [
      '10.0.0.0',
      '10.1.0.0',
      '172.16.0.0',
      '172.17.0.0',
      '192.168.0.0',
      '192.168.1.0',
      '192.168.2.0',
      '192.168.3.0',
      '172.18.0.0',
      '10.2.0.0',
    ];

    final List<String> cidrs = [
      '/8',
      '/8',
      '/16',
      '/16',
      '/24',
      '/24',
      '/24',
      '/24',
      '/16',
      '/8',
    ];

    Set<String> usadas = {};

    final random = Random();

    while (questions.length < 10) {
      int index = random.nextInt(exemplos.length);
      String ip = exemplos[index];
      String cidr = cidrs[index];

      String pergunta = 'Qual a máscara do endereço $ip?';

      if (usadas.contains(pergunta)) continue;

      usadas.add(pergunta);

      // opções: embaralha as máscaras para opções
      List<String> options = ['/8', '/16', '/24']..shuffle();

      questions.add(
        Question(question: pergunta, options: options, correctAnswer: cidr),
      );
    }

    return questions;
  }

  static List<Question> _generateLevel2() {
    List<Question> questions = [];
    Set<String> usadas = {};

    while (questions.length < 10) {
      String ip = _randomPrivateIp();
      int cidr = 24;
      bool askNet = Random().nextBool();

      String pergunta =
          askNet
              ? 'Qual é o Network ID de $ip/$cidr?'
              : 'Qual é o Broadcast de $ip/$cidr?';

      if (usadas.contains(pergunta)) continue;
      usadas.add(pergunta);

      String correta =
          askNet
              ? _calculateNetworkID(ip, cidr)
              : _calculateBroadcast(ip, cidr);

      questions.add(
        Question(
          question: pergunta,
          options: _generateIpOptions(correct: correta),
          correctAnswer: correta,
        ),
      );
    }

    return questions;
  }

  static List<Question> _generateLevel3() {
    List<Question> questions = [];
    Set<String> usadas = {};

    while (questions.length < 10) {
      String ip1 = _randomPrivateIp();
      String ip2 = _randomPrivateIp();

      String pergunta =
          'Os endereços $ip1/16 e $ip2/16 pertencem à mesma sub-rede?';
      if (usadas.contains(pergunta)) continue;
      usadas.add(pergunta);

      bool sameNetwork =
          _calculateNetworkID(ip1, 16) == _calculateNetworkID(ip2, 16);

      questions.add(
        Question(
          question: pergunta,
          options: ['Sim', 'Não'],
          correctAnswer: sameNetwork ? 'Sim' : 'Não',
        ),
      );
    }

    return questions;
  }

  // Auxilio:

  // Gera um IP privado aleatório no formato 192.168.X.X
  static String _randomPrivateIp() {
    final r = Random();
    int terceiroX = r.nextInt(256);
    int quartoX = r.nextInt(256);
    return '192.168.$terceiroX.$quartoX';
  }

  // Calcula o Network ID de um IP com base na máscara (CIDR)
  static String _calculateNetworkID(String ip, int cidr) {
    List<String> partes = ip.split('.');
    int ip1 = int.parse(partes[0]);
    int ip2 = int.parse(partes[1]);
    int ip3 = int.parse(partes[2]);
    int ip4 = int.parse(partes[3]);

    int bloco = pow(2, 32 - cidr).toInt();
    int rede = (ip4 ~/ bloco) * bloco;

    return '$ip1.$ip2.$ip3.$rede';
  }

  // Calcula o Broadcast de um IP com base na máscara (CIDR)
  static String _calculateBroadcast(String ip, int cidr) {
    List<String> partes = ip.split('.');
    int ip1 = int.parse(partes[0]);
    int ip2 = int.parse(partes[1]);
    int ip3 = int.parse(partes[2]);
    int ip4 = int.parse(partes[3]);

    int bloco = pow(2, 32 - cidr).toInt();
    int rede = (ip4 ~/ bloco) * bloco;
    int broadcast = rede + bloco - 1;

    return '$ip1.$ip2.$ip3.$broadcast';
  }

  // Gera 4 opções (uma correta + 3 erradas)
  static List<String> _generateIpOptions({required String correct}) {
    Set<String> opcoes = {correct};
    while (opcoes.length < 4) {
      opcoes.add(_randomPrivateIp());
    }
    return opcoes.toList()..shuffle();
  }
}
