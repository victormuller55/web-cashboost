import 'package:web_cashboost/models/concessionaria_model.dart';
import 'package:web_cashboost/models/error_model.dart';
import 'package:web_cashboost/models/usuario_model.dart';

abstract class VendedoresState {
  ErrorModel errorModel;
  List<VendedoresModel> usuarioModel;
  List<ConcessionariaModel> concessionariaList;


  VendedoresState({required this.usuarioModel, required this.errorModel, required this.concessionariaList});
}

class VendedoresInitialState extends VendedoresState {
  VendedoresInitialState() : super(usuarioModel: [], errorModel: ErrorModel.empty(), concessionariaList: []);
}

class VendedoresLoadingState extends VendedoresState {
  VendedoresLoadingState() : super(usuarioModel: [], errorModel: ErrorModel.empty(), concessionariaList: []);
}

class VendedoresSuccessState extends VendedoresState {
  VendedoresSuccessState({required List<VendedoresModel> usuarioModel, required List<ConcessionariaModel> concessionariaList}) : super(usuarioModel: usuarioModel, errorModel: ErrorModel.empty(), concessionariaList: concessionariaList);
}

class VendedoresErrorState extends VendedoresState {
  VendedoresErrorState({required ErrorModel errorModel}) : super(usuarioModel: [], errorModel: errorModel, concessionariaList: []);
}