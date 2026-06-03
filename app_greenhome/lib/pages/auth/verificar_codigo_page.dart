import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nova_senha_page.dart';

class VerificarCodigoPage extends StatefulWidget {
  final String email;
  const VerificarCodigoPage({super.key, required this.email});

  @override
  State<VerificarCodigoPage> createState() => _VerificarCodigoPageState();
}

class _VerificarCodigoPageState extends State<VerificarCodigoPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _carregando = false;
  bool _reenvioDisponivel = false;
  int _segundosRestantes = 60;

  static const _gradienteVerde = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.27, 1.0],
    colors: [Color(0xFF46C971), Color(0xFF2A914D)],
  );

  static const _corVerde = Color(0xFF42A80B);

  @override
  void initState() {
    super.initState();
    _iniciarContador();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _iniciarContador() {
    setState(() {
      _reenvioDisponivel = false;
      _segundosRestantes = 60;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _segundosRestantes--);
      if (_segundosRestantes <= 0) {
        if (mounted) setState(() => _reenvioDisponivel = true);
        return false;
      }
      return true;
    });
  }

  String get _codigoCompleto => _controllers.map((c) => c.text).join();

  Future<void> _verificar() async {
    if (_codigoCompleto.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira o código completo de 6 dígitos.')),
      );
      return;
    }

    setState(() => _carregando = true);

    await Future.delayed(const Duration(seconds: 1));

    setState(() => _carregando = false);

    if (!mounted) return;

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NovaSenhaPage()));
  }

  Future<void> _reenviarCodigo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código reenviado para ${widget.email}'),
        backgroundColor: const Color(0xFF2A914D),
      ),
    );
    _iniciarContador();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F3),
      appBar: AppBar(
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
                    Icons.mark_email_read_rounded,
                    color: Color(0xFF2A914D),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Verifique seu e-mail',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enviamos um código de 6 dígitos para\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) => _buildDigitField(i)),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: _gradienteVerde,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF46C971,
                          ).withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _carregando ? null : _verificar,
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
                              'Verificar código',
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

                if (_reenvioDisponivel)
                  GestureDetector(
                    onTap: _reenviarCodigo,
                    child: const Text(
                      'Reenviar código',
                      style: TextStyle(
                        color: _corVerde,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: _corVerde,
                      ),
                    ),
                  )
                else
                  Text(
                    'Reenviar código em $_segundosRestantes s',
                    style: const TextStyle(color: Colors.black45, fontSize: 14),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDigitField(int index) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
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
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }
}
