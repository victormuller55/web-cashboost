import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_cashboost/models/usuario_model.dart';

void saveLocalUserData(VendedoresModel usuarioModel) async {
  final SharedPreferences localData = await SharedPreferences.getInstance();

  localData.setInt("id", usuarioModel.idUsuario ?? 0);
  localData.setString("nome", usuarioModel.nomeUsuario ?? "");
  localData.setString("email", usuarioModel.emailUsuario ?? "");
  localData.setString("cpf", usuarioModel.cpfUsuario ?? "");
}

Future<VendedoresModel> getModelLocal() async {
  final SharedPreferences localData = await SharedPreferences.getInstance();

  return VendedoresModel(
    idUsuario: localData.getInt("id"),
    nomeUsuario: localData.getString("nome"),
    emailUsuario: localData.getString("email"),
    cpfUsuario: localData.getString("cpf"),
    nomeConcessionaria: localData.getString("nome_concessionaria"),
  );
}

void clearLocalData() async {
  final SharedPreferences localData = await SharedPreferences.getInstance();
  localData.clear();
}

Future<bool> temLocalData() async {
  final SharedPreferences localData = await SharedPreferences.getInstance();
  return localData.getInt("id") != null;
}

void addLocalDataString(String key, String value) async {
  final SharedPreferences localData = await SharedPreferences.getInstance();
  localData.setString(key, value);
}

void addLocalDataInt(String key, int value) async {
  final SharedPreferences localData = await SharedPreferences.getInstance();
  localData.setInt(key, value);
}

void addLocalDataDouble(String key, double value) async {
  final SharedPreferences localData = await SharedPreferences.getInstance();
  localData.setDouble(key, value);
}

void addLocalDataBool(String key, bool value) async {
  final SharedPreferences localData = await SharedPreferences.getInstance();
  localData.setBool(key, value);
}
