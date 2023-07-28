import 'package:warda/util/dimensions.dart';
import 'package:warda/util/images.dart';
import 'package:warda/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/app_constants.dart';

class ProfileBgWidget extends StatelessWidget {
  final Widget circularImage;
  final double walletBalance;
  final int orderTotal;
  final String fullName;
  final String email;
  final Widget mainWidget;
  final bool backButton;
  const ProfileBgWidget(
      {Key? key,
      required this.mainWidget,
      required this.circularImage,
      required this.backButton,
      required this.email,
      required this.fullName,
      required this.orderTotal,
      required this.walletBalance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: context.height * 0.46,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(clipBehavior: Clip.none, children: [
              Center(
                child: Container(
                  width: Dimensions.webMaxWidth,
                  height: context.height * 0.12,
                  color: Theme.of(context).cardColor,
                ),
              ),
              Positioned(
                top: context.height * 0.12,
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: Dimensions.webMaxWidth,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(Dimensions.radiusExtraLarge)),
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 0,
                right: 0,
                child: Text(
                  'edit_profile'.tr,
                  textAlign: TextAlign.center,
                  style: wardaRegular.copyWith(
                      fontSize: Dimensions.fontSizeOverLarge,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              backButton
                  ? Positioned(
                      top: MediaQuery.of(context).padding.top,
                      left: 10,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Theme.of(context).primaryColor, size: 20),
                        onPressed: () => Get.back(),
                      ),
                    )
                  : const SizedBox(),
              Positioned(
                top: context.height * 0.12,
                left: 0,
                right: 0,
                child: circularImage,
              ),
            ]),
            SizedBox(
              height: context.height * 0.13,
            ),
            Text(
              fullName,
              style: robotoRegular.copyWith(
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              email,
              style: robotoRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: context.height * 0.03,
            ),
            SizedBox(
              width: context.width * 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        Images.orders,
                        color: AppConstants.primaryColor,
                        width: 25,
                        height: 25,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'total_order'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: 12,
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        orderTotal.toString(),
                        style: robotoRegular.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        Images.walletIcon,
                        color: AppConstants.primaryColor,
                        width: 25,
                        height: 25,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'wallet_amount'.tr,
                        style: robotoRegular.copyWith(
                            fontSize: 12,
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        walletBalance.toString(),
                        style: robotoRegular.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Expanded(child: mainWidget)
    ]);
  }
}
