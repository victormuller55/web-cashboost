import 'package:web_cashboost/models/error_model.dart';
import 'package:web_cashboost/models/venda_model.dart';

abstract class VendaState {
  ErrorModel errorModel;
  List<VendaModel> vendas;

  VendaState({required this.vendas, required this.errorModel});
}

class VendaInitialState extends VendaState {
  VendaInitialState() : super(vendas: [], errorModel: ErrorModel.empty());
}

class VendaLoadingState extends VendaState {
  VendaLoadingState() : super(vendas: [], errorModel: ErrorModel.empty());
}

class VendaSuccessState extends VendaState {
  VendaSuccessState({required List<VendaModel> vendas}) : super(vendas: vendas, errorModel: ErrorModel.empty());
}

class VendaErrorState extends VendaState {
  VendaErrorState({required ErrorModel errorModel}) : super(vendas: [], errorModel: errorModel);
}
