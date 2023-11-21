abstract class VendedoresEvent {}

class VendedoresLoadEvent extends VendedoresEvent {
  int idConcessionaria;

  VendedoresLoadEvent({required this.idConcessionaria});
}
