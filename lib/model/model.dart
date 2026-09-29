class Equipamento {
  final String codigo;
  final String nome;
  final String descricao;
  final String categoria;
  final String marca;
  final String modelo;
  final String numeroSerie;
  final String estadoConservacao;
  final String localizacao;
  final int professorId;
  final String observacoes;

  Equipamento({
    required this.codigo,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    required this.estadoConservacao,
    required this.localizacao,
    required this.professorId,
    required this.observacoes,
  });

  factory Equipamento.fromJson(Map<String, dynamic> json) {
    return Equipamento(
      codigo: json['codigo'],
      nome: json['nome'],
      descricao: json['descricao'],
      categoria: json['categoria'],
      marca: json['marca'],
      modelo: json['modelo'],
      numeroSerie: json['numeroSerie'],
      estadoConservacao: json['estadoConservacao'],
      localizacao: json['localizacao'],
      professorId: json['professorId'],
      observacoes: json['observacoes'],
    );
  }
}

class Administrativo{
  final String email;
  final String nome;
  final String password;
  final String departamento;
  final String telefone;
  final String cpf;


  Administrativo({
    required this.email,
    required this.password,
    required this.nome,
    required this.departamento,
    required this.telefone,
    required this.cpf
    
  });

  factory Administrativo.fromJson(Map<String, dynamic> json) {
    return Administrativo(
      email: json['email'],
      password: json['password'],
      nome: json['nome'],
      departamento: json['departamento'],
      telefone: json['telefone'],
      cpf: json['cpf']
     

    );
  }
}

class Professores{
  final String nome;
  final String email;
  final String password;
  final String matricula;
  final String departamento;
  final String telefone;
  final String cpf;

  Professores({
    required this.nome,
    required this.email,
    required this.password,
    required this.matricula,
    required this.departamento,
    required this.telefone,
    required this.cpf,
  });

  factory Professores.fromJson(Map<String, dynamic> json) {
    return Professores(
      nome: json['nome'],
      email: json['email'],
      password: json['password'],
      matricula: json['matricula'],
      departamento: json['departamento'],
      telefone: json['telefone'],
      cpf: json['cpf']
    );
  }
}