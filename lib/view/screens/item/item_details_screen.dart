import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warda/controller/cart_controller.dart';
import 'package:warda/controller/item_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/data/model/response/cart_model.dart';
import 'package:warda/data/model/response/item_model.dart';
import 'package:warda/helper/price_converter.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/images.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/cart_snackbar.dart';
import 'package:warda/view/base/confirmation_dialog.dart';
import 'package:warda/view/base/custom_app_bar.dart';
import 'package:warda/view/base/custom_button.dart';
import 'package:warda/view/base/custom_snackbar.dart';
import 'package:warda/view/screens/checkout/checkout_screen.dart';
import 'package:warda/view/screens/item/widget/details_app_bar.dart';
import 'package:warda/view/screens/item/widget/details_web_view.dart';
import 'package:warda/view/screens/item/widget/item_image_view.dart';
import 'package:warda/view/screens/item/widget/item_title_view.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/wishlist_controller.dart';
import '../../base/cart_widget.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item? item;
  final bool inStorePage;
  const ItemDetailsScreen(
      {Key? key, required this.item, required this.inStorePage})
      : super(key: key);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final Size size = Get.size;
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  final GlobalKey<DetailsAppBarState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    Get.find<ItemController>().getProductDetails(widget.item!);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemController>(
      builder: (itemController) {
        int? stock = 0;
        CartModel? cartModel;
        double priceWithAddons = 0;
        if (itemController.item != null &&
            itemController.variationIndex != null) {
          List<String> variationList = [];
          for (int index = 0;
              index < itemController.item!.choiceOptions!.length;
              index++) {
            variationList.add(itemController.item!.choiceOptions![index]
                .options![itemController.variationIndex![index]]
                .replaceAll(' ', ''));
          }
          String variationType = '';
          bool isFirst = true;
          for (var variation in variationList) {
            if (isFirst) {
              variationType = '$variationType$variation';
              isFirst = false;
            } else {
              variationType = '$variationType-$variation';
            }
          }

          double? price = itemController.item!.price;
          Variation? variation;
          stock = itemController.item!.stock ?? 0;
          for (Variation v in itemController.item!.variations!) {
            if (v.type == variationType) {
              price = v.price;
              variation = v;
              stock = v.stock;
              break;
            }
          }

          double? discount =
              (itemController.item!.availableDateStarts != null ||
                      itemController.item!.storeDiscount == 0)
                  ? itemController.item!.discount
                  : itemController.item!.storeDiscount;
          String? discountType =
              (itemController.item!.availableDateStarts != null ||
                      itemController.item!.storeDiscount == 0)
                  ? itemController.item!.discountType
                  : 'percent';
          double priceWithDiscount = PriceConverter.convertWithDiscount(
              price, discount, discountType)!;
          double priceWithQuantity =
              priceWithDiscount * itemController.quantity!;
          double addonsCost = 0;
          List<AddOn> addOnIdList = [];
          List<AddOns> addOnsList = [];
          for (int index = 0;
              index < itemController.item!.addOns!.length;
              index++) {
            if (itemController.addOnActiveList[index]) {
              addonsCost = addonsCost +
                  (itemController.item!.addOns![index].price! *
                      itemController.addOnQtyList[index]!);
              addOnIdList.add(AddOn(
                  id: itemController.item!.addOns![index].id,
                  quantity: itemController.addOnQtyList[index]));
              addOnsList.add(itemController.item!.addOns![index]);
            }
          }

          cartModel = CartModel(
            price,
            priceWithDiscount,
            variation != null ? [variation] : [],
            [],
            (price! -
                PriceConverter.convertWithDiscount(
                    price, discount, discountType)!),
            itemController.quantity,
            addOnIdList,
            addOnsList,
            itemController.item!.availableDateStarts != null,
            stock,
            itemController.item,
          );
          priceWithAddons = priceWithQuantity +
              (Get.find<SplashController>()
                      .configModel!
                      .moduleConfig!
                      .module!
                      .addOn!
                  ? addonsCost
                  : 0);
        }
        final bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
        return Scaffold(
          key: _globalKey,
          backgroundColor: AppConstants.lightPinkColor,
          appBar: PreferredSize(
            preferredSize: Size(context.width, context.height * 0.10),
            child: Container(
              child: ResponsiveHelper.isDesktop(context)
                  ? const CustomAppBar(title: '')
                  : CustomAppBar(title: '', showLogo: true, actions: [
                      GetBuilder<WishListController>(builder: (wishController) {
                        return InkWell(
                          onTap: () {
                            if (isLoggedIn) {
                              if (wishController.wishItemIdList
                                  .contains(itemController.item!.id)) {
                                wishController.removeFromWishList(
                                    itemController.item!.id, false);
                              } else {
                                wishController.addToWishList(
                                    itemController.item, null, false);
                              }
                            } else {
                              showCustomSnackBar('you_are_not_logged_in'.tr);
                            }
                          },
                          child: Icon(
                            wishController.wishItemIdList
                                    .contains(itemController.item!.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 25,
                            color: wishController.wishItemIdList
                                    .contains(itemController.item!.id)
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).disabledColor,
                          ),
                        );
                      }),
                      const SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(RouteHelper.getCartRoute()),
                        child: const CartWidget(
                            color: AppConstants.primaryColor, size: 25),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ]),
            ),
          ),
          body: (itemController.item != null)
              ? ResponsiveHelper.isDesktop(context)
                  ? DetailsWebView(
                      cartModel: cartModel,
                      stock: stock,
                      priceWithAddOns: priceWithAddons,
                    )
                  : Container(
                      child: SingleChildScrollView(
                        child: Column(children: [
                          Center(
                              child: Container(
                                  width: Dimensions.webMaxWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Builder(builder: (context) {
                                        return Container(
                                          child: ItemTitleView(
                                            item: itemController.item,
                                            inStorePage: widget.inStorePage,
                                            isCampaign: itemController.item!
                                                    .availableDateStarts !=
                                                null,
                                            inStock:
                                                (Get.find<SplashController>()
                                                        .configModel!
                                                        .moduleConfig!
                                                        .module!
                                                        .stock! &&
                                                    stock! <= 0),
                                          ),
                                        );
                                      }),
                                      Container(height: 12),
                                      ItemImageView(item: itemController.item),

                                      // // Variation
                                      // ListView.builder(
                                      //   shrinkWrap: true,
                                      //   itemCount: itemController
                                      //       .item!.choiceOptions!.length,
                                      //   physics:
                                      //       const NeverScrollableScrollPhysics(),
                                      //   itemBuilder: (context, index) {
                                      //     return Column(
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //         children: [
                                      //           Text(
                                      //               itemController
                                      //                   .item!
                                      //                   .choiceOptions![index]
                                      //                   .title!,
                                      //               style: robotoMedium.copyWith(
                                      //                   fontSize: Dimensions
                                      //                       .fontSizeLarge)),
                                      //           Container(
                                      //               height: Dimensions
                                      //                   .paddingSizeExtraSmall),
                                      //           GridView.builder(
                                      //             gridDelegate:
                                      //                 const SliverGridDelegateWithFixedCrossAxisCount(
                                      //               crossAxisCount: 3,
                                      //               crossAxisSpacing: 20,
                                      //               mainAxisSpacing: 10,
                                      //               childAspectRatio: (1 / 0.25),
                                      //             ),
                                      //             shrinkWrap: true,
                                      //             physics:
                                      //                 const NeverScrollableScrollPhysics(),
                                      //             itemCount: itemController
                                      //                 .item!
                                      //                 .choiceOptions![index]
                                      //                 .options!
                                      //                 .length,
                                      //             itemBuilder: (context, i) {
                                      //               return InkWell(
                                      //                 onTap: () {
                                      //                   itemController
                                      //                       .setCartVariationIndex(
                                      //                           index,
                                      //                           i,
                                      //                           itemController
                                      //                               .item);
                                      //                 },
                                      //                 child: Container(
                                      //                   alignment:
                                      //                       Alignment.center,
                                      //                   padding: const EdgeInsets
                                      //                           .symmetric(
                                      //                       horizontal: Dimensions
                                      //                           .paddingSizeExtraSmall),
                                      //                   decoration: BoxDecoration(
                                      //                     color: itemController
                                      //                                     .variationIndex![
                                      //                                 index] !=
                                      //                             i
                                      //                         ? Theme.of(context)
                                      //                             .disabledColor
                                      //                         : Theme.of(context)
                                      //                             .primaryColor,
                                      //                     borderRadius:
                                      //                         BorderRadius
                                      //                             .circular(5),
                                      //                     border: itemController
                                      //                                     .variationIndex![
                                      //                                 index] !=
                                      //                             i
                                      //                         ? Border.all(
                                      //                             color: Theme.of(
                                      //                                     context)
                                      //                                 .disabledColor,
                                      //                             width: 2)
                                      //                         : null,
                                      //                   ),
                                      //                   child: Text(
                                      //                     itemController
                                      //                         .item!
                                      //                         .choiceOptions![
                                      //                             index]
                                      //                         .options![i]
                                      //                         .trim(),
                                      //                     maxLines: 1,
                                      //                     overflow: TextOverflow
                                      //                         .ellipsis,
                                      //                     style: robotoRegular
                                      //                         .copyWith(
                                      //                       color: itemController
                                      //                                       .variationIndex![
                                      //                                   index] !=
                                      //                               i
                                      //                           ? Colors.black
                                      //                           : Colors.white,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               );
                                      //             },
                                      //           ),
                                      //           SizedBox(
                                      //               height: index !=
                                      //                       itemController
                                      //                               .item!
                                      //                               .choiceOptions!
                                      //                               .length -
                                      //                           1
                                      //                   ? Dimensions
                                      //                       .paddingSizeLarge
                                      //                   : 0),
                                      //         ]);
                                      //   },
                                      // ),
                                      // itemController
                                      //         .item!.choiceOptions!.isNotEmpty
                                      //     ? Container(
                                      //         height: Dimensions.paddingSizeLarge)
                                      //     : const SizedBox(),

                                      Container(
                                        height: context.height * 0.5143,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30)),
                                            color: Theme.of(context).cardColor),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                          child: Stack(
                                            alignment: Alignment.bottomCenter,
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.end,
                                            // mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Quantity
                                                  Row(children: [
                                                    Text('quantity'.tr,
                                                        style: robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeLarge)),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                    Container(
                                                      child: Row(children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if (itemController
                                                                    .cartIndex !=
                                                                -1) {
                                                              if (Get.find<
                                                                          CartController>()
                                                                      .cartList[
                                                                          itemController
                                                                              .cartIndex]
                                                                      .quantity! >
                                                                  1) {
                                                                Get.find<
                                                                        CartController>()
                                                                    .setQuantity(
                                                                        false,
                                                                        itemController
                                                                            .cartIndex,
                                                                        stock);
                                                              }
                                                            } else {
                                                              if (itemController
                                                                      .quantity! >
                                                                  1) {
                                                                itemController
                                                                    .setQuantity(
                                                                        false,
                                                                        stock);
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                gradient:
                                                                    commonGradient,
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .paddingSizeSmall,
                                                                  vertical:
                                                                      Dimensions
                                                                          .paddingSizeExtraSmall),
                                                              child: Icon(
                                                                  Icons.remove,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor,
                                                                  size: 20),
                                                            ),
                                                          ),
                                                        ),
                                                        GetBuilder<
                                                                CartController>(
                                                            builder:
                                                                (cartController) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12),
                                                            child: Text(
                                                              itemController
                                                                          .cartIndex !=
                                                                      -1
                                                                  ? cartController
                                                                      .cartList[
                                                                          itemController
                                                                              .cartIndex]
                                                                      .quantity
                                                                      .toString()
                                                                  : itemController
                                                                      .quantity
                                                                      .toString(),
                                                              style: robotoMedium
                                                                  .copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeExtraLarge),
                                                            ),
                                                          );
                                                        }),
                                                        InkWell(
                                                          onTap: () => itemController
                                                                      .cartIndex !=
                                                                  -1
                                                              ? Get.find<
                                                                      CartController>()
                                                                  .setQuantity(
                                                                      true,
                                                                      itemController
                                                                          .cartIndex,
                                                                      stock)
                                                              : itemController
                                                                  .setQuantity(
                                                                      true,
                                                                      stock),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                gradient:
                                                                    commonGradient,
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .paddingSizeSmall,
                                                                  vertical:
                                                                      Dimensions
                                                                          .paddingSizeExtraSmall),
                                                              child: Icon(
                                                                  Icons.add,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .hintColor,
                                                                  size: 20),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  ]),
                                                  Container(
                                                      height: Dimensions
                                                          .paddingSizeLarge),

                                                  GetBuilder<CartController>(
                                                      builder:
                                                          (cartController) {
                                                    return Row(children: [
                                                      Text(
                                                          '${'total_amount'.tr}:',
                                                          style: robotoMedium
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeLarge)),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeExtraSmall),
                                                      Text(
                                                          PriceConverter.convertPrice(itemController
                                                                      .cartIndex !=
                                                                  -1
                                                              ? (cartController
                                                                      .cartList[
                                                                          itemController
                                                                              .cartIndex]
                                                                      .discountedPrice! *
                                                                  cartController
                                                                      .cartList[
                                                                          itemController
                                                                              .cartIndex]
                                                                      .quantity!)
                                                              : priceWithAddons),
                                                          textDirection:
                                                              TextDirection.ltr,
                                                          style: robotoBold
                                                              .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: Dimensions
                                                                .fontSizeLarge,
                                                          )),
                                                    ]);
                                                  }),
                                                  Container(
                                                      height: Dimensions
                                                          .paddingSizeExtraLarge),

                                                  (itemController.item!
                                                                  .description !=
                                                              null &&
                                                          itemController
                                                              .item!
                                                              .description!
                                                              .isNotEmpty)
                                                      ? SizedBox(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  'description'
                                                                      .tr,
                                                                  style:
                                                                      robotoMedium),
                                                              const SizedBox(
                                                                  height: Dimensions
                                                                      .paddingSizeExtraSmall),
                                                              Text(
                                                                  itemController
                                                                      .item!
                                                                      .description!,
                                                                  maxLines: 9,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      robotoRegular),
                                                              const SizedBox(
                                                                  height: Dimensions
                                                                      .paddingSizeLarge),
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                              Container(
                                                height: context.height * 0.09,
                                                margin:
                                                    EdgeInsets.only(bottom: context.height * 0.03),
                                                child:
                                                    Builder(builder: (context) {
                                                  return Container(
                                                    width: 1170,
                                                    padding: const EdgeInsets
                                                            .all(
                                                        Dimensions
                                                            .paddingSizeSmall),
                                                    child: CustomButton(
                                                      buttonText: (Get.find<
                                                                      SplashController>()
                                                                  .configModel!
                                                                  .moduleConfig!
                                                                  .module!
                                                                  .stock! &&
                                                              stock! <= 0)
                                                          ? 'out_of_stock'.tr
                                                          : itemController.item!
                                                                      .availableDateStarts !=
                                                                  null
                                                              ? 'order_now'.tr
                                                              : itemController
                                                                          .cartIndex !=
                                                                      -1
                                                                  ? 'update_in_cart'
                                                                      .tr
                                                                  : 'add_to_cart'
                                                                      .tr,
                                                      onPressed: (!Get.find<
                                                                      SplashController>()
                                                                  .configModel!
                                                                  .moduleConfig!
                                                                  .module!
                                                                  .stock! ||
                                                              stock! > 0)
                                                          ? () {
                                                              if (!Get.find<
                                                                          SplashController>()
                                                                      .configModel!
                                                                      .moduleConfig!
                                                                      .module!
                                                                      .stock! ||
                                                                  stock! > 0) {
                                                                if (itemController
                                                                        .item!
                                                                        .availableDateStarts !=
                                                                    null) {
                                                                  Get.toNamed(
                                                                      RouteHelper
                                                                          .getCheckoutRoute(
                                                                              'campaign'),
                                                                      arguments:
                                                                          CheckoutScreen(
                                                                        storeId:
                                                                            null,
                                                                        fromCart:
                                                                            false,
                                                                        cartList: [
                                                                          cartModel
                                                                        ],
                                                                      ));
                                                                } else {
                                                                  // if (Get.find<CartController>()
                                                                  //     .existAnotherStoreItem(
                                                                  //         cartModel!.item!.storeId,
                                                                  //         Get.find<SplashController>()
                                                                  //                     .module ==
                                                                  //                 null
                                                                  //             ? Get.find<
                                                                  //                     SplashController>()
                                                                  //                 .cacheModule!
                                                                  //                 .id
                                                                  //             : Get.find<
                                                                  //                     SplashController>()
                                                                  //                 .module!
                                                                  //                 .id)) {
                                                                  //   Get.dialog(
                                                                  //       ConfirmationDialog(
                                                                  //         icon: Images.warning,
                                                                  //         title:
                                                                  //             'are_you_sure_to_reset'.tr,
                                                                  //         description: Get.find<
                                                                  //                     SplashController>()
                                                                  //                 .configModel!
                                                                  //                 .moduleConfig!
                                                                  //                 .module!
                                                                  //                 .showRestaurantText!
                                                                  //             ? 'if_you_continue'.tr
                                                                  //             : 'if_you_continue_without_another_store'
                                                                  //                 .tr,
                                                                  //         onYesPressed: () {
                                                                  //           Get.back();
                                                                  //           Get.find<CartController>()
                                                                  //               .removeAllAndAddToCart(
                                                                  //                   cartModel!);
                                                                  //           showCartSnackBar();
                                                                  //         },
                                                                  //       ),
                                                                  //       barrierDismissible: false);
                                                                  // }
                                                                  //  else {
                                                                  if (itemController
                                                                          .cartIndex ==
                                                                      -1) {
                                                                    Get.find<CartController>().addToCart(
                                                                        cartModel!,
                                                                        itemController
                                                                            .cartIndex);
                                                                  }
                                                                  _key.currentState!
                                                                      .shake();
                                                                  showCartSnackBar();
                                                                  // }
                                                                }
                                                              }
                                                            }
                                                          : null,
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ))),
                        ]),
                      ),
                    )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int? quantity;
  final bool isCartWidget;
  final int? stock;
  final bool isExistInCart;
  final int cartIndex;
  const QuantityButton({
    Key? key,
    required this.isIncrement,
    required this.quantity,
    required this.stock,
    required this.isExistInCart,
    required this.cartIndex,
    this.isCartWidget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isExistInCart) {
          if (!isIncrement && quantity! > 1) {
            Get.find<CartController>().setQuantity(false, cartIndex, stock);
          } else if (isIncrement && quantity! > 0) {
            if (quantity! < stock! ||
                !Get.find<SplashController>()
                    .configModel!
                    .moduleConfig!
                    .module!
                    .stock!) {
              Get.find<CartController>().setQuantity(true, cartIndex, stock);
            } else {
              showCustomSnackBar('out_of_stock'.tr);
            }
          }
        } else {
          if (!isIncrement && quantity! > 1) {
            Get.find<ItemController>().setQuantity(false, stock);
          } else if (isIncrement && quantity! > 0) {
            if (quantity! < stock! ||
                !Get.find<SplashController>()
                    .configModel!
                    .moduleConfig!
                    .module!
                    .stock!) {
              Get.find<ItemController>().setQuantity(true, stock);
            } else {
              showCustomSnackBar('out_of_stock'.tr);
            }
          }
        }
      },
      child: Container(
        // padding: EdgeInsets.all(3),
        height: 50, width: 50,
        decoration:
            BoxDecoration(shape: BoxShape.circle, gradient: commonGradient),
        child: Center(
          child: Icon(
            isIncrement ? Icons.add : Icons.remove,
            color: Theme.of(context).hintColor,
            size: isCartWidget ? 26 : 20,
          ),
        ),
      ),
    );
  }
}
