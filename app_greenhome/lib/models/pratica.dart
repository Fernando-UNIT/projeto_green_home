class Pratica {
  final String id;
  String nome;
  String categoria;
  String descricao;
  String lembrete;
  String tempo;
  bool concluida;
  bool favorita;

  Pratica({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.descricao,
    required this.lembrete,
    required this.tempo,
    this.concluida = false,
    this.favorita = false,
  });
}