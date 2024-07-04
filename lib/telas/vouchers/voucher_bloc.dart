import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:web_cashboost/api/api_exception.dart';
import 'package:web_cashboost/api/api_connection.dart';
import 'package:web_cashboost/models/error_model.dart';
import 'package:web_cashboost/models/voucher_model.dart';
import 'package:web_cashboost/telas/vouchers/voucher_event.dart';
import 'package:web_cashboost/telas/vouchers/voucher_service.dart';
import 'package:web_cashboost/telas/vouchers/voucher_state.dart';

class VoucherBloc extends Bloc<VendaEvent, VoucherState> {
  VoucherBloc() : super(VoucherInitialState()) {
    on<VoucherLoadEvent>((event, emit) async {
      emit(VoucherLoadingState());
      try {
        List<VoucherModel> vouchers = [];
        Response response = await getVoucher();

        for (var voucher in jsonDecode(response.body)) {
          var voucherModel = VoucherModel.fromMap(voucher);
          vouchers.add(voucherModel);
        }
        emit(VoucherSuccessState(vouchers: vouchers));
      } catch (e) {
        emit(VoucherErrorState(errorModel: e is ApiException ? ErrorModel.fromMap(jsonDecode(e.response.body)) : ErrorModel.empty()));
      }
    });

    on<VoucherSaveEvent>((event, emit) async {
      emit(VoucherLoadingState());
      try {
        postVoucher(event.voucherModel);
        if(event.image.path.isNotEmpty) {
          editarFotoVoucher(event.voucherModel.id!,event.image);
        }
        emit(VoucherSuccessState(vouchers: []));
      } catch (e) {
        emit(VoucherErrorState(errorModel: e is ApiException ? ErrorModel.fromMap(jsonDecode(e.response.body)) : ErrorModel.empty()));
      }
    });

    on<VoucherDeleteEvent>((event, emit) async {
      emit(VoucherLoadingState());
      try {

        List<VoucherModel> vouchers = [];
        Response response = await deleteVoucher(event.idVoucher);

        for (var voucher in jsonDecode(response.body)) {
          var voucherModel = VoucherModel.fromMap(voucher);
          vouchers.add(voucherModel);
        }

        emit(VoucherSuccessState(vouchers: vouchers));
      } catch (e) {
        emit(VoucherErrorState(errorModel: e is ApiException ? ErrorModel.fromMap(jsonDecode(e.response.body)) : ErrorModel.empty()));
      }
    });
  }
}
