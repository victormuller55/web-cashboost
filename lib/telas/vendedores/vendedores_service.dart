import 'package:web_cashboost/app_widget/endpoints.dart';
import 'package:web_cashboost/functions/service.dart' as service;

Future<service.Response> getVendedores(int idConcessionaria) async {
  return await service.getHTTP(
    endpoint: Endpoint.endpointVendedoresTodos,
    parameters: idConcessionaria != 0 ? {
      "id_concessionaria" : idConcessionaria.toString(),
    } : null,
  );
}

Future<service.Response> getConcessionarias() async {
  return await service.getHTTP(endpoint: Endpoint.endpointConcessionaria);
}
