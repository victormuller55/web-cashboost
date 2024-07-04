import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:web_cashboost/api/api_exception.dart';
import 'package:web_cashboost/api/api_connection.dart';
import 'package:web_cashboost/models/error_model.dart';
import 'package:web_cashboost/models/historico_model.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_event.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_service.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_state.dart';

class SolicitadosBloc extends Bloc<SolicitadosEvent, SolicitadosState> {
  SolicitadosBloc() : super(SolicitadosInitialState()) {
    on<SolicitadosLoadEvent>((event, emit) async {
      emit(SolicitadosLoadingState());
      try {
        List<HistoricoModel> solicitacoes = [];
        Response response = await getSolicitacoes();

        for (var voucher in jsonDecode(response.body)) {
          var vendaModel = HistoricoModel.fromMap(voucher);
          solicitacoes.add(vendaModel);
        }

        emit(SolicitadosSuccessState(solicitacoes: solicitacoes));
      } catch (e) {
        emit(SolicitadosErrorState(errorModel: ApiException.errorModel(e)));
      }
    });

    on<SolicitadosEnviadoEvent>((event, emit) async {
      emit(SolicitadosLoadingState());
      try {

        List<HistoricoModel> solicitacoes = [];
        Response response = await putSolicitacao(event.idSolicitacao);

        for (var voucher in jsonDecode(response.body)) {
          var vendaModel = HistoricoModel.fromMap(voucher);
          solicitacoes.add(vendaModel);
        }

        emit(SolicitadosSuccessState(solicitacoes: solicitacoes));
      } catch (e) {
        emit(SolicitadosErrorState(errorModel: ApiException.errorModel(e)));
      }
    });
  }
}
