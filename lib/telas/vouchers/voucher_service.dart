import 'dart:io';

import 'package:web_cashboost/api/api_connection.dart';
import 'package:web_cashboost/app_widget/app_consts/app_endpoints.dart';
import 'package:web_cashboost/models/voucher_model.dart';

Future<Response> getVoucher() async {
  return await getHTTP(endpoint: AppEndpoints.endpointVaucher);
}

Future<Response> deleteVoucher(int idVoucher) async {
  return await deleteHTTP(
    endpoint: AppEndpoints.endpointVaucher,
    parameters: {"id_vaucher": idVoucher.toString()},
  );
}

Future<Response> postVoucher(VoucherModel voucherModel) async {
  return await postHTTP(
    endpoint: AppEndpoints.endpointVaucher,
    body: voucherModel.id == null ? voucherModel.toMapPost() : voucherModel.toMapPut(),
  );
}

Future<Response> editarFotoVoucher(int idUsuario, File file) async {
  return await postHTTP(
    endpoint: AppEndpoints.endpointImageVoucher(idUsuario),
    body: {},
    file: file,
  );
}
