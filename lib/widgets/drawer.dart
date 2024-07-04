import 'package:flutter/material.dart';
import 'package:web_cashboost/app_widget/app_consts/app_colors.dart';
import 'package:web_cashboost/functions/navigation.dart';
import 'package:web_cashboost/telas/solicitados/solicitados_screen.dart';
import 'package:web_cashboost/telas/vendas/vendas_screen.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_screen.dart';
import 'package:web_cashboost/telas/vouchers/voucher_screen.dart';
import 'package:web_cashboost/widgets/util.dart';

Widget _option({
  required IconData icon,
  required String title,
  required Widget screen,
}) {
  return Builder(
    builder: (context) {
      return ListTile(
        onTap: () => open(context, screen: screen, closePrevious: true),
        tileColor: Colors.transparent,
        splashColor: AppColors.primaryColor,
        focusColor: AppColors.secondaryColor,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
        title: text(title, fontSize: 13),
        leading: Icon(icon, color: Colors.white),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
      );
    }
  );
}

Widget appDrawer() {
  return Drawer(
    backgroundColor: AppColors.primaryColor,
    width: 300,
    child: Column(
      children: [
        const SizedBox(height: 50),
        SizedBox(width: 250, child: Image.asset("assets/images/logo.png")),
        const SizedBox(height: 30),
        _option(icon: Icons.people, title: "Todos os Vendedores", screen: const VendedoresScreen()),
        _option(icon: Icons.card_giftcard, title: "Todos os Vouchers", screen: const VoucherScreen()),
        _option(icon: Icons.pix, title: "Solicitações de Vouchers/PIX", screen: const SolicitadosScreen()),
        _option(icon: Icons.document_scanner, title: "Solicitações de NFE", screen: const VendasScreen()),
      ],
    ),
  );
}
