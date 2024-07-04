import 'package:flutter/material.dart';
import 'package:web_cashboost/app_widget/app_consts/app_colors.dart';
import 'package:web_cashboost/widgets/util.dart';

Widget scaffold({
  required Widget body,
  required String title,
  bool? hideBackArrow,
  Widget? bottomNavigationBar,
  Widget? drawer,
  Widget? floatingActionButton,
  List<Widget>? actions,
}) {
  return Builder(
    builder: (context) {
      return Scaffold(
        extendBody: true,
        drawer: drawer,
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: text(title.toUpperCase(), bold: true, color: Colors.white),
          leading: hideBackArrow ?? false ? Container() : IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
          actions: actions != null ? [...actions, const SizedBox(width: 20)] : null,
        ),
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      );
    }
  );
}
