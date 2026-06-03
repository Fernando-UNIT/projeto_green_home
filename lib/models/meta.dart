// models/meta.dart
class Meta {
  final String id;
  final String nome;
  final String categoria; 
  final String duracao;
  int progressoDias;
  int totalDias;

  Meta({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.duracao,
    this.progressoDias = 0, 
    this.totalDias = 30,   
  });
  // Retorna o progresso em formato decimal e evita dividir por 0
  double get percentual {
    if (totalDias <= 0) return 0.0; 
    return progressoDias / totalDias;
  }
}