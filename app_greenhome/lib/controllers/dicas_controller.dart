// controllers/dicas_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DicasController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Busca quais dicas o usuário logado favoritou
  Stream<List<String>> get favoritosStream {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('favoritos')
        .where('criado_por', isEqualTo: user.email)
        .snapshots()
        .map((snapshot) {
      // Retorna uma lista com os IDs das dicas favoritas 
      return snapshot.docs.map((doc) => doc['dica_id'] as String).toList();
    });
  }

  // Adiciona ou remove a dica dos favoritos no banco
  Future<void> alternarFavorito(String dicaId, bool isAtualmenteFavorito) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (isAtualmenteFavorito) {
      // Se já é favorito, remove
      final query = await _firestore
          .collection('favoritos')
          .where('criado_por', isEqualTo: user.email)
          .where('dica_id', isEqualTo: dicaId)
          .get();

      for (var doc in query.docs) {
        await doc.reference.delete();
      }
    } else {
      // Se não é favorito, adiciona
      await _firestore.collection('favoritos').add({
        'dica_id': dicaId,
        'criado_por': user.email, 
      });
    }
  }
}