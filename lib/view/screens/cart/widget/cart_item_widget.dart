import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:warda/controller/cart_controller.dart';
import 'package:warda/controller/localization_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/data/model/response/cart_model.dart';
import 'package:warda/data/model/response/item_model.dart';
import 'package:warda/helper/price_converter.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/custom_image.dart';
import 'package:warda/view/base/item_bottom_sheet.dart';
import 'package:warda/view/base/quantity_button.dart';
import 'package:warda/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/app_constants.dart';

class CartItemWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  final bool forReview;
  const CartItemWidget(
      {Key? key,
      required this.cart,
      required this.cartIndex,
      required this.isAvailable,
      this.forReview = false,
      required this.addOns})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String addOnText = '';
    int index0 = 0;
    List<int?> ids = [];
    List<int?> qtys = [];
    for (var addOn in cart.addOnIds!) {
      ids.add(addOn.id);
      qtys.add(addOn.quantity);
    }
    for (var addOn in cart.item!.addOns!) {
      if (ids.contains(addOn.id)) {
        addOnText =
            '$addOnText${(index0 == 0) ? '' : ',  '}${addOn.name} (${qtys[index0]})';
        index0 = index0 + 1;
      }
    }

    String? variationText = '';
    if (Get.find<SplashController>()
        .getModuleConfig(cart.item!.moduleType)
        .newVariation!) {
      if (cart.foodVariations!.isNotEmpty) {
        for (int index = 0; index < cart.foodVariations!.length; index++) {
          if (cart.foodVariations![index].contains(true)) {
            variationText =
                '${variationText!}${variationText.isNotEmpty ? ', ' : ''}${cart.item!.foodVariations![index].name} (';
            for (int i = 0; i < cart.foodVariations![index].length; i++) {
              if (cart.foodVariations![index][i]!) {
                variationText =
                    '${variationText!}${variationText.endsWith('(') ? '' : ', '}${cart.item!.foodVariations![index].variationValues![i].level}';
              }
            }
            variationText = '${variationText!})';
          }
        }
      }
    } else {
      if (cart.variation!.isNotEmpty) {
        List<String> variationTypes = cart.variation![0].type!.split('-');
        if (variationTypes.length == cart.item!.choiceOptions!.length) {
          int index0 = 0;
          for (var choice in cart.item!.choiceOptions!) {
            variationText =
                '${variationText!}${(index0 == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index0]}';
            index0 = index0 + 1;
          }
        } else {
          variationText = cart.item!.variations![0].type;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Slidable(
        key: UniqueKey(),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          children: [
            forReview
                ? SizedBox()
                : SlidableAction(
                    onPressed: (context) =>
                        Get.find<CartController>().removeFromCart(cartIndex),
                    backgroundColor: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(
                            Get.find<LocalizationController>().isLtr
                                ? Dimensions.radiusDefault
                                : 0),
                        left: Radius.circular(
                            Get.find<LocalizationController>().isLtr
                                ? 0
                                : Dimensions.radiusDefault)),
                    foregroundColor: Colors.white,
                    icon: Icons.delete_outline,
                  ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeExtraSmall,
              horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(forReview ? 5 : 15),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
            children: [
              Row(children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(forReview ? 5 : 15),
                      child: CustomImage(
                        image:
                            '${Get.find<SplashController>().configModel!.baseUrls!.itemImageUrl}/${cart.item!.image}',
                        height: forReview
                            ? context.height * 0.08
                            : context.height * 0.13,
                        width: forReview
                            ? context.height * 0.08
                            : context.height * 0.13,
                        fit: BoxFit.cover,
                      ),
                    ),
                    isAvailable
                        ? const SizedBox()
                        : Positioned(
                            top: 0,
                            left: 0,
                            bottom: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall),
                                  color: Colors.black.withOpacity(0.6)),
                              child: Text('not_available_now_break'.tr,
                                  textAlign: TextAlign.center,
                                  style: robotoRegular.copyWith(
                                    color: Colors.white,
                                    fontSize: 8,
                                  )),
                            ),
                          ),
                  ],
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Flexible(
                            child: Text(
                              cart.item!.name!,
                              style: forReview
                                  ? robotoRegular.copyWith(
                                      fontWeight: FontWeight.w500)
                                  : robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          ((Get.find<SplashController>()
                                          .configModel!
                                          .moduleConfig!
                                          .module!
                                          .unit! &&
                                      cart.item!.unitType != null &&
                                      !Get.find<SplashController>()
                                          .getModuleConfig(
                                              cart.item!.moduleType)
                                          .newVariation!) ||
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
                                      vertical:
                                          Dimensions.paddingSizeExtraSmall,
                                      horizontal: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall),
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                  ),
                                  child: Text(
                                    Get.find<SplashController>()
                                            .configModel!
                                            .moduleConfig!
                                            .module!
                                            .unit!
                                        ? cart.item!.unitType ?? ''
                                        : cart.item!.veg == 0
                                            ? 'non_veg'.tr
                                            : 'veg'.tr,
                                    style: forReview
                                        ? robotoRegular
                                        : robotoMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                )
                              : const SizedBox(),
                        ]),
                        forReview
                            ? bodyCartItemChangeForReview(context)
                            : bodyCartItemChange(context),
                      ]),
                ),
                !ResponsiveHelper.isMobile(context)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child: IconButton(
                          onPressed: () {
                            Get.find<CartController>()
                                .removeFromCart(cartIndex);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      )
                    : const SizedBox(),
              ]),
              (Get.find<SplashController>()
                          .configModel!
                          .moduleConfig!
                          .module!
                          .addOn! &&
                      addOnText.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        const SizedBox(width: 80),
                        Text('${'addons'.tr}: ',
                            style: forReview
                                ? robotoRegular
                                : robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall)),
                        Flexible(
                            child: Text(
                          addOnText,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor),
                        )),
                      ]),
                    )
                  : const SizedBox(),
              variationText!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        const SizedBox(width: 80),
                        Text('${'variations'.tr}: ',
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall)),
                        Flexible(
                            child: Text(
                          variationText,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor),
                        )),
                      ]),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyCartItemChange(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.height * 0.03),
        Row(
          children: [
            Text(
              PriceConverter.convertPrice(cart.discountedPrice),
              style: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge,
                  fontWeight: FontWeight.w400,
                  color: AppConstants.primaryColor),
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            cart.discountedPrice! + cart.discountAmount! > cart.discountedPrice!
                ? Text(
                    PriceConverter.convertPrice(
                        cart.discountedPrice! + cart.discountAmount!),
                    textDirection: TextDirection.ltr,
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).disabledColor,
                        fontSize: Dimensions.fontSizeSmall,
                        decoration: TextDecoration.lineThrough),
                  )
                : const SizedBox(),
          ],
        ),
        SizedBox(height: context.height * 0.01),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              QuantityButton(
                onTap: () {
                  if (cart.quantity! > 1) {
                    Get.find<CartController>()
                        .setQuantity(false, cartIndex, cart.stock);
                  } else {
                    Get.find<CartController>().removeFromCart(cartIndex);
                  }
                },
                isIncrement: false,
                showRemoveIcon: cart.quantity! == 1,
              ),
              SizedBox(
                width: context.width * 0.03,
              ),
              Text(cart.quantity.toString(),
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge)),
              SizedBox(
                width: context.width * 0.03,
              ),
              QuantityButton(
                onTap: () {
                  Get.find<CartController>().forcefullySetModule(
                      Get.find<CartController>().cartList[0].item!.moduleId!);
                  Get.find<CartController>()
                      .setQuantity(true, cartIndex, cart.stock);
                },
                isIncrement: true,
              ),
            ]),
      ],
    );
  }

  Widget bodyCartItemChangeForReview(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${'qty'.tr}: ${cart.quantity.toString()}',
            style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
        Text(
          PriceConverter.convertPrice(cart.discountedPrice),
          style: robotoRegular.copyWith(
              fontWeight: FontWeight.w600, color: AppConstants.primaryColor),
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }
}
