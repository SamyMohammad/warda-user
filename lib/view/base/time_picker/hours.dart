// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../util/app_constants.dart';
import '../../../util/styles.dart';

class MyHours extends StatelessWidget {
  int hours;

  MyHours({required this.hours});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            hours.toString(),
            style: robotoRegular.copyWith(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
