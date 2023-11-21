import 'package:web_cashboost/app_widget/endpoints.dart';
import 'package:web_cashboost/functions/service.dart';

Future<Response> getSolicitacoes() async {
  return await getHTTP(endpoint: Endpoint.endpointHistorico);
}

Future<Response> putSolicitacao(int idSolicitacao) async {
  return await putHTTP(
    endpoint: Endpoint.endpointHistorico,
    parameters: {
      "id_historico": idSolicitacao.toString(),
    },
  );
}
