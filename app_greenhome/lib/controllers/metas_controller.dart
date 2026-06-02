// controllers/metas_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/meta.dart';

class MetasController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Meta>> get metasStream {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return const Stream.empty();

    return _firestore
        .collection('metas')
        // Regra de Domínio: Traz apenas as metas do usuário logado
        .where('criado_por', isEqualTo: currentUser.email) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Meta.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> adicionar(String nome, String categoria, String duracao, int totalDias) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _firestore.collection('metas').add({
      'nome': nome,
      'categoria': categoria,
      'duracao': duracao,
      'progressoDias': 0,
      'totalDias': totalDias,
      // Amarração dinâmica exigida na avaliação
      'criado_por': currentUser.email, 
    });
  }

  Future<void> remover(String id) async {
    await _firestore.collection('metas').doc(id).delete();
  }

  Future<void> incrementar(Meta meta) async {
    if (meta.progressoDias < meta.totalDias) {
      await _firestore.collection('metas').doc(meta.id).update({
        'progressoDias': FieldValue.increment(1),
      });
    }
  }

  Future<void> decrementar(Meta meta) async {
    if (meta.progressoDias > 0) {
      await _firestore.collection('metas').doc(meta.id).update({
        'progressoDias': FieldValue.increment(-1),
      });
    }
  }
}