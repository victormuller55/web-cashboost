import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_cashboost/app_widget/endpoints.dart';
import 'package:web_cashboost/app_widget/strings.dart';
import 'package:web_cashboost/functions/formatters.dart';
import 'package:web_cashboost/models/concessionaria_model.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_bloc.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_event.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_state.dart';
import 'package:web_cashboost/widgets/container.dart';
import 'package:web_cashboost/widgets/erro.dart';
import 'package:web_cashboost/widgets/loading.dart';
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
    bloc.add(VendedoresLoadEvent(idConcessionaria: currentValue?.idConcessionaria ?? 0));
  }

  OutlineInputBorder _decoration() {
    return OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 0.5), borderRadius: BorderRadius.circular(40));
  }

  DropdownMenuItem<ConcessionariaModel> dropdownValues(ConcessionariaModel concessionariaModel) {
    return DropdownMenuItem<ConcessionariaModel>(
      value: concessionariaModel,
      child: text("${concessionariaModel.nomeConcessionaria} (${concessionariaModel.marcaConcessionaria})"),
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
      titulo: Strings.vendedor,
      reload: _load,
      children: [
        SizedBox(
          height: 40,
          width: 240,
          child: DropdownButtonFormField<ConcessionariaModel>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              border: _decoration(),
              enabledBorder: _decoration(),
              disabledBorder: _decoration(),
              focusedBorder: _decoration(),
              hintText: Strings.escolhaUmaOpcao,
              hintStyle: const TextStyle(fontFamily: 'lato', fontSize: 13, color: Colors.grey),
            ),
            value: currentValue,
            onChanged: (ConcessionariaModel? valueChoosed) => _onChangeDropdown(valueChoosed, currentValue),
            items: itens,
          ),
        ),
      ],
      colunas: [
        DataColumn(label: text(Strings.foto, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.dataDeCadastro, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.nome, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.cpf, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.celular, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.email, bold: true, color: Colors.white)),
        DataColumn(label: text(Strings.concessionaria, bold: true, color: Colors.white)),
      ],
      linhas: state.usuarioModel.reversed.map((model) {
        return DataRow(
          cells: [
            DataCell(imageTable(Endpoint.endpointImageUsuario(model.idUsuario!))),
            DataCell(textSelectable(formatarData(model.dataUsuario ?? "-"))),
            DataCell(textSelectable(model.nomeUsuario ?? "-")),
            DataCell(textSelectable(formatarCPF(model.cpfUsuario ?? "-"))),
            DataCell(textSelectable(model.celularUsuario ?? "-")),
            DataCell(textSelectable(model.emailUsuario ?? "-")),
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
    return _bodyBuilder();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }
}
