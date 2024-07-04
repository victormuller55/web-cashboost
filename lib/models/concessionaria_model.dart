class ConcessionariaModel {
  int? id;
  String? marca;
  String? nome;
  String? cnpj;
  String? endereco;

  ConcessionariaModel({
    this.id,
    this.marca,
    this.nome,
    this.cnpj,
    this.endereco,
  });

  factory ConcessionariaModel.empty() {
    return ConcessionariaModel(
      id: 0,
      nome: "",
      cnpj: "",
      marca: "",
      endereco: "",
    );
  }

  ConcessionariaModel.fromMap(Map<String, dynamic> json) {
    id = json['id_concessionaria'];
    marca = json['marca_concessionaria'];
    nome = json['nome_concessionaria'];
    cnpj = json['cnpj_concessionaria'];
    endereco = json['endereco_concessionaria'];
  }
}
