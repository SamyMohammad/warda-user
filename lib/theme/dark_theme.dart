import 'package:flutter/material.dart';

import '../util/app_constants.dart';

ThemeData dark({Color color = AppConstants.primaryColor}) => ThemeData(
      fontFamily: 'Roboto',
      primaryColor: color,
      secondaryHeaderColor: AppConstants.primaryColor,
      disabledColor: const Color(0xffa2a7ad),
      brightness: Brightness.dark,
      hintColor: const Color(0xFFbebebe),
      cardColor: Colors.black,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: color)),
      colorScheme: ColorScheme.dark(primary: color, secondary: color)
          .copyWith(background: const Color(0xFF343636))
          .copyWith(error: const Color(0xFFdd3135)),
    );
