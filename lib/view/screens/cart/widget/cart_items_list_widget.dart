import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:warda/view/screens/cart/widget/suggested_item_widget.dart';

import '../../../../controller/cart_controller.dart';
import '../../../../helper/price_converter.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/web_constrained_box.dart';
import '../cubit/cart_cubit.dart';
import 'cart_item_widget.dart';

class CartItemsListWidget extends StatefulWidget {
  const CartItemsListWidget({Key? key}) : super(key: key);

  @override
  State<CartItemsListWidget> createState() => _CartItemsListWidgetState();
}

class _CartItemsListWidgetState extends State<CartItemsListWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      return cartController.cartList.isNotEmpty
          ? Column(
              children: [
                // Product
                WebConstrainedBox(
                  dataLength: cartController.cartList.length,
                  minLength: 5,
                  minHeight: 0.6,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cartController.cartList.length,
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          itemBuilder: (context, index) {
                            return CartItemWidget(
                                cart: cartController.cartList[index],
                                cartIndex: index,
                                addOns: cartController.addOnsList[index],
                                isAvailable:
                                    cartController.availableList[index]);
                          },
                        ),
                        const Divider(thickness: 0.5, height: 5),
                        // Padding(
                        //   padding: const EdgeInsets
                        //           .only(
                        //       left: Dimensions
                        //           .paddingSizeExtraSmall),
                        //   child: TextButton.icon(
                        //     onPressed: () {
                        //       cartController
                        //           .forcefullySetModule(
                        //               cartController
                        //                   .cartList[
                        //                       0]
                        //                   .item!
                        //                   .moduleId!);
                        //       Get.toNamed(
                        //         RouteHelper
                        //             .getStoreRoute(
                        //                 cartController
                        //                     .cartList[
                        //                         0]
                        //                     .item!
                        //                     .storeId,
                        //                 'item'),
                        //         arguments: StoreScreen(
                        //             store: Store(
                        //                 id: cartController
                        //                     .cartList[
                        //                         0]
                        //                     .item!
                        //                     .storeId),
                        //             fromModule:
                        //                 false),
                        //       );
                        //     },
                        //     icon: Icon(
                        //         Icons
                        //             .add_circle_outline_sharp,
                        //         color: Theme.of(
                        //                 context)
                        //             .primaryColor),
                        //     label: Text(
                        //         'add_more_items'.tr,
                        //         style: robotoMedium.copyWith(
                        //             color: Theme.of(
                        //                     context)
                        //                 .primaryColor,
                        //             fontSize: Dimensions
                        //                 .fontSizeDefault)),
                        //   ),
                        // ),

                        !ResponsiveHelper.isDesktop(context)
                            ? SuggestedItemWidget(
                                cartList: cartController.cartList,
                              )
                            : const SizedBox(),
                      ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                ResponsiveHelper.isDesktop(context)
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          CustomButton(
                            buttonText:
                                '${'total_amount'.tr}   ${PriceConverter.convertPrice(cartController.subTotal)}',
                            width: context.width * 0.9,
                            color: Theme.of(context).cardColor,
                            textColor: Theme.of(context).primaryColor,
                            radius: 30,
                            height: context.height * 0.07,
                            onPressed: () {},
                          ),
                          SizedBox(
                            height: context.height * 0.01,
                          ),
                          // CustomButton(
                          //   buttonText: 'continue'.tr,
                          //   width: context.width * 0.8,
                          //   radius: 30,
                          //   height: context.height * 0.07,
                          //   onPressed: () {
                          //     String? message =
                          //         BlocProvider.of<CartCubit>(context)
                          //             .validator(1);
                          //     if (message.runtimeType != Null) {
                          //       showCustomSnackBar(message, isError: true);
                          //     } else {
                          //       BlocProvider.of<CartCubit>(context)
                          //           .changeActiveStep(1);
                          //     }
                          //   },
                          // ),
                          SizedBox(
                            height: context.height * 0.04,
                          ),
                        ],
                      )
                // : CheckoutButton(
                //     cartController: cartController,
                //     availableList: cartController.availableList),
                // !ResponsiveHelper.isDesktop(context)
                //     ? pricingView(
                //         cartController,
                //         cartController
                //             .cartList[0].item!)
                //     : const SizedBox(),
              ],
            )
          : SizedBox();
    });
  }
}
