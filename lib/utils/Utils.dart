import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static Widget customText(
      {required String text,
      FontWeight? fontWeight,
      double? fontSize,
      Color? color}) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? Colors.black,
          // overflow: overflow,
          fontSize: fontSize ?? 14),
    );
  }

  static int calculateCrossAxisCount() {
    double screenWidth = Get.width;
    int crossAxisCount = 3;

    if (screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth < 900) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }

    return crossAxisCount;
  }
}
