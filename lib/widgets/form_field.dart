import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_cashboost/widgets/util.dart' as util;

appFormFieldPadrao(
  BuildContext context,
  String text, {
  double? width,
  double? radius,
  bool? showSenha,
  bool? enable,
  TextEditingController? controller,
  TextInputType? textInputType,
  String? Function(String? value)? validator,
  TextInputFormatter? textInputFormatter,
  Icon? icon,
      Color? background
}) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        util.text(text),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: showSenha != null ? !showSenha : false,
          style: const TextStyle(fontFamily: 'lato', fontSize: 13, color: Colors.black),
          keyboardType: textInputType ?? TextInputType.name,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
          validator: validator,
          enabled: enable,
          inputFormatters: textInputFormatter != null ? [textInputFormatter] : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: background ?? Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 0.5), borderRadius: BorderRadius.circular(radius ?? 40)),
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, strokeAlign: 5), borderRadius: BorderRadius.circular(radius ?? 40)),
            disabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(radius ?? 40)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, strokeAlign: 5), borderRadius: BorderRadius.circular(radius ?? 40)),
            focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(radius ?? 40)),
            errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(radius ?? 40)),
            hintText: text,
            hintStyle: const TextStyle(fontFamily: 'lato', fontSize: 13, color: Colors.grey),
          ),
        ),
      ],
    ),
  );
}
