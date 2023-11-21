abstract class VendaEvent {}

class VendaLoadEvent extends VendaEvent {}

class VendaAceitarEvent extends VendaEvent {
  int idVenda;
  int idUsuario;
  int aprovado;

  VendaAceitarEvent(this.idVenda, this.idUsuario, this.aprovado);
}

class VendaRecusarEvent extends VendaEvent {

  String message;
  int idVenda;
  int idUsuario;
  int aprovado;

  VendaRecusarEvent(this.idVenda, this.idUsuario, this.aprovado, this.message);
}