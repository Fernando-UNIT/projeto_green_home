// controllers/metas_controller.dart
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

  void incrementar(int index) {
    if (_metas[index].progressoDias < _metas[index].totalDias) {
      _metas[index].progressoDias++;
    }
  }

  void decrementar(int index) {
    if (_metas[index].progressoDias > 0) {
      _metas[index].progressoDias--;
    }
  }
}