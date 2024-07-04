import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_cashboost/app_widget/app_consts/app_colors.dart';
import 'package:web_cashboost/app_widget/app_consts/app_font_sizes.dart';
import 'package:web_cashboost/app_widget/app_consts/app_radius.dart';
import 'package:web_cashboost/app_widget/app_consts/app_spacing.dart';
import 'package:web_cashboost/app_widget/app_consts/app_strings.dart';
import 'package:web_cashboost/functions/formatters.dart';
import 'package:web_cashboost/models/historico_model.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_bloc.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_event.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_state.dart';
import 'package:web_cashboost/widgets/container.dart';
import 'package:web_cashboost/widgets/dialog.dart';
import 'package:web_cashboost/widgets/drawer.dart';
import 'package:web_cashboost/widgets/elevated_button.dart';
import 'package:web_cashboost/widgets/erro.dart';
import 'package:web_cashboost/widgets/loading.dart';
import 'package:web_cashboost/widgets/sized_box.dart';
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
      return AppColors.green;
    }

    return AppColors.grey;
  }

  String _enviadoValue(HistoricoModel model) {
    if (model.enviado!) {
      return AppStrings.enviado.toUpperCase();
    }

    return AppStrings.naoEnviado.toUpperCase();
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
          backgroundColor: AppColors.grey300,
          radius: BorderRadius.circular(AppRadius.normal),
          padding: EdgeInsets.all(AppSpacing.normal),
          child: text(AppStrings.confirmacaoMarcarComoFeito, fontSize: AppFontSizes.normal, textAlign: TextAlign.center),
        ),
        appSizedBoxHeight(AppSpacing.normal),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButtonText(
              AppStrings.marcarComoEnviado.toUpperCase(),
              color: AppColors.green,
              textColor: AppColors.white,
              borderRadius: AppRadius.normal,
              width: 230,
              height: 40,
              function: () => _onMarcarComoEnviado(historicoModel),
            ),
            elevatedButtonText(
              AppStrings.cancelar.toUpperCase(),
              color: AppColors.primaryColor,
              textColor: AppColors.white,
              borderRadius: AppRadius.normal,
              width: 230,
              height: 40,
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
          DataCell(textSelectable(model.titulo.toString())),
          DataCell(textSelectable(model.valor.toString())),
          DataCell(textSelectable(_enviadoValue(model), bold: true, color: _enviadoColor(model))),
          DataCell(model.enviado! ? textSelectable("-") : elevatedButtonTable(AppStrings.enviado, () => _showDialogMarcarComoEnviado(model))),
        ],
      );
    }).toList();
  }

  Widget _body(SolicitadosState state) {
    return getTableDefault(
      context: context,
      titulo: AppStrings.pixVoucher,
      reload: () => _load(),
      colunas: [
        DataColumn(label: text(AppStrings.vendedor, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.dataDoPedido, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.voucher, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.valorQuantPontos, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.enviado, bold: true, color: AppColors.white)),
        DataColumn(label: text('', bold: true, color: AppColors.white)),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: text("Voucher/PIX Solicitados", fontSize: AppFontSizes.normal),
      ),
      drawer: appDrawer(),
      body: _bodyBuilder(),
    );
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
