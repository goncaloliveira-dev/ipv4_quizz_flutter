import 'package:flutter/material.dart';
import '../../db/db_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _error = '';
  String _success = '';

  void _register() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Validações
    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _error = 'Preencha todos os campos.';
        _success = '';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _error = 'A palavra-passe deve ter pelo menos 6 caracteres.';
        _success = '';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _error = 'As palavras-passe não coincidem.';
        _success = '';
      });
      return;
    }

    try {
      int result = await DatabaseHelper.instance.registerUser(
        username,
        password,
      );
      if (result > 0) {
        setState(() {
          _success = 'Utilizador registado com sucesso!';
          _error = '';
        });
      } else {
        setState(() {
          _error = 'Nome de utilizador já existe.';
          _success = '';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao registar: $e';
        _success = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0D47A1);
    final accentColor = Colors.white;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_add, size: 100, color: accentColor),
                const SizedBox(height: 24),
                Text(
                  'Criar Conta',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 32),

                // Nome de utilizador
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Nome de utilizador',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.person, color: accentColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: primaryColor.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 16),

                // Palavra-passe
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Palavra-passe',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.lock, color: accentColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: primaryColor.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 16),

                // Confirmar palavra-passe
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Confirmar palavra-passe',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.lock_outline, color: accentColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: primaryColor.withOpacity(0.3),
                  ),
                ),

                const SizedBox(height: 20),

                if (_error.isNotEmpty)
                  Text(
                    _error,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                if (_success.isNotEmpty)
                  Text(
                    _success,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(height: 20),

                // Botão Registar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.blueAccent,
                    ),
                    label: const Text(
                      'Registar',
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: _register,
                  ),
                ),

                const SizedBox(height: 16),

                // Botão Voltar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text(
                      'Voltar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
