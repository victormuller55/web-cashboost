import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_cashboost/app_widget/app_consts/app_colors.dart';
import 'package:web_cashboost/app_widget/app_consts/app_endpoints.dart';
import 'package:web_cashboost/app_widget/app_consts/app_font_sizes.dart';
import 'package:web_cashboost/app_widget/app_consts/app_radius.dart';
import 'package:web_cashboost/app_widget/app_consts/app_strings.dart';
import 'package:web_cashboost/functions/formatters.dart';
import 'package:web_cashboost/models/concessionaria_model.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_bloc.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_event.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_state.dart';
import 'package:web_cashboost/widgets/container.dart';
import 'package:web_cashboost/widgets/drawer.dart';
import 'package:web_cashboost/widgets/erro.dart';
import 'package:web_cashboost/widgets/loading.dart';
import 'package:web_cashboost/widgets/scaffold.dart';
import 'package:web_cashboost/widgets/tables.dart';
import 'package:web_cashboost/widgets/util.dart';

class VendedoresScreen extends StatefulWidget {
  const VendedoresScreen({super.key});

  @override
  State<VendedoresScreen> createState() => _VendedoresScreenState();
}

class _VendedoresScreenState extends State<VendedoresScreen> {
  VendedoresBloc bloc = VendedoresBloc();

  @override
  void initState() {
    _load();
    super.initState();
  }

  Future<void> _load() async {
    bloc.add(VendedoresLoadEvent(idConcessionaria: 0));
  }

  void _onChangeDropdown(ConcessionariaModel? choosedValue, ConcessionariaModel? currentValue) {
    setState(() => currentValue = choosedValue!);
    bloc.add(VendedoresLoadEvent(idConcessionaria: currentValue?.id ?? 0));
  }

  OutlineInputBorder _decoration() {
    return OutlineInputBorder(borderSide: BorderSide(color: AppColors.transparent, width: 0.5), borderRadius: BorderRadius.circular(AppRadius.normal));
  }

  DropdownMenuItem<ConcessionariaModel> dropdownValues(ConcessionariaModel concessionariaModel) {
    return DropdownMenuItem<ConcessionariaModel>(
      value: concessionariaModel,
      child: text("${concessionariaModel.nome} (${concessionariaModel.marca})"),
    );
  }

  ConcessionariaModel? currentValue;

  Widget _body(VendedoresState state) {
    List<DropdownMenuItem<ConcessionariaModel>> itens = [];

    for (ConcessionariaModel concessionariaModel in state.concessionariaList) {
      itens.add(dropdownValues(concessionariaModel));
    }

    return getTableDefault(
      context: context,
      titulo: AppStrings.vendedor,
      reload: _load,
      children: [
        // SizedBox(
        //   height: 40,
        //   width: MediaQuery.of(context).size.width / 3,
        //   child: DropdownButtonFormField<ConcessionariaModel>(
        //     decoration: InputDecoration(
        //       filled: true,
        //       isDense: true,
        //       fillColor: AppColors.white,
        //       border: _decoration(),
        //       enabledBorder: _decoration(),
        //       disabledBorder: _decoration(),
        //       focusedBorder: _decoration(),
        //       hintText: AppStrings.escolhaUmaOpcao,
        //       hintStyle: TextStyle(fontFamily: 'lato', fontSize: AppFontSizes.normal, color: AppColors.grey),
        //     ),
        //     value: currentValue,
        //     onChanged: (ConcessionariaModel? valueChoosed) => _onChangeDropdown(valueChoosed, currentValue),
        //     items: itens,
        //   ),
        // ),
      ],
      colunas: [
        DataColumn(label: text(AppStrings.foto, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.nome, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.cpf, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.celular, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.email, bold: true, color: AppColors.white)),
        DataColumn(label: text(AppStrings.concessionaria, bold: true, color: AppColors.white)),
      ],
      linhas: state.usuarioModel.reversed.map((model) {
        return DataRow(
          cells: [
            DataCell(imageTable(AppEndpoints.endpointImageVendedor(model.id!))),
            DataCell(textSelectable(model.nome ?? "-")),
            DataCell(textSelectable(formatarCPF(model.cpf ?? "-"))),
            DataCell(textSelectable(model.celular ?? "-")),
            DataCell(textSelectable(model.email ?? "-")),
            DataCell(textSelectable(model.nomeConcessionaria ?? "-")),
          ],
        );
      }).toList(),
    );
  }

  Widget _bodyBuilder() {
    return BlocConsumer<VendedoresBloc, VendedoresState>(
      bloc: bloc,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case VendedoresLoadingState:
            return loading();
          case VendedoresSuccessState:
            return _body(state);
          case VendedoresErrorState:
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: text("Vendedores", fontSize: AppFontSizes.normal),
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
