import 'package:flutter/material.dart';
import 'package:web_cashboost/app_widget/color/colors.dart';
import 'package:web_cashboost/functions/navigation.dart';
import 'package:web_cashboost/models/error_model.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_screen.dart';
import 'package:web_cashboost/telas/vendas/vendas_screen.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_screen.dart';
import 'package:web_cashboost/telas/vouchers/cadastrar_editar_voucher/cadastrar_editar_voucher_screen.dart';
import 'package:web_cashboost/telas/vouchers/voucher_screen.dart';
import 'package:web_cashboost/widgets/erro.dart';
import 'package:web_cashboost/widgets/scaffold.dart';
import 'package:web_cashboost/widgets/util.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return scaffold(
      title: "Administrativo Cashboost",
      hideBackArrow: true,
      body: Row(
        children: <Widget>[
          NavigationRail(
            minWidth: 30,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.selected,
            indicatorColor: AppColor.primaryColor.withOpacity(0.1),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.person, color: AppColor.primaryColor),
                label: text("Clientes", color: Colors.grey, textAlign: TextAlign.center),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.card_giftcard, color: AppColor.primaryColor),
                label: text("Vouchers", color: Colors.grey, textAlign: TextAlign.center),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.pix, color: AppColor.primaryColor),
                label: text("Voucher e\nPIX", color: Colors.grey, textAlign: TextAlign.center),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.document_scanner, color: AppColor.primaryColor),
                label: text("Aprovação\nde vendas", color: Colors.grey, textAlign: TextAlign.center),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _buildSelectedView(_selectedIndex)),
        ],
      ),
    );
  }

  Widget _buildSelectedView(int index) {
    switch (index) {
      case 0:
        return const VendedoresScreen();
      case 1:
        return const VoucherScreen();
      case 2:
        return const SolicitadosScreen();
      case 3:
        return const VendasScreen();
      default:
        return erro(ErrorModel(mensagem: "Ocorreu um erro"), function: () => {});
    }
  }
}
