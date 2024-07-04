import 'package:web_cashboost/api/api_connection.dart' as service;
import 'package:web_cashboost/app_widget/app_consts/app_endpoints.dart';

Future<service.Response> getVendedores(int idConcessionaria) async {
  return await service.getHTTP(
    endpoint: AppEndpoints.endpointVendedoresTodos,
    parameters: idConcessionaria != 0 ? {
      "id_concessionaria" : idConcessionaria.toString(),
    } : null,
  );
}

Future<service.Response> getConcessionarias() async {
  return await service.getHTTP(endpoint: AppEndpoints.endpointConcessionaria);
}
