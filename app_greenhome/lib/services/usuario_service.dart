import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';

class UsuarioService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Usuario> getUsuario() async { //busca o usuario
    User? user = auth.currentUser;
    
    if (user == null) {
      throw Exception('Usuário não autenticado',);
    }
    
    if (!user.email!.endsWith('@souunit.com.br')) { //verifica se esta com email da unit
      await auth.signOut();
      throw Exception('Use um email institucional',);
    }

    DocumentSnapshot dados =
        await firestore
            .collection('usuarios')
            .doc(user.uid)
            .get();
    return Usuario.fromMap(
      dados.data() as Map<String, dynamic>,
    );
  }
  
  Future<void> alterarSenha({  //alteracao de senha
    required String senhaAtual,
    required String novaSenha,
  }) async {
    User? user = auth.currentUser;

    if (user == null) {
      throw Exception('Usuário não autenticado',);
    }
    AuthCredential credential =
        EmailAuthProvider.credential(
      email: user.email!,
      password: senhaAtual,
    );

    await user.reauthenticateWithCredential(credential,);
    await user.updatePassword(novaSenha,);
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}