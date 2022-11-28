// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

import '../utils/appColors.dart';

Widget customTextField({
  String? text,
  TextEditingController? controller,
  TextInputType? inputType,
  bool? obscureText,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: AppColors.borderColor,
      ),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: TextFormField(
      keyboardType: inputType,
      controller: controller,
      obscureText: false,
      decoration: InputDecoration(
        hintText: text!,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        hintStyle: TextStyle(
          color: AppColors.kGrayColor,
        ),
      ),
    ),
  );
}
