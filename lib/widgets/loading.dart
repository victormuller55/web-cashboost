import 'package:flutter/material.dart';
import 'package:web_cashboost/app_widget/color/colors.dart';

Widget loading({Color? color}) {
  return Center(
    child: CircularProgressIndicator(color: AppColor.primaryColor),
  );
}
