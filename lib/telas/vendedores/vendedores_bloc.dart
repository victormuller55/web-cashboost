import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:web_cashboost/api/api_exception.dart';
import 'package:web_cashboost/api/api_connection.dart';
import 'package:web_cashboost/models/concessionaria_model.dart';
import 'package:web_cashboost/models/error_model.dart';
import 'package:web_cashboost/models/vendedor_model.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_event.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_service.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_state.dart';

class VendedoresBloc extends Bloc<VendedoresEvent, VendedoresState> {
  VendedoresBloc() : super(VendedoresInitialState()) {
    on<VendedoresLoadEvent>((event, emit) async {
      emit(VendedoresLoadingState());
      try {

        Response responseVendedores = await getVendedores(event.idConcessionaria);
        Response responseConcessionaria = await getConcessionarias();

        List<VendedoresModel> vendedores = [];
        List<ConcessionariaModel> concessionarias = [];

        for (var voucher in jsonDecode(responseVendedores.body)) {
          var vendedoresModel = VendedoresModel.fromMap(voucher);
          vendedores.add(vendedoresModel);
        }

        for (var voucher in jsonDecode(responseConcessionaria.body)) {
          var concessionariaModel = ConcessionariaModel.fromMap(voucher);
          concessionarias.add(concessionariaModel);
        }

        emit(VendedoresSuccessState(usuarioModel: vendedores, concessionariaList: concessionarias));
      } catch (e) {
        emit(VendedoresErrorState(errorModel: ApiException.errorModel(e)));
      }
    });
  }
}
