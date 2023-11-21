import 'package:flutter/material.dart';

import 'container.dart';

Future showPopup(
  BuildContext context, {
  required List<Widget> children,
  double? width,
  double? height,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.white,
        child: container(
          height: height ?? 200,
          width: width ?? 500,
          radius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: children),
          ),
        ),
      );
    },
  );
}
