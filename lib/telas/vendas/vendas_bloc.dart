import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:web_cashboost/app_widget/api_exception.dart';
import 'package:web_cashboost/functions/service.dart';
import 'package:web_cashboost/models/error_model.dart';
import 'package:web_cashboost/models/venda_model.dart';
import 'package:web_cashboost/telas/vendas/vendas_event.dart';
import 'package:web_cashboost/telas/vendas/vendas_service.dart';
import 'package:web_cashboost/telas/vendas/vendas_state.dart';

class VendaBloc extends Bloc<VendaEvent, VendaState> {
  VendaBloc() : super(VendaInitialState()) {
    on<VendaLoadEvent>((event, emit) async {
      emit(VendaLoadingState());
      try {
        List<VendaModel> vendas = [];
        Response response = await getVendas();

        for (var voucher in jsonDecode(response.body)) {
          var vendaModel = VendaModel.fromMap(voucher);
          vendas.add(vendaModel);
        }

        emit(VendaSuccessState(vendas: vendas));
      } catch (e) {
        emit(VendaErrorState(errorModel: e is ApiException ? ErrorModel.fromMap(jsonDecode(e.response.body)) : ErrorModel.empty()));
      }
    });

    on<VendaAceitarEvent>((event, emit) async {
      emit(VendaLoadingState());
      try {
        List<VendaModel> vendas = [];
        Response response = await aceitarVenda(event.idUsuario, event.idVenda, event.aprovado);

        for (var voucher in jsonDecode(response.body)) {
          var vendaModel = VendaModel.fromMap(voucher);
          vendas.add(vendaModel);
        }

        emit(VendaSuccessState(vendas: vendas));
      } catch (e) {
        emit(VendaErrorState(errorModel: e is ApiException ? ErrorModel.fromMap(jsonDecode(e.response.body)) : ErrorModel.empty()));
      }
    });

    on<VendaRecusarEvent>((event, emit) async {
      emit(VendaLoadingState());
      try {
        List<VendaModel> vendas = [];
        Response response = await recusarVenda(event.idUsuario, event.idVenda, event.aprovado, event.message);

        for (var voucher in jsonDecode(response.body)) {
          var vendaModel = VendaModel.fromMap(voucher);
          vendas.add(vendaModel);
        }

        emit(VendaSuccessState(vendas: vendas));
      } catch (e) {
        emit(VendaErrorState(errorModel: e is ApiException ? ErrorModel.fromMap(jsonDecode(e.response.body)) : ErrorModel.empty()));
      }
    });
  }
}
