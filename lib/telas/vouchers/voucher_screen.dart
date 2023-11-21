import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_cashboost/app_widget/color/colors.dart';
import 'package:web_cashboost/app_widget/endpoints.dart';
import 'package:web_cashboost/app_widget/strings.dart';
import 'package:web_cashboost/functions/navigation.dart';
import 'package:web_cashboost/models/voucher_model.dart';
import 'package:web_cashboost/telas/vouchers/cadastrar_editar_voucher/cadastrar_editar_voucher_screen.dart';
import 'package:web_cashboost/telas/vouchers/voucher_bloc.dart';
import 'package:web_cashboost/telas/vouchers/voucher_event.dart';
import 'package:web_cashboost/telas/vouchers/voucher_state.dart';
import 'package:web_cashboost/widgets/container.dart';
import 'package:web_cashboost/widgets/dialog.dart';
import 'package:web_cashboost/widgets/elevated_button.dart';
import 'package:web_cashboost/widgets/erro.dart';
import 'package:web_cashboost/widgets/loading.dart';
import 'package:web_cashboost/widgets/tables.dart';
import 'package:web_cashboost/widgets/util.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {

  VoucherBloc bloc = VoucherBloc();

  Future<void> _load() async {
    bloc.add(VoucherLoadEvent());
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  void showDialogDelete(VoucherModel model) {
    showPopup(
      context,
      height: 100,
      children: [
        text("${Strings.voceRealmenteDesejaApagarOVoucher}: ${model.titulo}", fontSize: 15),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButtonText(
              Strings.cancelar.toUpperCase(),
              function: () => Navigator.pop(context),
              width: 230,
              color: AppColor.primaryColor,
              textColor: Colors.white,
            ),
            elevatedButtonText(
              Strings.apagar.toUpperCase(),
              function: () => bloc.add(VoucherDeleteEvent(model.id!)),
              color: Colors.red,
              textColor: Colors.white,
              width: 230,
            ),
          ],
        ),
      ],
    );
  }

  List<DataRow> _linhas(VoucherState state) {
    return state.vouchers.reversed.map((model) {
      return DataRow(
        cells: [
          DataCell(imageTable(Endpoint.endpointImageVoucher(model.id!))),
          DataCell(textSelectable(model.titulo!)),
          DataCell(textSelectable(model.dataComeco!)),
          DataCell(textSelectable(model.dataFinal!)),
          DataCell(textSelectable('${model.pontosCheio} Pontos')),
          DataCell(textSelectable(model.desconto != 0 ? "${model.pontos} Pontos" : "-")),
          DataCell(elevatedButtonTable(Strings.apagar, () => showDialogDelete(model), color: Colors.red)),
          DataCell(elevatedButtonTable(Strings.editar, () => open(context, screen: CadastrarEditarVoucherScreen(voucherModel: model)))),
        ],
      );
    }).toList();
  }

  Widget _body(VoucherState state) {
    return getTableDefault(
      context: context,
      titulo: Strings.vouchers,
      reload: _load,
      children: [
        elevatedButtonText(
          Strings.criarVoucher,
          height: 40,
          width: 150,
          color: Colors.green.shade700,
          textColor: Colors.white,
          function: () => open(context, screen: const CadastrarEditarVoucherScreen(voucherModel: null)),
        )
      ],
      colunas: [
        DataColumn(label: text(Strings.imagem, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.titulo, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.dataInicial, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.dataFinal, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.pontosCheios, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.pontosPromocao, bold: true, color: Colors.white)),
        DataColumn(label: text('', bold: true, color: Colors.white)),
        DataColumn(label: text('', bold: true, color: Colors.white)),
      ],
      linhas: _linhas(state),
    );
  }

  Widget _bodyBuilder() {
    return BlocConsumer<VoucherBloc, VoucherState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case VoucherLoadingState:
            return loading();
          case VoucherSuccessState:
            return _body(state);
          case VoucherErrorState:
            return erro(state.errorModel, function: () => _load());
          default:
            return container();
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
