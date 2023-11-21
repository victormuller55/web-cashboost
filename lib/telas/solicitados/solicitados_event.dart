abstract class SolicitadosEvent {}

class SolicitadosLoadEvent extends SolicitadosEvent {}

class SolicitadosEnviadoEvent extends SolicitadosEvent {
  int idSolicitacao;
  SolicitadosEnviadoEvent(this.idSolicitacao);
}