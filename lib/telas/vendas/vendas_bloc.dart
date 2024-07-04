import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:web_cashboost/api/api_exception.dart';
import 'package:web_cashboost/api/api_connection.dart';
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

        emit(VendaErrorState(errorModel: ApiException.errorModel(e)));
      }
    });

    on<VendaAceitarEvent>((event, emit) async {
      emit(VendaLoadingState());
      try {
        List<VendaModel> vendas = [];
        Response response = await aceitarVenda(event.idVenda);

        for (var voucher in jsonDecode(response.body)) {
          var vendaModel = VendaModel.fromMap(voucher);
          vendas.add(vendaModel);
        }

        emit(VendaSuccessState(vendas: vendas));
      } catch (e) {
        emit(VendaErrorState(errorModel: ApiException.errorModel(e)));

      }
    });

    on<VendaRecusarEvent>((event, emit) async {
      emit(VendaLoadingState());
      try {
        List<VendaModel> vendas = [];
        Response response = await recusarVenda(event.idVenda, event.message);

        for (var voucher in jsonDecode(response.body)) {
          var vendaModel = VendaModel.fromMap(voucher);
          vendas.add(vendaModel);
        }

        emit(VendaSuccessState(vendas: vendas));
      } catch (e) {
        emit(VendaErrorState(errorModel: ApiException.errorModel(e)));
      }
    });
  }
}
