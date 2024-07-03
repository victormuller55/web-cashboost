class VendaModel {
  int? idVenda;
  int? idUsuario;
  String? nomeUsuario;
  String? vendaNfeCode;
  int? ponteira;
  String? dataEnvio;
  int? vendaAprovado;

  VendaModel({
    this.idVenda,
    this.idUsuario,
    this.nomeUsuario,
    this.vendaNfeCode,
    this.ponteira,
    this.dataEnvio,
    this.vendaAprovado,
  });

  VendaModel.fromMap(Map<String, dynamic> json) {
    idVenda = json['id_venda'];
    idUsuario = json['id_usuario'];
    nomeUsuario = json['nome_usuario'];
    vendaNfeCode = json['venda_nfe_code'];
    ponteira = json['id_ponteira'];
    dataEnvio = json['data_envio'];
    vendaAprovado = json['venda_aprovado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_venda'] = idVenda;
    return data;
  }
}
