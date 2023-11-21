import 'package:web_cashboost/models/error_model.dart';
import 'package:web_cashboost/models/historico_model.dart';

abstract class SolicitadosState {
  ErrorModel errorModel;
  List<HistoricoModel> solicitacoes;

  SolicitadosState({required this.solicitacoes, required this.errorModel});
}

class SolicitadosInitialState extends SolicitadosState {
  SolicitadosInitialState() : super(solicitacoes: [], errorModel: ErrorModel.empty());
}

class SolicitadosLoadingState extends SolicitadosState {
  SolicitadosLoadingState() : super(solicitacoes: [], errorModel: ErrorModel.empty());
}

class SolicitadosSuccessState extends SolicitadosState {
  SolicitadosSuccessState({required List<HistoricoModel> solicitacoes}) : super(solicitacoes: solicitacoes, errorModel: ErrorModel.empty());
}

class SolicitadosErrorState extends SolicitadosState {
  SolicitadosErrorState({required ErrorModel errorModel}) : super(solicitacoes: [], errorModel: errorModel);
}
