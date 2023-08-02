import 'package:flutter/material.dart';

import '../util/app_constants.dart';

ThemeData light({Color color = AppConstants.primaryColor}) => ThemeData(
      fontFamily: 'Roboto',
      primaryColor: color,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      secondaryHeaderColor: AppConstants.primaryColor,
      disabledColor: const Color(0xFFBABFC4),
      brightness: Brightness.light,
      hintColor: const Color(0xFF9F9F9F),
      cardColor: Colors.white,
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: color)),
      colorScheme: ColorScheme.light(primary: color, secondary: color)
          .copyWith(background: const Color(0xFFF3F3F3))
          .copyWith(error: const Color(0xFFE84D4F)),
    );
