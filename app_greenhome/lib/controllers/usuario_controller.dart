import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioController {
  final UsuarioService service =
      UsuarioService();
  Future<Usuario> buscarUsuario() async {   //busca o usuario
    return await service.getUsuario();
  }
  
  Future<String?> alterarSenha({  //altera a senha
    required String senhaAtual,
    required String novaSenha,
    required String confirmarSenha,
  }) async {
    if (senhaAtual.isEmpty ||     //validacao dos campos
        novaSenha.isEmpty ||
        confirmarSenha.isEmpty) {

      return 'Preencha todos os campos';
    }
    if (novaSenha != confirmarSenha) {   //confirma a nova senha
      return 'As senhas não são iguais';
    }
    if (novaSenha.length < 6) {
      return 'A senha deve ter no min. 6 caracteres';
    }
    try {
      await service.alterarSenha(
        senhaAtual: senhaAtual,
        novaSenha: novaSenha,
      );
      return null;

    } catch (e) {
      return 'Erro ao alterar senha';
    }
  }

  Future<void> logout() async {
    await service.logout();
  }
}