// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../util/app_constants.dart';
import '../../../util/styles.dart';

class AmPm extends StatelessWidget {
  final bool isItAm;

  AmPm({required this.isItAm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            isItAm == true ? 'AM' : 'PM',
            style:robotoRegular.copyWith(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
