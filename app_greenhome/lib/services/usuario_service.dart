import '../models/usuario.dart';

class UsuarioService {

  static Usuario usuario = Usuario(
    nome: 'Carlos Alyrio',
    email: 'emailusuario@email.com',
    senha: '123456',
  );

  static Usuario getUsuario() {
    return usuario;
  }

  static void alterarSenha(String novaSenha) {
    usuario.senha = novaSenha;
  }

}