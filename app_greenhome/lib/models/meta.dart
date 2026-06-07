// models/meta.dart
class Meta {
  final String id;
  final String nome;
  final String categoria; 
  final String duracao;
  int progressoDias;
  int totalDias;
  final String criadoPor; 

  Meta({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.duracao,
    this.progressoDias = 0, 
    this.totalDias = 30,
    required this.criadoPor,
  });

  // Retorna o progresso em formato decimal e evita dividir por 0
  double get percentual {
    if (totalDias <= 0) return 0.0;
    return progressoDias / totalDias;
  }

  // Converte o objeto para o formato JSON/Map que o Firebase entende
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'categoria': categoria,
      'duracao': duracao,
      'progressoDias': progressoDias,
      'totalDias': totalDias,
      'criado_por': criadoPor, 
    };
  }

  // Transforma os dados que chegam do Firebase em um objeto Dart
  factory Meta.fromMap(Map<String, dynamic> map, String documentId) {
    return Meta(
      id: documentId,
      nome: map['nome'] ?? '',
      categoria: map['categoria'] ?? '',
      duracao: map['duracao'] ?? '',
      progressoDias: map['progressoDias']?.toInt() ?? 0,
      totalDias: map['totalDias']?.toInt() ?? 30,
      criadoPor: map['criado_por'] ?? '',
    );
  }
}