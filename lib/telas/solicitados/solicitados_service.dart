import 'package:web_cashboost/api/api_connection.dart';
import 'package:web_cashboost/app_widget/app_consts/app_endpoints.dart';

Future<Response> getSolicitacoes() async {
  return await getHTTP(endpoint: AppEndpoints.endpointHistorico);
}

Future<Response> putSolicitacao(int idSolicitacao) async {
  return await putHTTP(
    endpoint: AppEndpoints.endpointHistorico,
    parameters: {
      "id_historico": idSolicitacao.toString(),
    },
  );
}
