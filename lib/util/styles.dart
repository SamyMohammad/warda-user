import 'package:get/get.dart';
import 'package:warda/util/dimensions.dart';
import 'package:flutter/material.dart';

import 'app_constants.dart';

final robotoRegular = TextStyle(
  fontFamily: AppConstants.fontFamilyCommon,
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeDefault,
);

final wardaRegular = TextStyle(
  fontFamily: AppConstants.fontFamily,
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeDefault,
);

final robotoMedium = TextStyle(
  fontFamily: AppConstants.fontFamilyCommon,
  fontWeight: FontWeight.w500,
  fontSize: Dimensions.fontSizeDefault,
);

final robotoBold = TextStyle(
  fontFamily: AppConstants.fontFamilyCommon,
  fontWeight: FontWeight.w700,
  fontSize: Dimensions.fontSizeDefault,
);

final robotoBlack = TextStyle(
  fontFamily: AppConstants.fontFamilyCommon,
  fontWeight: FontWeight.w900,
  fontSize: Dimensions.fontSizeDefault,
);

final BoxDecoration riderContainerDecoration = BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
  color: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
  shape: BoxShape.rectangle,
);

final List<Color> onBoradingBackground1 = <Color>[
  const Color(0xFFF2D8D6),
  const Color(0xFFD3AAA7)
];
final List<Color> onBoradingBackground2 = <Color>[
  const Color(0xFFE7E0D6),
  const Color(0xFFC8B599)
];
final List<Color> onBoradingBackground3 = <Color>[
  const Color(0xFFC6D2DC),
  const Color(0xFF377872)
];

final Color onboradingTextColor1 = Color(0xFFCA97A0);
final Color onboradingTextColor2 = Color(0xFF897251);
final Color onboradingTextColor3 = Color(0xFF08756B);
