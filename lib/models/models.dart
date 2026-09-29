class Equipamento {
  final String nome;
  final String patrimonio;
  final String categoria;
  final String marca;
  final String modelo;

  Equipamento({
    required this.nome,
    required this.patrimonio,
    required this.categoria,
    required this.marca,
    required this.modelo,
  });

  factory Equipamento.fromJson(Map<String, dynamic> json) {
    return Equipamento(
      nome: json['nome'],
      patrimonio: json['patrimonio'],
      categoria: json['categoria'],
      marca: json['marca'],
      modelo: json['modelo'],
    );
  }
}

class Administrativo{
  final String nome;
  final String email;
  final String senha;

  Administrativo({
    required this.nome,
    required this.email,
    required this.senha,
  });

  factory Administrativo.fromJson(Map<String, dynamic> json) {
    return Administrativo(
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
    );
  }
}