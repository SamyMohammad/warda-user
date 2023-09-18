import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/images.dart';
import 'package:warda/util/styles.dart';

import 'custom_button.dart';

void showCartSnackBar() {
  // ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
  //   dismissDirection: DismissDirection.horizontal,
  //   margin: EdgeInsets.only(
  //     right: ResponsiveHelper.isDesktop(Get.context)
  //         ? Get.context!.width * 0.7
  //         : Dimensions.paddingSizeSmall,
  //     top: Dimensions.paddingSizeSmall,
  //     bottom: Dimensions.paddingSizeSmall,
  //     left: Dimensions.paddingSizeSmall,
  //   ),
  //   duration: const Duration(seconds: 3),
  //   backgroundColor: Colors.green,
  //   behavior: SnackBarBehavior.floating,
  //   shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
  //   content: Text('item_added_to_cart'.tr,
  //       style: robotoMedium.copyWith(color: Colors.white)),
  //   action: SnackBarAction(
  //       label: 'view_cart'.tr,
  //       onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
  //       textColor: Colors.white),
  // ));
  showModalBottomSheet(
      isDismissible: false,
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(25),
          topStart: Radius.circular(25),
        ),
      ),
      builder: (context) => SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(
            start: 20,
            end: 10,
            bottom: 20,
            top: 10,
          ),
          child: Container(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  children: [
                    Image.asset(
                      Images.checked,
                      width: context.width * 0.2,
                    ),
                    SizedBox(
                      height: context.height * 0.02,
                    ),
                    Text('item_added_to_cart'.tr,
                        style: robotoMedium.copyWith(
                            color: Colors.black,
                            fontSize: Dimensions.fontSizeLarge)),
                    SizedBox(
                      height: context.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          width: context.width * 0.4,
                          height: context.height * 0.05,
                          buttonText: 'continue'.tr,
                          color: Colors.white,
                          textColor: AppConstants.primaryColor,
                          radius: Dimensions.radiusSmall,
                        ),
                        CustomButton(
                          onPressed: () {
                            Get.toNamed(RouteHelper.getMainRoute('cart'));
                          },
                          width: context.width * 0.4,
                          height: context.height * 0.05,
                          buttonText: 'checkout'.tr,
                          color: AppConstants.primaryColor,
                          textColor: Colors.white,
                          radius: Dimensions.radiusSmall,
                        )
                      ],
                    )
                  ],
                ),
                IconButton(
                    onPressed: () {
                      print('hello');
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
          )));

  // Get.showSnackbar(GetSnackBar(
  //   backgroundColor: Colors.green,
  //   message: 'item_added_to_cart'.tr,
  //   mainButton: TextButton(
  //     onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
  //     child: Text('view_cart'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
  //   ),
  //   onTap: (_) => Get.toNamed(RouteHelper.getCartRoute()),
  //   duration: Duration(seconds: 3),
  //   maxWidth: Dimensions.WEB_MAX_WIDTH,
  //   snackStyle: SnackStyle.FLOATING,
  //   margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
  //   borderRadius: 10,
  //   isDismissible: true,
  //   dismissDirection: DismissDirection.horizontal,
  // ));
}
