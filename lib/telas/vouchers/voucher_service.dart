import 'dart:io';

import 'package:web_cashboost/app_widget/endpoints.dart';
import 'package:web_cashboost/functions/service.dart';
import 'package:web_cashboost/models/voucher_model.dart';

Future<Response> getVoucher() async {
  return await getHTTP(endpoint: Endpoint.endpointVaucher);
}

Future<Response> deleteVoucher(int idVoucher) async {
  return await deleteHTTP(
    endpoint: Endpoint.endpointVaucher,
    parameters: {"id_vaucher": idVoucher.toString()},
  );
}

Future<Response> postVoucher(VoucherModel voucherModel) async {
  return await postHTTP(
    endpoint: Endpoint.endpointVaucher,
    body: voucherModel.id == null ? voucherModel.toMapPost() : voucherModel.toMapPut(),
  );
}

Future<Response> editarFotoVoucher(int idUsuario, File file) async {
  return await postHTTP(
    endpoint: Endpoint.endpointImageUsuario(idUsuario),
    body: {},
    file: file,
  );
}
