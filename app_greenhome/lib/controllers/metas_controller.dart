import '../models/meta.dart';

class MetasController {
  static final List<Meta> _metas = [];

  List<Meta> get metas => _metas;

  void adicionar(Meta meta) {
    _metas.add(meta);
  }

  void remover(int index) {
    _metas.removeAt(index);
  }
}
