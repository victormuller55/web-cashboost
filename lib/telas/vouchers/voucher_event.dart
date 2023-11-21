import 'dart:io';

import 'package:web_cashboost/models/voucher_model.dart';

abstract class VendaEvent {}

class VoucherLoadEvent extends VendaEvent {}

class VoucherDeleteEvent extends VendaEvent {
  int idVoucher;

  VoucherDeleteEvent(this.idVoucher);
}

class VoucherSaveEvent extends VendaEvent {
  VoucherModel voucherModel;
  File image;
  VoucherSaveEvent(this.voucherModel, this.image);
}
