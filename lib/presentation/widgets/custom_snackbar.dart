// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';

Widget? customSnackBar(
    {required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(content),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  ));
}
