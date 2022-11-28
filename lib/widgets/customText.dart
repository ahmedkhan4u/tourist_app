// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget customText(
  String text, {
  double? fontSize,
  FontWeight? fontWeight,
  Color? textColor,
  TextAlign? align,
}) {
  return Text(
    text,
    textAlign: align,
    style: TextStyle(
      fontSize: fontSize,
      color: textColor,
      fontWeight: fontWeight,
    ),
  );
}
