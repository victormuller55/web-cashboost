

import 'package:flutter/material.dart';

Widget text(
  String text, {
  Color? color,
  double? fontSize,
  bool? overflow,
  bool? bold,
  double? letterSpacing,
  String? fontFamily,
  TextAlign? textAlign,
  bool? cortado,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Text(
        text,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          color: color,
          fontSize: fontSize ?? 13,
          overflow: overflow == true ? TextOverflow.ellipsis : null,
          fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
          letterSpacing: letterSpacing,
          fontFamily: fontFamily ?? 'lato',
          decoration: cortado ?? false ? TextDecoration.lineThrough : null,
        ),
      );
    },
  );
}

Widget textSelectable(
    String text, {
      Color? color,
      double? fontSize,
      bool? overflow,
      bool? bold,
      double? letterSpacing,
      String? fontFamily,
      TextAlign? textAlign,
      bool? cortado,
    }) {
  return StatefulBuilder(
    builder: (context, setState) {
      return SelectableText(
        text,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
          color: color,
          fontSize: fontSize ?? 13,
          overflow: overflow == true ? TextOverflow.ellipsis : null,
          fontWeight: bold == true ? FontWeight.bold : FontWeight.normal,
          letterSpacing: letterSpacing,
          fontFamily: fontFamily ?? 'lato',
          decoration: cortado ?? false ? TextDecoration.lineThrough : null,
        ),
      );
    },
  );
}
Widget
infoColumn({
  required String title,
  required String value,
  CrossAxisAlignment? crossAxisAlignment,
  Color? titleColor,
  Color? valueColor,
  double? titleSize,
  double? valueSize,
  double? width,
  bool? spacing,
  bool? ovewflowValue,
  bool? cortarTitle,
  bool? cortarValue,
}) {
  return Builder(builder: (context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: [
          text(title, bold: true, color: titleColor ?? Colors.white, fontSize: titleSize ?? 15, cortado: cortarTitle),
          SizedBox(height: spacing ?? false ? 5 : 0),
          text(value, color: valueColor ?? Colors.white, overflow: ovewflowValue ?? true, fontSize: valueSize, cortado: cortarValue),
        ],
      ),
    );
  });
}