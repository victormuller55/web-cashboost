import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_cashboost/app_widget/app_consts/app_colors.dart';
import 'package:web_cashboost/app_widget/app_consts/app_font_sizes.dart';
import 'package:web_cashboost/app_widget/app_consts/app_radius.dart';
import 'package:web_cashboost/app_widget/app_consts/app_spacing.dart';
import 'package:web_cashboost/app_widget/app_consts/app_strings.dart';
import 'package:web_cashboost/functions/formatters.dart';
import 'package:web_cashboost/models/venda_model.dart';
import 'package:web_cashboost/telas/vendas/vendas_bloc.dart';
import 'package:web_cashboost/telas/vendas/vendas_event.dart';
import 'package:web_cashboost/telas/vendas/vendas_state.dart';
import 'package:web_cashboost/widgets/container.dart';
import 'package:web_cashboost/widgets/dialog.dart';
import 'package:web_cashboost/widgets/drawer.dart';
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
  
  TextEditingController mensagem = TextEditingController();
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
        return AppColors.green;
      case 2:
        return AppColors.red;
      default:
        return AppColors.grey;
    }
  }

  String _aprovadoValue(VendaModel model) {
    switch (model.vendaAprovado) {
      case 1:
        return AppStrings.aprovado.toUpperCase();
      case 2:
        return AppStrings.recusado.toUpperCase();
      default:
        return "-";
    }
  }

  void _onTapEnviarMensagem(VendaModel vendaModel) {
    bloc.add(VendaRecusarEvent(vendaModel.idVenda!, mensagem.text));
    Navigator.pop(context);
  }

  void _onTapRecusar(VendaModel vendaModel) {
    Navigator.pop(context);
    _showDialogRecusar(vendaModel);
  }

  void _onTapAceitar(VendaModel vendaModel) {
    bloc.add(VendaAceitarEvent(vendaModel.idVenda!));
    Navigator.pop(context);
  }

  void _showDialogRecusar(VendaModel vendaModel) {
    showPopup(
      context,
      height: 160,
      children: [
        appFormFieldPadrao(context, AppStrings.digiteOMotivo, controller: mensagem, radius: AppRadius.normal, background: AppColors.grey300),
        elevatedButtonText(
          AppStrings.enviarMensagem.toUpperCase(),
          color: AppColors.red,
          width: MediaQuery.of(context).size.width,
          textColor: AppColors.white,
          height: 40,
          borderRadius: AppRadius.normal,
          function: () => _onTapEnviarMensagem(vendaModel),
        ),
      ],
    );
  }

  void _showDialogAceitar(VendaModel vendaModel) {
    showPopup(
      context,
      height: 150,
      children: [
        container(
          width: MediaQuery.of(context).size.width,
          backgroundColor: AppColors.grey300,
          radius: BorderRadius.circular(AppRadius.normal),
          padding: EdgeInsets.all(AppSpacing.normal),
          child: text(AppStrings.confirmacaoAprovarRecusarVenda, fontSize: AppFontSizes.normal, textAlign: TextAlign.center),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButtonText(
              AppStrings.recusar.toUpperCase(),
              width: 230,
              height: 40,
              borderRadius: AppRadius.normal,
              textColor: AppColors.white,
              color: AppColors.red,
              function: () => _onTapRecusar(vendaModel),
            ),
            elevatedButtonText(
              AppStrings.aprovar.toUpperCase(),
              width: 230,
              height: 40,
              borderRadius: AppRadius.normal,
              textColor: AppColors.white,
              color: AppColors.green,
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
          DataCell(textSelectable(model.ponteira.toString())),
          DataCell(textSelectable(_aprovadoValue(model), bold: true, color: _aprovadoColor(model))),
          model.vendaAprovado != 0 ? DataCell(textSelectable("-")) : DataCell(elevatedButtonTable(AppStrings.aprovar, () => _showDialogAceitar(model))),
        ],
      );
    }).toList();
  }

  Widget _body(VendaState state) {
    return getTableDefault(
      context: context,
      titulo: AppStrings.vendas,
      reload: () => _load(),
      colunas: [
        DataColumn(label: text(AppStrings.vendedor, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.codigoNFE, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.dataDeEnvio, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.ponteira, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.aprovado, bold: true, color: AppColors.white)),
        DataColumn(label: text('', bold: true, color: AppColors.white)),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: text("Vendas Enviadas", fontSize: AppFontSizes.normal),
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
