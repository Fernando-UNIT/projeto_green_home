import 'package:flutter/material.dart';
import '../auth/login_page.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({super.key});

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _carregando = false;
  bool _sucesso = false;

  static const _gradienteVerde = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.27, 1.0],
    colors: [Color(0xFF46C971), Color(0xFF2A914D)],
  );

  static const _corVerde = Color(0xFF42A80B);

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _redefinirSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _carregando = false;
      _sucesso = true;
    });
  }

  void _irParaLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F3),
      appBar: _sucesso
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black54,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: _sucesso ? _buildSucesso() : _buildFormulario(),
          ),
        ),
      ),
    );
  }

  Widget _buildSucesso() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/greenhome_logo.png', height: 160),
        const SizedBox(height: 36),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF46C971).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFF2A914D),
            size: 44,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Senha redefinida!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Sua senha foi alterada com sucesso.\nAgora você pode fazer login normalmente.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
        ),
        const SizedBox(height: 36),
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
              onPressed: _irParaLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Ir para o login',
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
      ],
    );
  }

  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/greenhome_logo.png', height: 160),
          const SizedBox(height: 36),

          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF46C971).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFF2A914D),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nova senha',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Escolha uma senha forte com\npelo menos 6 caracteres.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 32),

          TextFormField(
            controller: _senhaController,
            obscureText: !_senhaVisivel,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              'Nova senha',
              Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _senhaVisivel
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Informe a nova senha';
              if (v.length < 6) return 'Mínimo de 6 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _confirmarSenhaController,
            obscureText: !_confirmarSenhaVisivel,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _redefinirSenha(),
            decoration: _inputDecoration(
              'Confirmar senha',
              Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _confirmarSenhaVisivel
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: () => setState(
                  () => _confirmarSenhaVisivel = !_confirmarSenhaVisivel,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Confirme sua senha';
              if (v != _senhaController.text) {
                return 'As senhas não coincidem';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // ── Botão Redefinir ──────────────────────────────────────
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
                onPressed: _carregando ? null : _redefinirSenha,
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
                        'Redefinir senha',
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

          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Text(
              'Voltar',
              style: TextStyle(
                color: _corVerde,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: _corVerde,
              ),
            ),
          ),
        ],
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
