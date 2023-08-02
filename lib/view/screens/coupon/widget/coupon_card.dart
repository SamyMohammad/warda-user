import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:warda/controller/coupon_controller.dart';
import 'package:warda/controller/localization_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/controller/theme_controller.dart';
import 'package:warda/helper/date_converter.dart';
import 'package:warda/helper/price_converter.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/images.dart';
import 'package:warda/util/styles.dart';

class CouponCard extends StatelessWidget {
  final CouponController couponController;
  final int index;
  final String couponImg;
  const CouponCard(
      {Key? key,
      required this.couponController,
      required this.index,
      required this.couponImg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: commonGradient,
      ),
      margin: EdgeInsets.symmetric(horizontal: 12),
      height: context.height * 0.2,
      width: context.width * 0.55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: Image.asset(
              couponController.couponList![index].discountType == 'percent'
                  ? Images.percentCouponOffer
                  : couponController.couponList![index].couponType ==
                          'free_delivery'
                      ? Images.freeDelivery
                      : Images.money,
              height: context.height * 0.2,
              width: context.width * 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${couponController.couponList![index].title}',
                  style: robotoRegular,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Text(
                  '${DateConverter.stringToReadableStringWithoutyear(couponController.couponList![index].startDate!)} ${'to'.tr} ${DateConverter.stringToReadableStringWithoutyear(couponController.couponList![index].expireDate!)}',
                  style: robotoMedium.copyWith(
                      color: Theme.of(context).disabledColor,
                      fontSize: Dimensions.fontSizeSmall),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(children: [
                  Text(
                    '*${'min_purchase'.tr} ',
                    style: robotoRegular.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Text(
                    PriceConverter.convertPrice(
                        couponController.couponList![index].minPurchase),
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontSize: Dimensions.fontSizeSmall),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                couponImg,
                width: context.width * 0.7,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${couponController.couponList![index].discount}${couponController.couponList![index].discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol} ${'off'.tr}',
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge,
                        color: Colors.white),
                  ),
                  couponController.couponList![index].store == null
                      ? Text(
                          couponController.couponList![index].couponType ==
                                  'store_wise'
                              ? '${'on'.tr} ${couponController.couponList![index].data}'
                              : 'on_all_store'.tr,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          couponController.couponList![index].couponType ==
                                  'default'
                              ? '${couponController.couponList![index].store!.name}'
                              : '',
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
