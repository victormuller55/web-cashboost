class VendedoresModel {
  int? id;
  String? nome;
  String? email;
  String? celular;
  String? cpf;
  int? pontos;
  int? pontosPendentes;
  String? senha;
  int? pix;
  int? idConcessionaria;
  String? nomeConcessionaria;

  VendedoresModel({
    this.id,
    this.nome,
    this.email,
    this.celular,
    this.cpf,
    this.pontos,
    this.pontosPendentes,
    this.senha,
    this.pix,
    this.idConcessionaria,
    this.nomeConcessionaria,
  });

  factory VendedoresModel.empty() {
    return VendedoresModel(
      id: 0,
      nome: "",
      cpf: "",
      pontos: 0,
      pontosPendentes: 0,
      email: "",
      senha: "",
      pix: 0,
    );
  }

  VendedoresModel.fromMap(Map<String, dynamic> json) {
    id = json['id_usuario'];
    nome = json['nome_usuario'];
    email = json['email_usuario'];
    cpf = json['cpf_usuario'];
    celular = json['celular_usuario'];
    pontos = json['pontos_usuario'];
    pontosPendentes = json['pontos_pendentes_usuario'];
    senha = json['senha_usuario'];
    idConcessionaria = json['id_concessionaria'];
    nomeConcessionaria = json['nome_concessionaria'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id_usuario'] = id;
    data['nome_usuario'] = nome;
    data['email_usuario'] = email;
    data['celular_usuario'] = celular;
    data['cpf_usuario'] = cpf;
    data['senha_usuario'] = senha;

    return data;
  }
}
