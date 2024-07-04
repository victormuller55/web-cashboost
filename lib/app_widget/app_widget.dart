import 'package:flutter/material.dart';
import 'package:web_cashboost/telas/vendedores/vendedores_screen.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const VendedoresScreen(),
      title: "Administrativo | Cashboost",
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.transparent,
      ),
    );
  }
}
