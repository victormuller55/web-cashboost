import 'package:web_cashboost/app_widget/endpoints.dart';
import 'package:web_cashboost/functions/service.dart';

Future<Response> getVendas() async {
  return await getHTTP(endpoint: Endpoint.endpointVenda);
}

Future<Response> aceitarVenda(int idVenda) async {
  return await putHTTP(
    endpoint: Endpoint.endpointVenda,
    parameters: {
      "id_venda": idVenda.toString(),
    },
  );
}

Future<Response> recusarVenda(int idVenda, String mensagem) async {
  return await putHTTP(
    endpoint: Endpoint.endpointVendaRecusar,
    parameters: {
      "id_venda": idVenda.toString(),
      "mensagem": mensagem,
    },
  );
}
