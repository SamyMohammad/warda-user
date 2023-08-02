import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warda/controller/auth_controller.dart';
import 'package:warda/controller/item_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/controller/wishlist_controller.dart';
import 'package:warda/data/model/response/item_model.dart';
import 'package:warda/helper/price_converter.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/custom_snackbar.dart';
import 'package:warda/view/base/rating_bar.dart';

class ItemTitleView extends StatelessWidget {
  final Item? item;
  final bool inStorePage;
  final bool isCampaign;
  final bool inStock;
  const ItemTitleView(
      {Key? key,
      required this.item,
      this.inStorePage = false,
      this.isCampaign = false,
      required this.inStock})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(inStock ? 'out_of_stock'.tr : 'in_stock'.tr);
    }
    final bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    double? startingPrice;
    double? endingPrice;
    if (item!.variations!.isNotEmpty) {
      List<double?> priceList = [];
      for (var variation in item!.variations!) {
        priceList.add(variation.price);
      }
      priceList.sort((a, b) => a!.compareTo(b!));
      startingPrice = priceList[0];
      if (priceList[0]! < priceList[priceList.length - 1]!) {
        endingPrice = priceList[priceList.length - 1];
      }
    } else {
      startingPrice = item!.price;
    }

    double? discount =
        (Get.find<ItemController>().item!.availableDateStarts != null ||
                Get.find<ItemController>().item!.storeDiscount == 0)
            ? Get.find<ItemController>().item!.discount
            : Get.find<ItemController>().item!.storeDiscount;
    String? discountType =
        (Get.find<ItemController>().item!.availableDateStarts != null ||
                Get.find<ItemController>().item!.storeDiscount == 0)
            ? Get.find<ItemController>().item!.discountType
            : 'percent';

    return ResponsiveHelper.isDesktop(context)
        ? GetBuilder<ItemController>(builder: (itemController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item!.name ?? '',
                  style: robotoMedium.copyWith(fontSize: 30),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                InkWell(
                  onTap: () {
                    if (inStorePage) {
                      Get.back();
                    } else {
                      Get.offNamed(
                          RouteHelper.getStoreRoute(item!.storeId, 'item'));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                    child: Text(
                      item!.storeName!,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall),
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                // RatingBar(
                //     rating: item!.avgRating,
                //     ratingCount: item!.ratingCount,
                //     size: 21),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Row(children: [
                  Text(
                    '${PriceConverter.convertPrice(startingPrice, discount: discount, discountType: discountType)}'
                    '${endingPrice != null ? ' - ${PriceConverter.convertPrice(endingPrice, discount: discount, discountType: discountType)}' : ''}',
                    style: robotoBold.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 30),
                    textDirection: TextDirection.ltr,
                  ),
                  const SizedBox(width: 10),
                  discount! > 0
                      ? Flexible(
                          child: Text(
                            '${PriceConverter.convertPrice(startingPrice)}'
                            '${endingPrice != null ? ' - ${PriceConverter.convertPrice(endingPrice)}' : ''}',
                            textDirection: TextDirection.ltr,
                            style: robotoRegular.copyWith(
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(width: Dimensions.paddingSizeLarge),
                  Column(
                    children: [
                      ((Get.find<SplashController>()
                                      .configModel!
                                      .moduleConfig!
                                      .module!
                                      .unit! &&
                                  item!.unitType != null) ||
                              (Get.find<SplashController>()
                                      .configModel!
                                      .moduleConfig!
                                      .module!
                                      .vegNonVeg! &&
                                  Get.find<SplashController>()
                                      .configModel!
                                      .toggleVegNonVeg!))
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeExtraSmall,
                                  horizontal: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                              ),
                              child: Text(
                                Get.find<SplashController>()
                                        .configModel!
                                        .moduleConfig!
                                        .module!
                                        .unit!
                                    ? item!.unitType ?? ''
                                    : item!.veg == 0
                                        ? 'non_veg'.tr
                                        : 'veg'.tr,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Theme.of(context).primaryColor),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: inStock ? Colors.red : Colors.green,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        child: Text(inStock ? 'out_of_stock'.tr : 'in_stock'.tr,
                            style: robotoRegular.copyWith(
                              color: Colors.white,
                              fontSize: Dimensions.fontSizeSmall,
                            )),
                      ),
                    ],
                  ),
                ]),
              ],
            );
          })
        : Container(
            // decoration: BoxDecoration(gradient: commonGradient),
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            child: GetBuilder<ItemController>(
              builder: (itemController) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Text(
                          item!.name ?? '',
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraLarge),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Expanded(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                              Text(
                                '${PriceConverter.convertPrice(startingPrice, discount: discount, discountType: discountType)}'
                                '${endingPrice != null ? ' - ${PriceConverter.convertPrice(endingPrice, discount: discount, discountType: discountType)}' : ''}',
                                style: robotoMedium.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeLarge),
                                textDirection: TextDirection.ltr,
                              ),
                              const SizedBox(height: 5),

                              discount! > 0
                                  ? Text(
                                      '${PriceConverter.convertPrice(startingPrice)}'
                                      '${endingPrice != null ? ' - ${PriceConverter.convertPrice(endingPrice)}' : ''}',
                                      textDirection: TextDirection.ltr,
                                      style: robotoRegular.copyWith(
                                          color: Theme.of(context).hintColor,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    )
                                  : const SizedBox(),
                              SizedBox(height: discount > 0 ? 5 : 0),

                              // !isCampaign ? Row(children: [
                              //   Text(item!.avgRating!.toStringAsFixed(1), style: robotoRegular.copyWith(
                              //     color: Theme.of(context).hintColor,
                              //     fontSize: Dimensions.fontSizeLarge,
                              //   )),
                              //   const SizedBox(width: 5),

                              //   RatingBar(rating: item!.avgRating, ratingCount: item!.ratingCount),

                              // ]) : const SizedBox(),
                            ])),
                      ]),

                      // InkWell(
                      //   onTap: () {
                      //     if(inStorePage) {
                      //       Get.back();
                      //     }else {
                      //       Get.offNamed(RouteHelper.getStoreRoute(item!.storeId, 'item'));
                      //     }
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                      //     child: Text(
                      //       item!.storeName!,
                      //       style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                      //     ),
                      //   ),
                      // ),

                      // const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      // Row(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     children: [
                      //       Column(children: [
                      //         ((Get.find<SplashController>()
                      //                         .configModel!
                      //                         .moduleConfig!
                      //                         .module!
                      //                         .unit! &&
                      //                     item!.unitType != null) ||
                      //                 (Get.find<SplashController>()
                      //                         .configModel!
                      //                         .moduleConfig!
                      //                         .module!
                      //                         .vegNonVeg! &&
                      //                     Get.find<SplashController>()
                      //                         .configModel!
                      //                         .toggleVegNonVeg!))
                      //             ? Container(
                      //                 padding: const EdgeInsets.symmetric(
                      //                     vertical:
                      //                         Dimensions.paddingSizeExtraSmall,
                      //                     horizontal:
                      //                         Dimensions.paddingSizeSmall),
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius.circular(
                      //                       Dimensions.radiusSmall),
                      //                   color: Theme.of(context)
                      //                       .primaryColor
                      //                       .withOpacity(0.1),
                      //                 ),
                      //                 child: Text(
                      //                   Get.find<SplashController>()
                      //                           .configModel!
                      //                           .moduleConfig!
                      //                           .module!
                      //                           .unit!
                      //                       ? item!.unitType ?? ''
                      //                       : item!.veg == 0
                      //                           ? 'non_veg'.tr
                      //                           : 'veg'.tr,
                      //                   style: robotoRegular.copyWith(
                      //                       fontSize:
                      //                           Dimensions.fontSizeExtraSmall,
                      //                       color:
                      //                           Theme.of(context).primaryColor),
                      //                 ),
                      //               )
                      //             : const SizedBox(),
                      //         // const SizedBox(
                      //         //     height: Dimensions.paddingSizeDefault),
                      //        ]),
                      //     ]),
                    ]);
              },
            ),
          );
  }
}
