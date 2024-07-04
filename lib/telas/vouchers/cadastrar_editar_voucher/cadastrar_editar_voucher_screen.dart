import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:web_cashboost/app_widget/app_consts/app_colors.dart';
import 'package:web_cashboost/app_widget/app_consts/app_endpoints.dart';
import 'package:web_cashboost/app_widget/app_consts/app_font_sizes.dart';
import 'package:web_cashboost/app_widget/app_consts/app_form_formatter.dart';
import 'package:web_cashboost/app_widget/app_consts/app_radius.dart';
import 'package:web_cashboost/app_widget/app_consts/app_spacing.dart';
import 'package:web_cashboost/app_widget/app_consts/app_strings.dart';
import 'package:web_cashboost/app_widget/snack_bar/snack_bar.dart';
import 'package:web_cashboost/models/voucher_model.dart';
import 'package:web_cashboost/telas/vouchers/voucher_bloc.dart';
import 'package:web_cashboost/telas/vouchers/voucher_event.dart';
import 'package:web_cashboost/telas/vouchers/voucher_state.dart';
import 'package:web_cashboost/widgets/container.dart';
import 'package:web_cashboost/widgets/elevated_button.dart';
import 'package:web_cashboost/widgets/form_field.dart';
import 'package:web_cashboost/widgets/loading.dart';
import 'package:web_cashboost/widgets/scaffold.dart';
import 'package:web_cashboost/widgets/sized_box.dart';
import 'package:web_cashboost/widgets/util.dart';

class CadastrarEditarVoucherScreen extends StatefulWidget {
  final VoucherModel? voucherModel;

  const CadastrarEditarVoucherScreen({super.key, required this.voucherModel});

  @override
  State<CadastrarEditarVoucherScreen> createState() => _CadastrarEditarVoucherScreenState();
}

class _CadastrarEditarVoucherScreenState extends State<CadastrarEditarVoucherScreen> {
  VoucherBloc bloc = VoucherBloc();

  TextEditingController titulo = TextEditingController();
  TextEditingController descricao = TextEditingController();
  TextEditingController dataInicio = TextEditingController();
  TextEditingController dataFim = TextEditingController();
  TextEditingController desconto = TextEditingController();
  TextEditingController pontos = TextEditingController();

  DateFormat dataFormatada = DateFormat('dd/MM/yyyy HH:mm');

  File imageFile = File("");

  @override
  void initState() {
    dataInicio.text = dataFormatada.format(DateTime.now());
    dataFim.text = dataFormatada.format(DateTime.now().add(const Duration(days: 30)));

    if (widget.voucherModel != null) {
      titulo.text = widget.voucherModel!.titulo!;
      descricao.text = widget.voucherModel!.descricao!;
      dataInicio.text = widget.voucherModel!.dataComeco!;
      dataFim.text = widget.voucherModel!.dataFinal!;
      pontos.text = widget.voucherModel!.pontosCheio.toString();

      if (widget.voucherModel!.desconto != 0) {
        desconto.text = widget.voucherModel!.desconto.toString();
      }
    }

    super.initState();
  }

  void _onChangeState(VoucherState state) {
    if (state is VoucherErrorState) showSnackbarError(context, message: state.errorModel.mensagem);
  }

  void pickImage() async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => imageFile = File(image.path));
      }
    } catch (e) {
      showSnackbarError(context, message: AppStrings.naoEPossivelAbrirAGaleria);
    }
  }

  void _checkForms() {
    if (titulo.text.isNotEmpty) {
      if (descricao.text.isNotEmpty) {
        if (dataInicio.text.isNotEmpty) {
          if (dataFim.text.isNotEmpty) {
            if (pontos.text.isNotEmpty) {
              VoucherModel voucherModel = VoucherModel();

              if (widget.voucherModel == null) {
                voucherModel = VoucherModel(
                  titulo: titulo.text,
                  descricao: descricao.text,
                  dataComeco: dataInicio.text,
                  dataFinal: dataFim.text,
                  pontosCheio: int.parse(pontos.text),
                );
              } else {
                voucherModel = VoucherModel(
                  id: widget.voucherModel!.id,
                  titulo: titulo.text,
                  descricao: descricao.text,
                  dataComeco: dataInicio.text,
                  dataFinal: dataFim.text,
                  pontosCheio: int.parse(pontos.text),
                  desconto: int.parse(desconto.text),
                );
              }

              Navigator.pop(context);
              return bloc.add(VoucherSaveEvent(voucherModel, imageFile));
            }

            return showSnackbarWarning(context, message: AppStrings.preenchaTodosOsCampos);
          }
          return showSnackbarWarning(context, message: AppStrings.preenchaTodosOsCampos);
        }
        return showSnackbarWarning(context, message: AppStrings.preenchaTodosOsCampos);
      }
      return showSnackbarWarning(context, message: AppStrings.preenchaTodosOsCampos);
    }
    return showSnackbarWarning(context, message: AppStrings.preenchaTodosOsCampos);
  }

  Widget _body() {
    double metadeDaMetadeTela = MediaQuery.of(context).size.width / 4;
    double inteiraTela = MediaQuery.of(context).size.width / 4 + MediaQuery.of(context).size.width / 4 + 10;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            appSizedBoxHeight(AppSpacing.normal),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.voucherModel != null
                    ? GestureDetector(
                        onTap: () => pickImage(),
                        child: imageFile.path.isEmpty
                            ? container(
                                height: 150,
                                width: 150,
                                radius: BorderRadius.circular(AppRadius.medium),
                                backgroundColor: AppColors.white,
                                image: NetworkImage(AppEndpoints.endpointImageVoucher(widget.voucherModel!.id!)),
                              )
                            : container(
                                height: 150,
                                width: 150,
                                radius: BorderRadius.circular(AppRadius.medium),
                                backgroundColor: AppColors.white,
                                image: NetworkImage(imageFile.path),
                              ),
                      )
                    : Container(),
                appSizedBoxHeight(AppSpacing.normal),
                container(
                  width: widget.voucherModel != null ? inteiraTela - 150 : inteiraTela,
                  height: 150,
                  backgroundColor: AppColors.grey300,
                  radius: BorderRadius.circular(AppRadius.medium),
                  padding: EdgeInsets.all(AppSpacing.normal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text("Info:".toUpperCase(), color: AppColors.primaryColor, bold: true, fontSize: AppFontSizes.medium),
                      appSizedBoxHeight(AppSpacing.normal),
                      text(AppStrings.mensagemCadastroVoucher, color: AppColors.grey800),
                    ],
                  ),
                ),
              ],
            ),
            appSizedBoxHeight(AppSpacing.normal),
            appFormFieldPadrao(context, AppStrings.digiteOTituloDoVoucher, width: inteiraTela, controller: titulo),
            appSizedBoxHeight(AppSpacing.normal),
            appFormFieldPadrao(context, AppStrings.digiteADescricao, width: inteiraTela, controller: descricao),
            appSizedBoxHeight(AppSpacing.normal),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                appFormFieldPadrao(context, AppStrings.digiteADataInicial, width: metadeDaMetadeTela, textInputFormatter: AppFormFormatters.dataFormatter, controller: dataInicio),
                appSizedBoxHeight(AppSpacing.normal),
                appFormFieldPadrao(context, AppStrings.digiteADataFinal, width: metadeDaMetadeTela, textInputFormatter: AppFormFormatters.dataFormatter, controller: dataFim),
                appSizedBoxHeight(AppSpacing.normal),
              ],
            ),
            appSizedBoxHeight(AppSpacing.normal),
            appFormFieldPadrao(context, AppStrings.digiteAQuantidadeDePontos, width: inteiraTela, controller: pontos),
            appSizedBoxHeight(AppSpacing.normal),
            widget.voucherModel != null ? appFormFieldPadrao(context, AppStrings.digiteODescontoEmPontos, width: inteiraTela, controller: desconto) : Container(),
            appSizedBoxHeight(AppSpacing.normal),
            elevatedButtonText(
              AppStrings.salvar.toUpperCase(),
              function: () => _checkForms(),
              width: inteiraTela,
              color: AppColors.primaryColor,
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyBuilder() {
    return BlocConsumer<VoucherBloc, VoucherState>(
      bloc: bloc,
      listener: (context, state) => _onChangeState(state),
      builder: (context, state) {
        switch (state.runtimeType) {
          case VoucherLoadingState:
            return loading();
          default:
            return _body();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return scaffold(
      title: AppStrings.cadastrarOuEditarVoucher,
      body: _bodyBuilder(),
    );
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
