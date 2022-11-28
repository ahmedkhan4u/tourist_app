// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/appColors.dart';
import 'customText.dart';

Widget customButton(
  String text, {
  VoidCallback? onPress,
  Color? textColor,
}) {
  return Container(
    width: Get.width,
    margin: EdgeInsets.symmetric(horizontal: 10.0),
    decoration: BoxDecoration(
      border: Border.all(
        color: AppColors.borderColor,
      ),
      borderRadius: BorderRadius.circular(30.0),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: ElevatedButton(
      child: customText(
        text,
        textColor: AppColors.kBlackColor,
      ),
      onPressed: onPress,
    ),
  );
}
