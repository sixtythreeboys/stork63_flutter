import 'colors.dart';
import 'text_style.dart';
import 'package:flutter/material.dart';

class MyInputDecorationTheme {
  static InputDecorationTheme defaultInputDecoration = InputDecorationTheme(
    contentPadding: const EdgeInsets.all(16),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.grey600),
      borderRadius: BorderRadius.circular(16),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.grey600),
      borderRadius: BorderRadius.circular(16),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyColors.grey600),
      borderRadius: BorderRadius.circular(16),
    ),
    hintStyle: MyTextStyle.CgS20W700,
    filled: true,
    fillColor: Colors.transparent,
  );
}