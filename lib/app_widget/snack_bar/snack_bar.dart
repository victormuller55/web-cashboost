import 'package:flutter/material.dart';
import 'package:web_cashboost/widgets/util.dart';

void showSnackbarError(BuildContext context, {String? message}) {

  final snackBar = SnackBar(
    content: text(message ?? "Ocorreu um erro", color: Colors.white),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showSnackbarWarning(BuildContext context, {required String message}) {

  final snackBar = SnackBar(
    content: text(message, color: Colors.white),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.orange,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showSnackbarSuccess(BuildContext context, {required String message}) {

  final snackBar = SnackBar(
    content: text(message, color: Colors.white),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
