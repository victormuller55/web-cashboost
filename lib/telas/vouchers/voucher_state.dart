import 'package:web_cashboost/models/error_model.dart';
import 'package:web_cashboost/models/voucher_model.dart';

abstract class VoucherState {
  ErrorModel errorModel;
  List<VoucherModel> vouchers;

  VoucherState({required this.vouchers, required this.errorModel});
}

class VoucherInitialState extends VoucherState {
  VoucherInitialState() : super(vouchers: [], errorModel: ErrorModel.empty());
}

class VoucherLoadingState extends VoucherState {
  VoucherLoadingState() : super(vouchers: [], errorModel: ErrorModel.empty());
}

class VoucherSuccessState extends VoucherState {
  VoucherSuccessState({required List<VoucherModel> vouchers}) : super(vouchers: vouchers, errorModel: ErrorModel.empty());
}

class VoucherErrorState extends VoucherState {
  VoucherErrorState({required ErrorModel errorModel}) : super(vouchers: [], errorModel: errorModel);
}
