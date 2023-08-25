import 'package:warda/controller/item_controller.dart';
import 'package:warda/controller/localization_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/controller/theme_controller.dart';
import 'package:warda/data/model/response/item_model.dart';
import 'package:warda/helper/price_converter.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/images.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/corner_banner/banner.dart';
import 'package:warda/view/base/corner_banner/corner_discount_tag.dart';
import 'package:warda/view/base/custom_image.dart';
import 'package:warda/view/base/not_available_widget.dart';
import 'package:warda/view/base/organic_tag.dart';
import 'package:warda/view/base/rating_bar.dart';
import 'package:warda/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../util/app_constants.dart';

class PopularItemView extends StatelessWidget {
  final bool isPopular;
  final bool discount;
  const PopularItemView(
      {Key? key, required this.isPopular, this.discount = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Item>? itemList = discount
          ? itemController.discountItemList
          : isPopular
              ? itemController.popularItemList
              : itemController.reviewedItemList;

      return (itemList != null && itemList.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.only(left: context.width * 0.075),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: context.width * 0.075),
                    child: TitleWidget(
                      title: isPopular
                          ? 'popular_items'.tr
                          : 'best_reviewed_item'.tr,
                      onTap: () => Get.toNamed(
                          RouteHelper.getPopularItemRoute(isPopular)),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: context.height * 0.25,
                      minHeight: context.height * 0.23,
                    ),
                    child: itemList != null
                        ? ListView.builder(
                            controller: ScrollController(),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(
                                right: Dimensions.paddingSizeSmall),
                            itemCount:
                                itemList.length > 10 ? 10 : itemList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0, 2, Dimensions.paddingSizeSmall, 2),
                                child: InkWell(
                                  onTap: () {
                                    Get.find<ItemController>()
                                        .navigateToItemPage(
                                            itemList[index], context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(
                                        Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[
                                                Get.find<ThemeController>()
                                                        .darkTheme
                                                    ? 800
                                                    : 100]!,
                                            blurRadius: 1,
                                            spreadRadius: 1,
                                            offset: Offset(0, 0))
                                      ],
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Stack(children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusSmall),
                                              child: CustomImage(
                                                image:
                                                    '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}'
                                                    '/${itemList[index].image}',
                                                height: context.height * 0.15,
                                                width: context.height * 0.15,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Positioned(
                                              right: Get.find<
                                                          LocalizationController>()
                                                      .isLtr
                                                  ? 0
                                                  : null,
                                              left: Get.find<
                                                          LocalizationController>()
                                                      .isLtr
                                                  ? null
                                                  : 0,
                                              child: CornerDiscountTag(
                                                bannerPosition: Get.find<
                                                            LocalizationController>()
                                                        .isLtr
                                                    ? CornerBannerPosition
                                                        .topRight
                                                    : CornerBannerPosition
                                                        .topLeft,
                                                elevation: 0,
                                                discount:
                                                    itemController.getDiscount(
                                                        itemList[index]),
                                                discountType: itemController
                                                    .getDiscountType(
                                                        itemList[index]),
                                              ),
                                            ),
                                            OrganicTag(
                                                item: itemList[index],
                                                placeInImage: true),
                                            itemController.isAvailable(
                                                    itemList[index])
                                                ? const SizedBox()
                                                : const NotAvailableWidget(),
                                          ]),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: Dimensions
                                                    .paddingSizeDefault,
                                                top: 8),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        context.height * 0.13,
                                                    child: Text(
                                                      itemList[index].name!,
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                PriceConverter
                                                                    .convertPrice(
                                                                  itemController
                                                                      .getStartingPrice(
                                                                          itemList[
                                                                              index]),
                                                                  discount: itemList[
                                                                          index]
                                                                      .discount,
                                                                  discountType:
                                                                      itemList[
                                                                              index]
                                                                          .discountType,
                                                                ),
                                                                textDirection:
                                                                    TextDirection
                                                                        .ltr,
                                                                style: robotoBold.copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall,
                                                                    color: AppConstants
                                                                        .priceColor),
                                                              ),
                                                              SizedBox(
                                                                  width: itemList[index]
                                                                              .discount! >
                                                                          0
                                                                      ? Dimensions
                                                                          .paddingSizeExtraSmall
                                                                      : 0),
                                                              itemList[index]
                                                                          .discount! >
                                                                      0
                                                                  ? Text(
                                                                      PriceConverter.convertPrice(
                                                                          itemController
                                                                              .getStartingPrice(itemList[index])),
                                                                      style: robotoMedium
                                                                          .copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeExtraSmall,
                                                                        color: Theme.of(context)
                                                                            .disabledColor,
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
                                                                      ),
                                                                      textDirection:
                                                                          TextDirection
                                                                              .ltr,
                                                                    )
                                                                  : const SizedBox(),
                                                            ]),
                                                      ]),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ]),
                                          ),
                                        ]),
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox(),
                    // PopularItemShimmer(enabled: itemList == null),
                  ),
                ],
              ),
            );
    });
  }
}

class PopularItemShimmer extends StatelessWidget {
  final bool enabled;
  const PopularItemShimmer({Key? key, required this.enabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              const EdgeInsets.fromLTRB(2, 2, Dimensions.paddingSizeSmall, 2),
          child: Container(
            height: 90,
            width: 250,
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [
                BoxShadow(
                  color: Colors
                      .grey[Get.find<ThemeController>().darkTheme ? 700 : 300]!,
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Shimmer(
              duration: const Duration(seconds: 1),
              interval: const Duration(seconds: 1),
              enabled: enabled,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusSmall),
                        color: Colors.grey[300],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 15,
                                  width: 100,
                                  color: Colors.grey[300]),
                              const SizedBox(height: 5),
                              Container(
                                  height: 10,
                                  width: 130,
                                  color: Colors.grey[300]),
                              const SizedBox(height: 5),
                              const RatingBar(
                                  rating: 0, size: 12, ratingCount: 0),
                              Row(children: [
                                Expanded(
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            height: 15,
                                            width: 50,
                                            color: Colors.grey[300]),
                                        const SizedBox(
                                            width: Dimensions
                                                .paddingSizeExtraSmall),
                                        Container(
                                            height: 10,
                                            width: 50,
                                            color: Colors.grey[300]),
                                      ]),
                                ),
                                const Icon(Icons.add, size: 20),
                              ]),
                            ]),
                      ),
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
