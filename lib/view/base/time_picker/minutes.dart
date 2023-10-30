// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../util/app_constants.dart';
import '../../../util/styles.dart';

class MyMinutes extends StatelessWidget {
  int mins;

  MyMinutes({required this.mins});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            mins < 10 ? '0$mins' : mins.toString(),
            style: robotoRegular.copyWith(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
