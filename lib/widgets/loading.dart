import 'package:flutter/material.dart';
import 'package:web_cashboost/app_widget/app_consts/app_colors.dart';

Widget loading({Color? color}) {
  return Center(
    child: CircularProgressIndicator(color: AppColors.primaryColor),
  );
}
