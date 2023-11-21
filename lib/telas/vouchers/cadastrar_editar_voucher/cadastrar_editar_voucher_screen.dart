import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:web_cashboost/app_widget/color/colors.dart';
import 'package:web_cashboost/app_widget/endpoints.dart';
import 'package:web_cashboost/app_widget/form_field_formatters/form_field_formatter.dart';
import 'package:web_cashboost/app_widget/snack_bar/snack_bar.dart';
import 'package:web_cashboost/app_widget/strings.dart';
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

  TextEditingController tituloController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataInicioController = TextEditingController();
  TextEditingController dataFimController = TextEditingController();
  TextEditingController descontoController = TextEditingController();
  TextEditingController pontosController = TextEditingController();

  DateFormat dataFormatada = DateFormat('dd/MM/yyyy HH:mm');

  File imageFile = File("");

  @override
  void initState() {
    dataInicioController.text = dataFormatada.format(DateTime.now());
    dataFimController.text = dataFormatada.format(DateTime.now().add(const Duration(days: 30)));

    if (widget.voucherModel != null) {
      tituloController.text = widget.voucherModel!.titulo!;
      descricaoController.text = widget.voucherModel!.descricao!;
      dataInicioController.text = widget.voucherModel!.dataComeco!;
      dataFimController.text = widget.voucherModel!.dataFinal!;
      if (widget.voucherModel!.desconto != 0) {
        descontoController.text = widget.voucherModel!.desconto.toString();
      }
      pontosController.text = widget.voucherModel!.pontosCheio.toString();
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
      if (kDebugMode) {
        print(e);
      }
      showSnackbarError(context, message: Strings.naoEPossivelAbrirAGaleria);
    }
  }

  void _checkForms() {
    if (tituloController.text.isNotEmpty) {
      if (descricaoController.text.isNotEmpty) {
        if (dataInicioController.text.isNotEmpty) {
          if (dataFimController.text.isNotEmpty) {
            if (pontosController.text.isNotEmpty) {
              VoucherModel voucherModel = VoucherModel();

              if (widget.voucherModel == null) {
                voucherModel = VoucherModel(
                  titulo: tituloController.text,
                  descricao: descricaoController.text,
                  dataComeco: dataInicioController.text,
                  dataFinal: dataFimController.text,
                  pontosCheio: int.parse(pontosController.text),
                );
              } else {
                voucherModel = VoucherModel(
                  id: widget.voucherModel!.id,
                  titulo: tituloController.text,
                  descricao: descricaoController.text,
                  dataComeco: dataInicioController.text,
                  dataFinal: dataFimController.text,
                  pontosCheio: int.parse(pontosController.text),
                  desconto: int.parse(descontoController.text),
                );
              }

              Navigator.pop(context);
              return bloc.add(VoucherSaveEvent(voucherModel, imageFile));
            }

            return showSnackbarWarning(context, message: Strings.preenchaTodosOsCampos);
          }
          return showSnackbarWarning(context, message: Strings.preenchaTodosOsCampos);
        }
        return showSnackbarWarning(context, message: Strings.preenchaTodosOsCampos);
      }
      return showSnackbarWarning(context, message: Strings.preenchaTodosOsCampos);
    }
    return showSnackbarWarning(context, message: Strings.preenchaTodosOsCampos);
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
            sizedBoxVertical(10),
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
                                radius: BorderRadius.circular(20),
                                backgroundColor: Colors.white,
                                image: NetworkImage(Endpoint.endpointImageVoucher(widget.voucherModel!.id!)),
                              )
                            : container(
                                height: 150,
                                width: 150,
                                radius: BorderRadius.circular(20),
                                backgroundColor: Colors.white,
                                image: NetworkImage(imageFile.path),
                              ),
                      )
                    : Container(),
                const SizedBox(width: 10),
                container(
                  width: widget.voucherModel != null ? inteiraTela - 150 : inteiraTela,
                  height: 150,
                  backgroundColor: Colors.grey.shade300,
                  radius: BorderRadius.circular(20),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text("Info:".toUpperCase(), color: AppColor.primaryColor, bold: true, fontSize: 20),
                      sizedBoxVertical(10),
                      text(Strings.mensagemCadastroVoucher, color: Colors.grey.shade800),
                    ],
                  ),
                ),
              ],
            ),
            sizedBoxVertical(10),
            formFieldPadrao(context, Strings.digiteOTituloDoVoucher, width: inteiraTela, controller: tituloController),
            sizedBoxVertical(10),
            formFieldPadrao(context, Strings.digiteADescricao, width: inteiraTela, controller: descricaoController),
            sizedBoxVertical(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                formFieldPadrao(context, Strings.digiteADataInicial, width: metadeDaMetadeTela, textInputFormatter: FormFieldFormatter.dataHoraFormatter, controller: dataInicioController),
                const SizedBox(width: 10),
                formFieldPadrao(context, Strings.digiteADataFinal, width: metadeDaMetadeTela, textInputFormatter: FormFieldFormatter.dataHoraFormatter, controller: dataFimController),
                sizedBoxVertical(10),
              ],
            ),
            sizedBoxVertical(10),
            formFieldPadrao(context, Strings.digiteAQuantidadeDePontos, width: inteiraTela, controller: pontosController),
            sizedBoxVertical(10),
            widget.voucherModel != null ? formFieldPadrao(context, Strings.digiteODescontoEmPontos, width: inteiraTela, controller: descontoController) : Container(),
            sizedBoxVertical(10),
            elevatedButtonText(
              Strings.salvar.toUpperCase(),
              function: () => _checkForms(),
              width: inteiraTela,
              color: AppColor.primaryColor,
              textColor: Colors.white,
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
      title: Strings.cadastrarOuEditarVoucher,
      body: _bodyBuilder(),
    );
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
