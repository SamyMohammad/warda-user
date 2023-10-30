import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warda/controller/cart_controller.dart';
import 'package:warda/controller/coupon_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/controller/store_controller.dart';
import 'package:warda/data/model/response/item_model.dart';
import 'package:warda/data/model/response/store_model.dart';
import 'package:warda/helper/price_converter.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/images.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/custom_app_bar.dart';
import 'package:warda/view/base/custom_button.dart';
import 'package:warda/view/base/custom_snackbar.dart';
import 'package:warda/view/base/menu_drawer.dart';
import 'package:warda/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/order_controller.dart';
import '../../../util/app_constants.dart';
import 'cubit/cart_cubit.dart';
import 'widget/not_available_bottom_sheet.dart';

class CartScreen extends StatefulWidget {
  bool fromNav;
  CartScreen({Key? key, required this.fromNav}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<SplashController>().getConfigData();
    if (Get.find<CartController>().cartList.isNotEmpty) {
      if (Get.find<CartController>().addCutlery) {
        Get.find<CartController>().updateCutlery(isUpdate: false);
      }
      Get.find<OrderController>().getQuestions();
      Get.find<CartController>().setAvailableIndex(-1, isUpdate: false);
      Get.find<StoreController>().getCartStoreSuggestedItemList(
          Get.find<CartController>().cartList[0].item!.storeId);
      Get.find<StoreController>().getStoreDetails(
          Store(
              id: Get.find<CartController>().cartList[0].item!.storeId,
              name: null),
          false,
          fromCart: true);
    }
    BlocProvider.of<CartCubit>(context).getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'my_cart'.tr,
          backButton: (ResponsiveHelper.isDesktop(context) || !widget.fromNav)),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<CartController>(
        builder: (cartController) {
          return cartController.cartList.isNotEmpty
              ? BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    var cubit = BlocProvider.of<CartCubit>(context);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: context.height * 0.02,
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                                child: SizedBox(
                                    child: cartBody(0, cubit)))),
                      ],
                    );
                  },
                )
              : const NoDataScreen(isCart: true, text: '', showFooter: true);
        },
      ),
    );
  }

  Widget cartHeader(CartController cartController, CartCubit cubit) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          stepperWidget(
              context,
              cubit,
              Image.asset(
                Images.cartHeader,
                color: Colors.white,
                width: 25,
                height: 25,
              ),
              'cart'.tr,
              0),

          dividerWidget(cubit, 1),
          stepperWidget(
              context,
              cubit,
              const Icon(Icons.place_outlined, color: Colors.white, size: 25),
              'recipient_details'.tr,
              1),

          dividerWidget(cubit, 2),
          stepperWidget(
              context,
              cubit,
              const Icon(Icons.av_timer_outlined,
                  color: Colors.white, size: 25),
              'time'.tr,
              2),

          dividerWidget(cubit, 3),
          stepperWidget(
              context,
              cubit,
              const Icon(Icons.mail_outline_outlined,
                  color: Colors.white, size: 25),
              'message'.tr,
              3),
          dividerWidget(cubit, 4),
          stepperWidget(
              context,
              cubit,
              const Icon(Icons.payment_outlined, color: Colors.white, size: 25),
              'checkout'.tr,
              4),
          // ResponsiveHelper.isDesktop(context)
          //     ? Expanded(
          //         flex: 4,
          //         child: pricingView(
          //             cartController, cartController.cartList[0].item!))
          //     : const SizedBox(),
        ],
      ),
    );
  }

  Widget dividerWidget(CartCubit cubit, int nextIndex) {
    return SizedBox(
      width: context.width * 0.06,
      child: Center(
        child: Container(
            margin: EdgeInsetsDirectional.only(top: context.height * 0.025),
            height: 2.0,
            color: cubit.activeStep < nextIndex
                ? Colors.grey
                : AppConstants.primaryColor),
      ),
    );
  }

  Widget stepperWidget(
    BuildContext context,
    CartCubit cubit,
    Widget image,
    String title,
    int currentStep,
  ) {
    return GestureDetector(
      onTap: () {
        String? message =
            cubit.validator(currentStep)?.entries.first.value ?? '';
        if (message.isNotEmpty) {
          cubit.changeActiveStep(
              cubit.validator(currentStep)?.entries.first.key ?? 0);
          showCustomSnackBar(message, isError: true);
        } else {
          cubit.changeActiveStep(currentStep);
        }
      },
      child: Container(
        width: currentStep == 4 ? context.width * 0.15 : context.width * 0.14,
        height: context.height * 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: context.height * 0.05,
              child: Container(
                width: currentStep == 4
                    ? context.width * 0.19
                    : context.width * 0.18,
                decoration: BoxDecoration(
                    color: cubit.activeStep < currentStep
                        ? Color(0xFFE8E8E8)
                        : AppConstants.primaryColor,
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    opacity: cubit.activeStep >= currentStep ? 1 : 0.3,
                    child: SizedBox(
                        width: 25, height: 25, child: Center(child: image)),
                  ),
                ),
              ),
            ),
            Container(
              width: context.width * 0.18,
              height: context.height * 0.05,
              alignment: Alignment.center,
              child: Text(title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: robotoRegular.copyWith(
                      color: cubit.activeStep < currentStep
                          ? Colors.grey
                          : AppConstants.primaryColor,
                      fontWeight: cubit.activeStep == currentStep
                          ? FontWeight.w800
                          : FontWeight.w400,
                      fontSize: 10)),
            )
          ],
        ),
      ),
    );
  }

  Widget cartBody(int currentStep, CartCubit cubit) {
    return SizedBox(
        width: context.width * 0.9, child: cubit.cartBodyList[currentStep]);
  }

  Widget pricingView(CartController cartController, Item item) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
              blurRadius: 5,
              spreadRadius: 1)
        ],
      ),
      child: GetBuilder<StoreController>(builder: (storeController) {
        return Column(children: [
          Get.find<SplashController>()
                      .getModuleConfig(item.moduleType)
                      .newVariation! &&
                  (storeController.store != null &&
                      storeController.store!.cutlery!)
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(Images.cutlery, height: 18, width: 18),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('add_cutlery'.tr,
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context).primaryColor)),
                                const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall),
                                Text('do_not_have_cutlery'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).disabledColor,
                                        fontSize: Dimensions.fontSizeSmall)),
                              ]),
                        ),
                        Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            value: cartController.addCutlery,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool? value) {
                              cartController.updateCutlery();
                            },
                            trackColor:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                          ),
                        )
                      ]),
                )
              : const SizedBox(),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 0.5),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            margin: ResponsiveHelper.isDesktop(context)
                ? const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault,
                    vertical: Dimensions.paddingSizeSmall)
                : EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    if (ResponsiveHelper.isDesktop(context)) {
                      Get.dialog(
                          const Dialog(child: NotAvailableBottomSheet()));
                    } else {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (con) => const NotAvailableBottomSheet(),
                      );
                    }
                  },
                  child: Row(children: [
                    Expanded(
                        child: Text('if_any_product_is_not_available'.tr,
                            style: robotoMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis)),
                    const Icon(Icons.arrow_forward_ios_sharp, size: 18),
                  ]),
                ),
                cartController.notAvailableIndex != -1
                    ? Row(children: [
                        Text(
                            cartController
                                .notAvailableList[
                                    cartController.notAvailableIndex]
                                .tr,
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).primaryColor)),
                        IconButton(
                          onPressed: () => cartController.setAvailableIndex(-1),
                          icon: const Icon(Icons.clear, size: 18),
                        )
                      ])
                    : const SizedBox(),
              ],
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          // Total
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('item_price'.tr, style: robotoRegular),
                Text(PriceConverter.convertPrice(cartController.itemPrice),
                    style: robotoRegular, textDirection: TextDirection.ltr),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('discount'.tr, style: robotoRegular),
                Text(
                    '(-) ${PriceConverter.convertPrice(cartController.itemDiscountPrice)}',
                    style: robotoRegular,
                    textDirection: TextDirection.ltr),
              ]),
              SizedBox(
                  height: Get.find<SplashController>()
                          .configModel!
                          .moduleConfig!
                          .module!
                          .addOn!
                      ? 10
                      : 0),

              Get.find<SplashController>()
                      .configModel!
                      .moduleConfig!
                      .module!
                      .addOn!
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('addons'.tr, style: robotoRegular),
                        Text(
                            '(+) ${PriceConverter.convertPrice(cartController.addOns)}',
                            style: robotoRegular,
                            textDirection: TextDirection.ltr),
                      ],
                    )
                  : const SizedBox(),

              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              //   child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
              // ),
            ]),
          ),

          ResponsiveHelper.isDesktop(context)
              ? CheckoutButton(
                  cartController: cartController,
                  availableList: cartController.availableList)
              : const SizedBox.shrink(),
        ]);
      }),
    );
  }
}

class CheckoutButton extends StatelessWidget {
  final CartController cartController;
  final List<bool> availableList;
  const CheckoutButton(
      {Key? key, required this.cartController, required this.availableList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = 0;

    return Container(
      width: Dimensions.webMaxWidth,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: ResponsiveHelper.isDesktop(context)
              ? null
              : [
                  BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      blurRadius: 10)
                ]),
      child: GetBuilder<StoreController>(builder: (storeController) {
        if (Get.find<StoreController>().store != null &&
            !Get.find<StoreController>().store!.freeDelivery! &&
            Get.find<SplashController>().configModel!.freeDeliveryOver !=
                null) {
          percentage = cartController.subTotal /
              Get.find<SplashController>().configModel!.freeDeliveryOver!;
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (storeController.store != null &&
                    !storeController.store!.freeDelivery! &&
                    Get.find<SplashController>()
                            .configModel!
                            .freeDeliveryOver !=
                        null &&
                    percentage < 1)
                ? Column(children: [
                    Row(children: [
                      Image.asset(Images.percentTag, height: 20, width: 20),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                          PriceConverter.convertPrice(
                            Get.find<SplashController>()
                                    .configModel!
                                    .freeDeliveryOver! -
                                cartController.subTotal,
                          ),
                          style: robotoMedium.copyWith(
                              color: Theme.of(context).primaryColor)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text('more_for_free_delivery'.tr,
                          style: robotoMedium.copyWith(
                              color: Theme.of(context).disabledColor)),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    LinearProgressIndicator(
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.2),
                      value: percentage,
                    ),
                  ])
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('subtotal'.tr,
                      style: robotoMedium.copyWith(
                          color: Theme.of(context).primaryColor)),
                  Text(
                    PriceConverter.convertPrice(cartController.subTotal),
                    style: robotoMedium.copyWith(
                        color: Theme.of(context).primaryColor),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
            ),
            CustomButton(
                buttonText: 'proceed_to_checkout'.tr,
                onPressed: () {
                  if (!cartController.cartList.first.item!.scheduleOrder! &&
                      availableList.contains(false)) {
                    showCustomSnackBar('one_or_more_product_unavailable'.tr);
                  } else {
                    // if (Get.find<SplashController>().module == null) {
                    //   int i = 0;
                    //   for (i = 0;
                    //       i < Get.find<SplashController>().moduleList!.length;
                    //       i++) {
                    //     if (cartController.cartList[0].item!.moduleId ==
                    //         Get.find<SplashController>().moduleList![i].id) {
                    //       break;
                    //     }
                    //   }
                    //   Get.find<SplashController>().setModule(
                    //       Get.find<SplashController>().moduleList![i]);
                    // }
                    Get.find<CouponController>().removeCouponData(false);

                    Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
                  }
                }),
          ],
        );
      }),
    );
  }
}
