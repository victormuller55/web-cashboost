import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_cashboost/app_widget/app_consts/app_colors.dart';
import 'package:web_cashboost/app_widget/app_consts/app_endpoints.dart';
import 'package:web_cashboost/app_widget/app_consts/app_font_sizes.dart';
import 'package:web_cashboost/app_widget/app_consts/app_radius.dart';
import 'package:web_cashboost/app_widget/app_consts/app_spacing.dart';
import 'package:web_cashboost/app_widget/app_consts/app_strings.dart';
import 'package:web_cashboost/functions/navigation.dart';
import 'package:web_cashboost/models/voucher_model.dart';
import 'package:web_cashboost/telas/vouchers/cadastrar_editar_voucher/cadastrar_editar_voucher_screen.dart';
import 'package:web_cashboost/telas/vouchers/voucher_bloc.dart';
import 'package:web_cashboost/telas/vouchers/voucher_event.dart';
import 'package:web_cashboost/telas/vouchers/voucher_state.dart';
import 'package:web_cashboost/widgets/container.dart';
import 'package:web_cashboost/widgets/dialog.dart';
import 'package:web_cashboost/widgets/drawer.dart';
import 'package:web_cashboost/widgets/elevated_button.dart';
import 'package:web_cashboost/widgets/erro.dart';
import 'package:web_cashboost/widgets/loading.dart';
import 'package:web_cashboost/widgets/sized_box.dart';
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
      height: 180,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            appSizedBoxHeight(AppSpacing.normal),
            text(AppStrings.voceRealmenteDesejaApagarOVoucher, fontSize: AppFontSizes.normal),
            appSizedBoxHeight(AppSpacing.medium),
            container(
              radius: BorderRadius.circular(AppRadius.normal),
              backgroundColor: AppColors.grey300,
              padding: EdgeInsets.all(AppSpacing.normal),
              child: text(model.titulo!, fontSize: AppFontSizes.big, bold: true, color: AppColors.primaryColor),
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            elevatedButtonText(
              AppStrings.cancelar.toUpperCase(),
              function: () => Navigator.pop(context),
              width: 230,
              height: 40,
              color: AppColors.primaryColor,
              borderRadius: AppRadius.normal,
              textColor: AppColors.white,
            ),
            elevatedButtonText(
              AppStrings.apagar.toUpperCase(),
              function: () => bloc.add(VoucherDeleteEvent(model.id!)),
              color: AppColors.red,
              textColor: AppColors.white,
              borderRadius: AppRadius.normal,
              width: 230,
              height: 40,
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
          DataCell(imageTable(AppEndpoints.endpointImageVoucher(model.id!))),
          DataCell(textSelectable(model.titulo!)),
          DataCell(textSelectable(model.dataComeco!)),
          DataCell(textSelectable(model.dataFinal!)),
          DataCell(textSelectable('${model.pontosCheio} Pontos')),
          DataCell(textSelectable(model.desconto != 0 ? "${model.pontos} Pontos" : "-")),
          DataCell(elevatedButtonTable(AppStrings.apagar, () => showDialogDelete(model), color: AppColors.red)),
          DataCell(elevatedButtonTable(AppStrings.editar, () => open(context, screen: CadastrarEditarVoucherScreen(voucherModel: model)))),
        ],
      );
    }).toList();
  }

  Widget _body(VoucherState state) {
    return getTableDefault(
      context: context,
      titulo: AppStrings.vouchers,
      reload: _load,
      children: [
        elevatedButtonText(
          AppStrings.criarVoucher,
          height: 40,
          width: 150,
          borderRadius: AppRadius.normal,
          color: AppColors.green700,
          textColor: AppColors.white,
          function: () => open(context, screen: const CadastrarEditarVoucherScreen(voucherModel: null)),
        )
      ],
      colunas: [
        DataColumn(label: text(AppStrings.imagem, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.titulo, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.dataInicial, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.dataFinal, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.pontosCheios, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.pontosPromocao, bold: true, color: AppColors.white)),
        DataColumn(label: text('', bold: true, color: AppColors.white)),
        DataColumn(label: text('', bold: true, color: AppColors.white)),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: text("Solicitação de PIX/Vouchers", fontSize: AppFontSizes.normal),
      ),
      backgroundColor: Colors.white,
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
