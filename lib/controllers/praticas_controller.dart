import '../models/pratica.dart';

class PraticasController {
  static final List<Pratica> _praticas = [
    Pratica(
      id: '1',
      nome: 'Reciclar Lixo',
      categoria: 'Reciclagem',
      descricao:
          'Separar materiais recicláveis, como plástico, papel, vidro e metal, descartando-os corretamente.',
      lembrete: '19:00h',
      tempo: '10 min',
      favorita: true,
    ),
    Pratica(
      id: '2',
      nome: 'Separar Lixo',
      categoria: 'Reciclagem',
      descricao:
          'Separar o lixo orgânico do lixo reciclável para facilitar o descarte sustentável.',
      lembrete: '18:00h',
      tempo: '15 min',
      concluida: true,
    ),
    Pratica(
      id: '3',
      nome: 'Reutilizar Embalagens',
      categoria: 'Reciclagem',
      descricao:
          'Guardar embalagens que podem ser reutilizadas em casa, evitando desperdício.',
      lembrete: '20:00h',
      tempo: '10 min',
    ),
    Pratica(
      id: '4',
      nome: 'Apagar Luzes',
      categoria: 'Energia',
      descricao:
          'Apagar as luzes dos cômodos que não estão sendo utilizados para economizar energia.',
      lembrete: '22:00h',
      tempo: '5 min',
      concluida: true,
      favorita: true,
    ),
    Pratica(
      id: '5',
      nome: 'Economizar Água',
      categoria: 'Consumo',
      descricao:
          'Reduzir o tempo no banho e fechar a torneira ao escovar os dentes.',
      lembrete: '07:00h',
      tempo: '10 min',
      concluida: true,
      favorita: true,
    ),
  ];

  List<Pratica> listar() {
    return _praticas;
  }

  void adicionar(Pratica pratica) {
    _praticas.add(pratica);
  }

  void atualizar(Pratica praticaAtualizada) {
    final index = _praticas.indexWhere(
      (pratica) => pratica.id == praticaAtualizada.id,
    );

    if (index != -1) {
      _praticas[index] = praticaAtualizada;
    }
  }

  void excluir(String id) {
    _praticas.removeWhere((pratica) => pratica.id == id);
  }

  void alternarConclusao(String id) {
    final pratica = _praticas.firstWhere((pratica) => pratica.id == id);
    pratica.concluida = !pratica.concluida;
  }

  void alternarFavorito(String id) {
    final pratica = _praticas.firstWhere((pratica) => pratica.id == id);
    pratica.favorita = !pratica.favorita;
  }
}
