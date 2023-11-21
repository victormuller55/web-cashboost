class VoucherModel {
  int? id;
  String? titulo;
  String? descricao;
  String? dataComeco;
  String? dataFinal;
  int? pontosCheio;
  int? desconto;
  int? pontos;

  VoucherModel({
    this.id,
    this.titulo,
    this.descricao,
    this.dataComeco,
    this.dataFinal,
    this.pontosCheio,
    this.desconto,
    this.pontos,
  });

  factory VoucherModel.empty() {
    return VoucherModel(
      id: 0,
      titulo: "",
      descricao: "",
      dataComeco: "",
      dataFinal: "",
      pontosCheio: 0,
      desconto: 0,
      pontos: 0,
    );
  }

  VoucherModel.fromMap(Map<String, dynamic> json) {
    id = json['id_vaucher'];
    titulo = json['titulo_vaucher'];
    descricao = json['info_vaucher'];
    dataComeco = json['data_comeco_vaucher'];
    dataFinal = json['data_final_vaucher'];
    pontosCheio = json['pontos_cheio_vaucher'];
    desconto = json['desconto_vaucher'];
    pontos = json['pontos_vaucher'];
  }

  Map<String, dynamic> toMapPut() {
    return {
      'id_vaucher': id,
      'titulo_vaucher': titulo,
      'info_vaucher': descricao,
      'data_comeco_vaucher': dataComeco,
      'data_final_vaucher': dataFinal,
      'pontos_cheio_vaucher': pontosCheio,
      'desconto_vaucher': desconto,
      'pontos_vaucher': pontos,
    };
  }

  Map<String, dynamic> toMapPost() {
    return {
      'titulo_vaucher': titulo,
      'info_vaucher': descricao,
      'data_comeco_vaucher': dataComeco,
      'data_final_vaucher': dataFinal,
      'pontos_cheio_vaucher': pontosCheio,
    };
  }
}
