import 'package:web_cashboost/app_widget/endpoints.dart';
import 'package:web_cashboost/functions/service.dart';

Future<Response> getVendas() async {
  return await getHTTP(endpoint: Endpoint.endpointExtratoTodos);
}

Future<Response> aceitarVenda(int idVendedor, int idVenda, int aprovado) async {
  return await putHTTP(
    endpoint: Endpoint.endpointVenda,
    parameters: {
      "id_usuario": idVendedor.toString(),
      "id_venda": idVenda.toString(),
      "aprovado": aprovado.toString(),
    },
  );
}

Future<Response> recusarVenda(int idVendedor, int idVenda, int aprovado, String mensagem) async {
  return await putHTTP(
    endpoint: Endpoint.endpointVendaRecusar,
    parameters: {
      "id_usuario": idVendedor.toString(),
      "id_venda": idVenda.toString(),
      "aprovado": aprovado.toString(),
      "mensagem": mensagem,
    },
  );
}
