abstract class VendaEvent {}

class VendaLoadEvent extends VendaEvent {}

class VendaAceitarEvent extends VendaEvent {
  int idVenda;

  VendaAceitarEvent(this.idVenda);
}

class VendaRecusarEvent extends VendaEvent {

  String message;
  int idVenda;

  VendaRecusarEvent(this.idVenda,this.message);
}