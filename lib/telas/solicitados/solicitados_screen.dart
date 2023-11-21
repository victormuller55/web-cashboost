import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_cashboost/app_widget/color/colors.dart';
import 'package:web_cashboost/app_widget/strings.dart';
import 'package:web_cashboost/functions/formatters.dart';
import 'package:web_cashboost/models/historico_model.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_bloc.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_event.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_state.dart';
import 'package:web_cashboost/widgets/container.dart';
import 'package:web_cashboost/widgets/dialog.dart';
import 'package:web_cashboost/widgets/elevated_button.dart';
import 'package:web_cashboost/widgets/erro.dart';
import 'package:web_cashboost/widgets/loading.dart';
import 'package:web_cashboost/widgets/tables.dart';
import 'package:web_cashboost/widgets/util.dart';


class SolicitadosScreen extends StatefulWidget {
  const SolicitadosScreen({super.key});

  @override
  State<SolicitadosScreen> createState() => _SolicitadosScreenState();
}

class _SolicitadosScreenState extends State<SolicitadosScreen> {
  SolicitadosBloc bloc = SolicitadosBloc();

  Future<void> _load() async {
    bloc.add(SolicitadosLoadEvent());
  }

  @override
  void initState() {
    bloc.add(SolicitadosLoadEvent());
    super.initState();
  }

  Color _enviadoColor(HistoricoModel model) {
    if (model.enviado!) {
      return Colors.green;
    }

    return Colors.grey;
  }

  String _enviadoValue(HistoricoModel model) {
    if (model.enviado!) {
      return Strings.enviado.toUpperCase();
    }

    return Strings.naoEnviado.toUpperCase();
  }

  void _onMarcarComoEnviado(HistoricoModel historicoModel) {
    bloc.add(SolicitadosEnviadoEvent(historicoModel.idHistorico!));
    Navigator.pop(context);
  }

  void _showDialogMarcarComoEnviado(HistoricoModel historicoModel) {
    showPopup(
      context,
      height: 150,
      children: [
        container(
          backgroundColor: Colors.grey.shade300,
          radius: BorderRadius.circular(20),
          padding: const EdgeInsets.all(10),
          child: text(Strings.confirmacaoMarcarComoFeito, fontSize: 15, textAlign: TextAlign.center),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButtonText(
              Strings.marcarComoEnviado.toUpperCase(),
              width: 230,
              color: Colors.green,
              textColor: Colors.white,
              function: () => _onMarcarComoEnviado(historicoModel),
            ),
            elevatedButtonText(
              Strings.cancelar.toUpperCase(),
              color: AppColor.primaryColor,
              textColor: Colors.white,
              width: 230,
              function: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }

  List<DataRow> getVendasRows(List<HistoricoModel> vendas) {
    return vendas.reversed.map((model) {
      return DataRow(
        cells: [
          DataCell(textSelectable(model.nomeUsuario ?? '')),
          DataCell(textSelectable(formatarData(model.dataPedido!))),
          DataCell(textSelectable(model.tituloVoucher.toString())),
          DataCell(textSelectable(model.valor.toString())),
          DataCell(textSelectable(_enviadoValue(model), bold: true, color: _enviadoColor(model))),
          DataCell(model.enviado! ? textSelectable("-") : elevatedButtonTable(Strings.enviado, () => _showDialogMarcarComoEnviado(model))),
        ],
      );
    }).toList();
  }

  Widget _body(SolicitadosState state) {
    return getTableDefault(
      context: context,
      titulo: Strings.pixVoucher,
      reload: () => _load(),
      colunas: [
        DataColumn(label: text(Strings.vendedor, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.dataDoPedido, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.voucher, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.valorQuantPontos, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.enviado, bold: true, color: Colors.white)),
        DataColumn(label: text('', bold: true, color: Colors.white)),
      ],
      linhas: getVendasRows(state.solicitacoes),
    );
  }

  Widget _bodyBuilder() {
    return BlocConsumer<SolicitadosBloc, SolicitadosState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case SolicitadosLoadingState:
            return loading();
          case SolicitadosErrorState:
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
