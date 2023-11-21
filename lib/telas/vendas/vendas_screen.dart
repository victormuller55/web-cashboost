import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_cashboost/app_widget/color/colors.dart';
import 'package:web_cashboost/app_widget/strings.dart';
import 'package:web_cashboost/functions/formatters.dart';
import 'package:web_cashboost/models/venda_model.dart';
import 'package:web_cashboost/telas/vendas/vendas_bloc.dart';
import 'package:web_cashboost/telas/vendas/vendas_event.dart';
import 'package:web_cashboost/telas/vendas/vendas_state.dart';
import 'package:web_cashboost/widgets/container.dart';
import 'package:web_cashboost/widgets/dialog.dart';
import 'package:web_cashboost/widgets/elevated_button.dart';
import 'package:web_cashboost/widgets/erro.dart';
import 'package:web_cashboost/widgets/form_field.dart';
import 'package:web_cashboost/widgets/loading.dart';
import 'package:web_cashboost/widgets/tables.dart';
import 'package:web_cashboost/widgets/util.dart';

class VendasScreen extends StatefulWidget {
  const VendasScreen({super.key});

  @override
  State<VendasScreen> createState() => _VendasScreenState();
}

class _VendasScreenState extends State<VendasScreen> {
  TextEditingController controllerMansagem = TextEditingController();
  VendaBloc bloc = VendaBloc();

  Future<void> _load() async {
    bloc.add(VendaLoadEvent());
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  Color _aprovadoColor(VendaModel model) {
    switch (model.vendaAprovado) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _aprovadoValue(VendaModel model) {
    switch (model.vendaAprovado) {
      case 1:
        return Strings.aprovado.toUpperCase();
      case 2:
        return Strings.recusado.toUpperCase();
      default:
        return "-";
    }
  }

  void _onTapEnviarMensagem(VendaModel vendaModel) {
    bloc.add(VendaRecusarEvent(vendaModel.idVenda!, vendaModel.idUsuario!, 2, controllerMansagem.text));
    Navigator.pop(context);
  }

  void _onTapRecusar(VendaModel vendaModel) {
    Navigator.pop(context);
    _showDialogRecusar(vendaModel);
  }

  void _onTapAceitar(VendaModel vendaModel) {
    bloc.add(VendaAceitarEvent(vendaModel.idVenda!, vendaModel.idUsuario!, 1));
    Navigator.pop(context);
  }

  void _showDialogRecusar(VendaModel vendaModel) {
    showPopup(
      context,
      height: 150,
      children: [
        formFieldPadrao(context, Strings.digiteOMotivo, controller: controllerMansagem),
        elevatedButtonText(
          Strings.enviarMensagem.toUpperCase(),
          width: 230,
          color: Colors.red,
          textColor: Colors.white,
          function: () => _onTapEnviarMensagem(vendaModel),
        ),
      ],
    );
  }

  void _showDialogAceitar(VendaModel vendaModel) {
    showPopup(
      context,
      children: [
        container(
          backgroundColor: Colors.grey.shade300,
          radius: BorderRadius.circular(20),
          padding: const EdgeInsets.all(10),
          child: text(Strings.confirmacaoAprovarRecusarVenda, fontSize: 15, textAlign: TextAlign.center),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButtonText(
              Strings.recusar.toUpperCase(),
              width: 230,
              color: Colors.red,
              textColor: Colors.white,
              function: () => _onTapRecusar(vendaModel),
            ),
            elevatedButtonText(
              Strings.aprovar.toUpperCase(),
              color: AppColor.primaryColor,
              textColor: Colors.white,
              width: 230,
              function: () => _onTapAceitar(vendaModel),
            ),
          ],
        ),
      ],
    );
  }

  List<DataRow> getVendasRows(List<VendaModel> vendas) {
    return vendas.reversed.map((model) {
      return DataRow(
        cells: [
          DataCell(textSelectable(model.nomeUsuario ?? '')),
          DataCell(textSelectable(model.vendaNfeCode ?? '')),
          DataCell(textSelectable(formatarData(model.dataEnvio ?? ''))),
          DataCell(textSelectable(model.ponteira!)),
          DataCell(textSelectable(_aprovadoValue(model), bold: true, color: _aprovadoColor(model))),
          model.vendaAprovado != 0 ? DataCell(textSelectable("-")) : DataCell(elevatedButtonTable(Strings.aprovar, () => _showDialogAceitar(model))),
        ],
      );
    }).toList();
  }

  Widget _body(VendaState state) {
    return getTableDefault(
      context: context,
      titulo: Strings.vendas,
      reload: () => _load(),
      colunas: [
        DataColumn(label: text(Strings.vendedor, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.codigoNFE, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.dataDeEnvio, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.ponteira, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.aprovado, bold: true, color: Colors.white)),
        DataColumn(label: text('', bold: true, color: Colors.white)),
      ],
      linhas: getVendasRows(state.vendas),
    );
  }

  Widget _bodyBuilder() {
    return BlocConsumer<VendaBloc, VendaState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case VendaLoadingState:
            return loading();
          case VendaErrorState:
            return erro(state.errorModel, function: () => _load());
          default:
            return _body(state);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _bodyBuilder();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
