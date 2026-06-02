class Usuario {
  final String nome;
  final String email;

  Usuario({
    required this.nome,
    required this.email,
  });

  factory Usuario.fromMap(
    Map<String, dynamic> map,
  ) {
    return Usuario(
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
    };
  }
}