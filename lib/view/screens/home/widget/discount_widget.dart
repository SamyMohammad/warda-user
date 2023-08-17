import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warda/util/app_constants.dart';

import '../../../../controller/item_controller.dart';
import '../../../../controller/localization_controller.dart';
import '../../../../controller/splash_controller.dart';
import '../../../../data/model/response/item_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/corner_banner/banner.dart';
import '../../../base/corner_banner/corner_discount_tag.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_image.dart';
import '../../../base/not_available_widget.dart';
import '../../../base/organic_tag.dart';
import '../../../base/title_widget.dart';

class DiscountWidget extends StatelessWidget {
  const DiscountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(builder: (itemController) {
      List<Item>? itemList = itemController.discountItemList;
      return (itemList != null && itemList.isEmpty)
          ? const SizedBox()
          : Column(
              children: [
                TitleWidget(
                  title: 'discount'.tr,
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: context.width * 0.00),
                  decoration: BoxDecoration(
                      gradient: commonGradient,
                      color: Color(0xffd9d9d9),
                      borderRadius: BorderRadius.circular(10)),
                  height: context.height * 0.175,
                  child: itemList != null
                      ? ListView.builder(
                          controller: ScrollController(),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(
                              left: Dimensions.paddingSizeSmall),
                          itemCount:
                              itemList.length > 10 ? 10 : itemList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  2, 0, Dimensions.paddingSizeSmall, 0),
                              child: Container(
                                height: context.height * 0.16,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeExtraSmall),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radiusSmall),
                                          child: CustomImage(
                                            image:
                                                '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}'
                                                '/${itemList[index].image}',
                                            height: context.height * 0.15,
                                            width: context.height * 0.13,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ]),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeSmall),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                itemList[index].name!,
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeExtraLarge),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Wrap(children: [
                                                Text(
                                                  itemList[index].description!,
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                      color: Theme.of(context)
                                                          .hintColor),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ]),
                                              const SizedBox(
                                                height: 6,
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
                                                                .end,
                                                        children: [
                                                          Text(
                                                            PriceConverter
                                                                .convertPrice(
                                                              itemController
                                                                  .getStartingPrice(
                                                                      itemList[
                                                                          index]),
                                                              discount:
                                                                  itemList[
                                                                          index]
                                                                      .discount,
                                                              discountType:
                                                                  itemList[
                                                                          index]
                                                                      .discountType,
                                                            ),
                                                            style: robotoBold.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeDefault,
                                                                color: AppConstants
                                                                    .priceColor),
                                                          ),
                                                          // SizedBox(
                                                          //     width: itemList[index]
                                                          //                 .discount! >
                                                          //             0
                                                          //         ? Dimensions
                                                          //             .paddingSizeExtraSmall
                                                          //         : 0),
                                                          // itemList[index]
                                                          //             .discount! >
                                                          //         0
                                                          //     ? Text(
                                                          //         PriceConverter.convertPrice(
                                                          //             itemController
                                                          //                 .getStartingPrice(
                                                          //                     itemList[index])),
                                                          //         style: robotoMedium
                                                          //             .copyWith(
                                                          //           fontSize:
                                                          //               Dimensions
                                                          //                   .fontSizeExtraSmall,
                                                          //           color: Theme.of(
                                                          //                   context)
                                                          //               .disabledColor,
                                                          //           decoration:
                                                          //               TextDecoration
                                                          //                   .lineThrough,
                                                          //         ),
                                                          //         textDirection:
                                                          //             TextDirection
                                                          //                 .ltr,
                                                          //       )
                                                          //     : const SizedBox(),
                                                        ]),
                                                  ]),
                                              // const SizedBox(
                                              //   height: 6,
                                              // ),
                                              CustomButton(
                                                onPressed: () {
                                                  Get.find<ItemController>()
                                                      .navigateToItemPage(
                                                          itemList[index],
                                                          context);
                                                },
                                                width: context.width * 0.25,
                                                height: context.height * 0.035,
                                                fontSize: 13,
                                                radius: 10,
                                                buttonText: 'get_now'.tr,
                                              )
                                            ]),
                                      ),
                                    ]),
                              ),
                            );
                          },
                        )
                      : SizedBox(),
                ),
              ],
            );
    });
  }
}
