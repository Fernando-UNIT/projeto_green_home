import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioController {

  Usuario usuario = UsuarioService.getUsuario();

  Usuario buscarUsuario() {
    return usuario;
  }

  bool alterarSenha({
  required String senhaAtual,
  required String novaSenha,
  required String confirmarSenha,
}) {
  if (senhaAtual != usuario.senha) {
    return false;
  }

  if (novaSenha != confirmarSenha) {
    return false;
  }

  UsuarioService.alterarSenha(novaSenha);

  return true;
}
}