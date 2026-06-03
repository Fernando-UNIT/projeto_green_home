import 'package:flutter/material.dart';
import 'login_page.dart'; // ajuste o caminho conforme sua estrutura

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _repetirSenhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _repetirSenhaVisivel = false;
  bool _carregando = false;

  static const _gradienteVerde = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.27, 1.0],
    colors: [Color(0xFF46C971), Color(0xFF2A914D)],
  );

  static const _corLink = Color(0xFF42A80B);

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _repetirSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    // Simula cadastro — substitua pela sua lógica real
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _carregando = false);

    if (!mounted) return;

    // Após cadastro, volta para o login
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _fazerLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F3),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Logo ─────────────────────────────────────────────
                  Image.asset(
                    'assets/images/greenhome_logo.png',
                    height: 200,
                  ),
                  const SizedBox(height: 36),

                  // ── Campo Nome ────────────────────────────────────────
                  TextFormField(
                    controller: _nomeController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDecoration('Nome', Icons.person_outline),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Informe seu nome';
                      }
                      if (v.trim().length < 2) {
                        return 'Nome muito curto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Campo E-mail ──────────────────────────────────────
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration('E-mail', Icons.email_outlined),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Informe seu e-mail';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Campo Senha ───────────────────────────────────────
                  TextFormField(
                    controller: _senhaController,
                    obscureText: !_senhaVisivel,
                    textInputAction: TextInputAction.next,
                    decoration: _inputDecoration(
                      'Senha',
                      Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _senhaVisivel
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () =>
                            setState(() => _senhaVisivel = !_senhaVisivel),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe sua senha';
                      if (v.length < 6) return 'Mínimo de 6 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Campo Repetir Senha ───────────────────────────────
                  TextFormField(
                    controller: _repetirSenhaController,
                    obscureText: !_repetirSenhaVisivel,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _cadastrar(),
                    decoration: _inputDecoration(
                      'Repetir Senha',
                      Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _repetirSenhaVisivel
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                            () => _repetirSenhaVisivel = !_repetirSenhaVisivel),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Repita sua senha';
                      if (v != _senhaController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // ── Botão Cadastrar ───────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: _gradienteVerde,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF46C971).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _cadastrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _carregando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Cadastrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Já tem conta? ─────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Já tem conta? ',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: _fazerLogin,
                        child: const Text(
                          'Faça login',
                          style: TextStyle(
                            color: _corLink,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: _corLink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData prefixIconData, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      prefixIcon: Icon(prefixIconData, color: Colors.black38, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDE0DE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDE0DE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF46C971), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
      ),
    );
  }
}