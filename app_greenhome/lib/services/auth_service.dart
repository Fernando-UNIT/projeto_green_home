import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Salva ou atualiza o usuário no Firestore
  static Future<void> _salvarUsuarioFirestore(User user, {String? nomeExtra}) async {
    final doc = _firestore.collection('usuarios').doc(user.uid);
    final snapshot = await doc.get();

    if (!snapshot.exists) {
      // Cria o documento se não existir ainda
      await doc.set({
        'nome': nomeExtra ?? user.displayName ?? 'Usuário',
        'email': user.email ?? '',
        'uid': user.uid,
        'criadoEm': FieldValue.serverTimestamp(),
      });
    }
  }

  // Login com e-mail e senha
  static Future<UserCredential> loginEmail(String email, String senha) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  // Cadastro com e-mail e senha e salva no Firestore
  static Future<UserCredential> cadastrarEmail({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );

    await credencial.user?.updateDisplayName(nome.trim());

    await _salvarUsuarioFirestore(credencial.user!, nomeExtra: nome.trim());

    return credencial;
  }

  // Login com Google 
  static Future<UserCredential?> loginGoogle() async {
    final provider = GoogleAuthProvider();
    final credencial = await _auth.signInWithPopup(provider);

    // Salva no Firestore
    await _salvarUsuarioFirestore(credencial.user!);

    return credencial;
  }

  // Logout
  static Future<void> sair() async {
    await _auth.signOut();
  }

  // Usuário atualmente logado
  static User? get usuarioAtual => _auth.currentUser;

  // Traduz os erros do Firebase para português
  static String traduzirErro(String codigo) {
    switch (codigo) {
      case 'user-not-found':
        return 'Nenhuma conta encontrada com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'Senha muito fraca. Use no mínimo 6 caracteres.';
      case 'network-request-failed':
        return 'Sem conexão com a internet.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      default:
        return 'Erro inesperado. Tente novamente.';
    }
  }
}