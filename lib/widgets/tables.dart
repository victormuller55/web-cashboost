import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:web_cashboost/app_widget/color/colors.dart';
import 'package:web_cashboost/app_widget/snack_bar/snack_bar.dart';
import 'package:web_cashboost/widgets/elevated_button.dart';
import 'package:web_cashboost/widgets/sized_box.dart';

import 'container.dart';

bool isEven(int index) {
  return index.isEven;
}

Future<Uint8List?> capturarTabela(BuildContext context, GlobalKey key) async {
  try {
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  } catch (e) {
    showSnackbarWarning(context, message: "Não foi possível capturar a tabela");
    return null;
  }
}

Future<pw.Widget> getImageWidget() async {
  final ByteData data = await rootBundle.load('assets/images/logo_light_background.png');
  final Uint8List bytes = data.buffer.asUint8List();

  final image = pw.MemoryImage(bytes);

  return pw.Container(height: 30, child: pw.Image(image));
}

Future<Uint8List> gerarPDF(Uint8List imageBytes, String titulo) async {
  final pdf = pw.Document();
  final imageWidget = await getImageWidget();

  final now = DateTime.now();
  final formattedDate = '${now.day.toString().padLeft(2, '0')}/'
      '${now.month.toString().padLeft(2, '0')}/'
      '${now.year.toString()} '
      '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}';

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        final image = pw.MemoryImage(imageBytes);
        return pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(titulo.toUpperCase(), style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Text('Criado em: $formattedDate', style: const pw.TextStyle(fontSize: 8)),
                    ]
                ),
                imageWidget,
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Image(image),
          ],
        );
      },
    ),
  );

  return pdf.save();
}

void downloadPDF(Uint8List pdfBytes, String titulo) {
  final blob = Blob([pdfBytes], 'application/pdf');
  final url = Url.createObjectUrlFromBlob(blob);

  final anchor = AnchorElement(href: url)
    ..setAttribute("download", "cashboost_relatorio_${titulo.toLowerCase().replaceAll(" ", "_")}.pdf")
    ..click();

  Url.revokeObjectUrl(url);
}

void onTapDonwload(BuildContext context, {required GlobalKey globalKey, required String titulo}) async {
  Uint8List? imageBytes = await capturarTabela(context, globalKey);
  if (imageBytes != null) {
    Uint8List pdfBytes = await gerarPDF(imageBytes, titulo);
    downloadPDF(pdfBytes, titulo);
  }
}

Widget getTableDefault({
  required BuildContext context,
  required void Function() reload,
  required String titulo,
  required List<DataColumn> colunas,
  required List<DataRow> linhas,
  List<Widget>? children,
}) {
  final GlobalKey globalKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        container(
          child: Row(
            children: [
              ...?children,
              const SizedBox(width: 10),
              elevatedButtonText(
                "Recarregar",
                function: reload,
                height: 40,
                width: 150,
                color: AppColor.primaryColor,
                textColor: Colors.white,
              ),
              const SizedBox(width: 10),
              elevatedButtonText(
                "Download PDF",
                width: 150,
                height: 40,
                color: AppColor.primaryColor,
                textColor: Colors.white,
                function: () => onTapDonwload(context, globalKey: globalKey, titulo: titulo),
              ),
            ],
          ),
        ),
        sizedBoxVertical(10),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: RepaintBoundary(
                  key: globalKey,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: DataTable(
                      showBottomBorder: true,
                      headingRowHeight: 40,
                      dataRowHeight: 40,
                      headingRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) => Colors.black.withOpacity(0.7)),
                      dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) => Colors.white),
                      columns: colunas,
                      rows: linhas,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget elevatedButtonTable(String title, void Function() onTap, {Color? color}) {
  return elevatedButtonText(
    title,
    function: onTap,
    height: 15,
    width: 120,
    color: color ?? AppColor.primaryColor,
    textColor: Colors.white,
  );
}

Widget imageTable(String url) {
  return container(
    height: 30,
    width: 30,
    radius: BorderRadius.circular(5),
    image: NetworkImage(url),
  );
}
