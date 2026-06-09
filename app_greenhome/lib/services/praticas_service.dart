import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/pratica.dart';

class PraticasService {

  String get uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuário não logado');
    return user.uid;
  }

  String get email {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email ?? '';
  }

  Future<void> criarPratica(Pratica p) async {
    await FirebaseFirestore.instance
        .collection('users/$uid/praticas')
        .doc(p.id)
        .set({
      'nome': p.nome,
      'categoria': p.categoria,
      'descricao': p.descricao,
      'lembrete': p.lembrete,
      'tempo': p.tempo,
      'concluida': p.concluida,
      'favorita': p.favorita,
      'criado_por': email,
      'criado_em': FieldValue.serverTimestamp(),
    });
  }

  Future<void> atualizarPratica(Pratica p) async {
    await FirebaseFirestore.instance
        .collection('users/$uid/praticas')
        .doc(p.id)
        .update({
      'nome': p.nome,
      'categoria': p.categoria,
      'descricao': p.descricao,
      'lembrete': p.lembrete,
      'tempo': p.tempo,
      'concluida': p.concluida,
      'favorita': p.favorita,
    });
  }

  Future<void> excluirPratica(Pratica p) async {
    await FirebaseFirestore.instance
        .collection('users/$uid/praticas')
        .doc(p.id)
        .delete();
  }

  Stream<List<Pratica>> listarPraticas() {
    return FirebaseFirestore.instance
        .collection('users/$uid/praticas')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Pratica(
                id: doc.id,
                nome: data['nome'] ?? '',
                categoria: data['categoria'] ?? '',
                descricao: data['descricao'] ?? '',
                lembrete: data['lembrete'] ?? '',
                tempo: data['tempo'] ?? '',
                concluida: data['concluida'] ?? false,
                favorita: data['favorita'] ?? false,
              );
            }).toList());
  }
}