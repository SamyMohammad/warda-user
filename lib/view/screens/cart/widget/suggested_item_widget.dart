import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/cart_controller.dart';
import '../../../../controller/item_controller.dart';
import '../../../../controller/splash_controller.dart';
import '../../../../controller/store_controller.dart';
import '../../../../data/model/response/cart_model.dart';
import '../../../../data/model/response/config_model.dart';
import '../../../../data/model/response/item_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_image.dart';
import '../../../base/item_widget.dart';

class SuggestedItemWidget extends StatelessWidget {
  const SuggestedItemWidget({Key? key, required this.cartList})
      : super(key: key);
  final List<CartModel> cartList;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), blurRadius: 10)]
      ),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GetBuilder<StoreController>(builder: (storeController) {
          List<Item>? suggestedItems;
          suggestedItems = [];
          List<int> cartIds = [];
          for (CartModel cartItem in cartList) {
            cartIds.add(cartItem.item!.id!);
          }
          for (Item item in storeController.cartSuggestItemModel?.items ?? []) {
            if (cartIds.contains(item.id)) {
              if (kDebugMode) {
                print(
                    'it will not added -> ${storeController.cartSuggestItemModel!.items!.indexOf(item)}');
              }
            } else {
              suggestedItems.add(item);
            }
          }
          double? discount;
          String? discountType;

          BaseUrls? baseUrls =
              Get.find<SplashController>().configModel!.baseUrls;
          return suggestedItems.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: Text('you_may_also_like'.tr,
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault)),
                    ),
                    SizedBox(
                      height: context.height * 0.26,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // itemCount: 5,
                        itemCount: suggestedItems.length,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeDefault),
                        itemBuilder: (context, index) {
                          //index = 0;
                          var item = suggestedItems![index];
                          discount = (item.storeDiscount == 0)
                              ? item.discount
                              : item.storeDiscount;
                          discountType = (item.storeDiscount == 0)
                              ? item.discountType
                              : 'percent';

                          return Padding(
                            padding: ResponsiveHelper.isDesktop(context)
                                ? const EdgeInsets.symmetric(vertical: 20)
                                : const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: context.width * 0.3,
                              padding: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall,
                                  left: Dimensions.paddingSizeExtraSmall),
                              margin: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    child: CustomImage(
                                      image: '${baseUrls!.itemImageUrl}'
                                          '/${suggestedItems[index].image}',
                                      height: context.height * 0.1,
                                      width: context.width * 0.3,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Text(
                                    item.name!,
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).hintColor),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        PriceConverter.convertPrice(item.price,
                                            discount: discount,
                                            discountType: discountType),
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            fontWeight: FontWeight.w400,
                                            color: AppConstants.primaryColor),
                                        textDirection: TextDirection.ltr,
                                      ),
                                      GetBuilder<ItemController>(
                                          builder: (itemController) {
                                        double priceWithDiscount =
                                            PriceConverter.convertWithDiscount(
                                                item.price,
                                                discount,
                                                discountType)!;
                                        return CustomButton(
                                          onPressed: () {
                                            CartModel? cartModel;
                                            cartModel = CartModel(
                                              item.price,
                                              priceWithDiscount,
                                              [],
                                              [],
                                              (item.price! -
                                                  PriceConverter
                                                      .convertWithDiscount(
                                                          item.price,
                                                          discount,
                                                          discountType)!),
                                              itemController.quantity,
                                              [],
                                              [],
                                              item.availableDateStarts != null,
                                              item.stock,
                                              item,
                                            );
                                            // if (itemController.cartIndex ==
                                            //     -1) {
                                            // }

                                            Get.find<CartController>()
                                                .addToCart(cartModel, -1);
                                            // Get.find<CartController>()
                                            //     .addToCart(cartModel,
                                            //         itemController.cartIndex);
                                            // _key.currentState!.shake();
                                            // showCartSnackBar();
                                          },
                                          color: Colors.white,
                                          textColor: AppConstants.primaryColor,
                                          height: 30,
                                          buttonText: 'add'.tr,
                                        );
                                      })
                                    ],
                                  ) // ItemWidget(
                                  //   isStore: false,
                                  //   item: suggestedItems![index],
                                  //   fromCartSuggestion: true,
                                  //   store: null,
                                  //   index: index,
                                  //   length: null,
                                  //   isCampaign: false,
                                  //   inStore: true,
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const SizedBox();
        }),
      ]),
    );
  }
}
