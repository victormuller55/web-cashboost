import 'package:web_cashboost/app_widget/app_consts/app_endpoints.dart';
import 'package:web_cashboost/api/api_connection.dart';

Future<Response> getVendas() async {
  return await getHTTP(endpoint: AppEndpoints.endpointVenda);
}

Future<Response> aceitarVenda(int idVenda) async {
  return await putHTTP(
    endpoint: AppEndpoints.endpointVenda,
    parameters: {
      "id_venda": idVenda.toString(),
    },
  );
}

Future<Response> recusarVenda(int idVenda, String mensagem) async {
  return await putHTTP(
    endpoint: AppEndpoints.endpointVendaRecusar,
    parameters: {
      "id_venda": idVenda.toString(),
      "mensagem": mensagem,
    },
  );
}
