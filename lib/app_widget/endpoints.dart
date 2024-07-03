const String server = "http://localhost:5000";

class Endpoint {

  static String endpointEntrarCadastrar = "$server/v1/soamer/usuario";
  static String endpointVendedoresTodos = "$server/v1/soamer/usuario/todos";
  static String endpointConcessionaria = "$server/v1/soamer/concessionaria";

  static String endpointHome = "$server/v1/soamer/usuario/home";
  static String endpointEditarUsuario = "$server/v1/soamer/usuario/edit";
  static String endpointExtrato = "$server/v1/soamer/extrato";
  static String endpointExtratoTodos = "$server/v1/soamer/extrato/todos";
  static String endpointRecuperarSenha = "$server/v1/soamer/senha/recuperar";
  static String endpointHistorico = "$server/v1/soamer/voucher/solicitados";

  static String endpointVaucher = "$server/v1/soamer/vaucher";
  static String endpointVaucherMaisTrocados = "$server/v1/soamer/vaucher/trocados";
  static String endpointVaucherPromocao = "$server/v1/soamer/vaucher/promocao";
  static String endpointTrocarVoucher = "$server/v1/soamer/vaucher/trocar";

  static String endpointVenda = "$server/v1/soamer/venda";
  static String endpointVendaRecusar = "$server/v1/soamer/venda/recusar";

  static String endpointImageUsuario(int idUsuario) {
    return "$server/v1/soamer/usuario/foto?id_usuario=$idUsuario";
  }

  static String endpointImageVoucher(int idVoucher) {
    return "$server/v1/soamer/vaucher/image?id_voucher=$idVoucher";
  }
}
