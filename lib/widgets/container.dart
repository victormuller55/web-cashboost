import 'package:flutter/material.dart';

Widget container({
  // Alignments
  MainAxisAlignment? mainAxisAlignment,

  // CONTAINER CONFIGS
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  double? height,
  double? width,
  Color? backgroundColor,
  BorderRadiusGeometry? radius,
  BoxBorder? border,
  BoxShape? shape,
  BoxShadow? shadow,
  Gradient? gradient,
  ImageProvider<Object>? image,
  Widget? child,

  // BOTTOM TEXT CONFIGS
  String? bottomText,
  Color? bottomFontColor,
}) {
  return Container(
    margin: margin,
    padding: padding,
    height: height,
    width: width,
    decoration: BoxDecoration(
      image: image != null ? DecorationImage(image: image, fit: BoxFit.cover) : null,
      color: backgroundColor,
      borderRadius: radius,
      border: border,
      gradient: gradient,
      boxShadow: shadow != null ? [shadow] : null,
    ),
    child: child,
  );
}