class HistoricoModel {
  int? idHistorico;
  int? idVoucher;
  int? idUsuario;
  String? nomeUsuario;
  String? titulo;
  String? tituloVoucher;
  int? valor;
  String? dataPedido;
  bool? enviado;

  HistoricoModel({
    this.idHistorico,
    this.idVoucher,
    this.idUsuario,
    this.nomeUsuario,
    this.titulo,
    this.tituloVoucher,
    this.valor,
    this.dataPedido,
    this.enviado,
  });

  HistoricoModel.fromMap(Map<String, dynamic> json) {
    idHistorico = json['id_historico'];
    idVoucher = json['id_voucher'];
    idUsuario = json['id_usuario'];
    nomeUsuario = json['nome_usuario'];
    titulo = json['titulo'];
    tituloVoucher = json['titulo_voucher'];
    valor = json['valor'];
    dataPedido = json['data_pedido'];
    enviado = json['enviado'];
  }
}
