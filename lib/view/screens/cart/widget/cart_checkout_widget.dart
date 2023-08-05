import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:warda/controller/cart_controller.dart';
import 'package:warda/controller/order_controller.dart';
import 'package:warda/util/styles.dart';

import '../../../../controller/coupon_controller.dart';
import '../../../../controller/localization_controller.dart';
import '../../../../controller/location_controller.dart';
import '../../../../controller/splash_controller.dart';
import '../../../../controller/store_controller.dart';
import '../../../../data/model/response/zone_response_model.dart';
import '../../../../helper/date_converter.dart';
import '../../../../helper/price_converter.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_dropdown.dart';
import '../../../base/custom_image.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/web_constrained_box.dart';
import '../../checkout/checkout_screen.dart';
import '../../checkout/widget/coupon_bottom_sheet.dart';
import '../../location/cubit/location_cubit.dart';
import '../cubit/cart_cubit.dart';
import 'cart_item_widget.dart';

class CartCheckoutWidget extends StatelessWidget {
  CartCheckoutWidget({Key? key}) : super(key: key);

  double? _taxPercent = 0;
  bool? _isCashOnDeliveryActive = false;
  bool? _isDigitalPaymentActive = false;
  bool? firstTime = true;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return GetBuilder<CouponController>(builder: (couponController) {
        return GetBuilder<StoreController>(builder: (storeController) {
          return GetBuilder<OrderController>(builder: (orderController) {
            return GetBuilder<CartController>(builder: (cartController) {
              List<DropdownItem<int>> addressList = [];

              bool todayClosed = false;
              bool tomorrowClosed = false;
              Pivot? moduleData;
              if (storeController.store != null) {
                _isCashOnDeliveryActive =
                    Get.find<SplashController>().configModel!.cashOnDelivery!;
                _isDigitalPaymentActive =
                    Get.find<SplashController>().configModel!.digitalPayment!;
                if (firstTime!) {
                  Get.find<OrderController>().setPaymentMethod(
                      _isCashOnDeliveryActive!
                          ? 0
                          : _isDigitalPaymentActive!
                              ? 1
                              : 2,
                      isUpdate: false);
                  firstTime = false;
                }
                // for (ZoneData zData in Get.find<LocationController>()
                //     .getUserAddress()!
                //     .zoneData!) {
                //   if (zData.id == storeController.store!.zoneId) {
                //     _isCashOnDeliveryActive = zData.cashOnDelivery! &&
                //         Get.find<SplashController>()
                //             .configModel!
                //             .cashOnDelivery!;
                //     _isDigitalPaymentActive = zData.digitalPayment! &&
                //         Get.find<SplashController>()
                //             .configModel!
                //             .digitalPayment!;
                //     if (firstTime) {
                //       Get.find<OrderController>().setPaymentMethod(
                //           _isCashOnDeliveryActive!
                //               ? 0
                //               : _isDigitalPaymentActive!
                //                   ? 1
                //                   : 2,
                //           isUpdate: false);
                //       firstTime = false;
                //     }
                //   }
                //   for (Modules m in zData.modules!) {
                //     if (m.id == Get.find<SplashController>().module!.id) {
                //       moduleData = m.pivot;
                //       break;
                //     }
                //   }
                // }
                todayClosed = storeController.isStoreClosed(
                    true,
                    storeController.store!.active!,
                    storeController.store!.schedules,
                    storeController.store!.orderPlaceToScheduleInterval,
                    storeController.store!.open);
                print('helll::: >> $todayClosed');
                tomorrowClosed = storeController.isStoreClosed(
                    false,
                    storeController.store!.active!,
                    storeController.store!.schedules,
                    storeController.store!.orderPlaceToScheduleInterval,
                    storeController.store!.open);
                _taxPercent = storeController.store!.tax;
              }

              double? deliveryCharge = -1;
              double? charge = -1;
              double? maxCodOrderAmount;
              if (storeController.store != null &&
                  orderController.distance != null &&
                  orderController.distance != -1 &&
                  storeController.store!.selfDeliverySystem == 1) {
                deliveryCharge = orderController.distance! *
                    storeController.store!.perKmShippingCharge!;
                charge = orderController.distance! *
                    storeController.store!.perKmShippingCharge!;
                double? maximumCharge =
                    storeController.store!.maximumShippingCharge;

                if (deliveryCharge <
                    storeController.store!.minimumShippingCharge!) {
                  deliveryCharge = storeController.store!.minimumShippingCharge;
                  charge = storeController.store!.minimumShippingCharge;
                } else if (maximumCharge != null &&
                    deliveryCharge > maximumCharge) {
                  deliveryCharge = maximumCharge;
                  charge = maximumCharge;
                }
              } else if (storeController.store != null &&
                  orderController.distance != null &&
                  orderController.distance != -1) {
                deliveryCharge = orderController.distance! *
                    moduleData!.perKmShippingCharge!;
                charge =
                    orderController.distance! * moduleData.perKmShippingCharge!;

                if (deliveryCharge < moduleData.minimumShippingCharge!) {
                  deliveryCharge = moduleData.minimumShippingCharge;
                  charge = moduleData.minimumShippingCharge;
                } else if (moduleData.maximumShippingCharge != null &&
                    deliveryCharge > moduleData.maximumShippingCharge!) {
                  deliveryCharge = moduleData.maximumShippingCharge;
                  charge = moduleData.maximumShippingCharge;
                }
              }

              if (storeController.store != null &&
                  storeController.store!.selfDeliverySystem == 0 &&
                  orderController.extraCharge != null) {
                deliveryCharge = deliveryCharge! + orderController.extraCharge!;
                charge = charge! + orderController.extraCharge!;
              }

              if (moduleData != null) {
                maxCodOrderAmount = moduleData.maximumCodOrderAmount;
              }

              double price = 0;
              double? discount = 0;
              double couponDiscount = couponController.discount!;
              double tax = 0;
              bool taxIncluded =
                  Get.find<SplashController>().configModel!.taxIncluded == 1;
              double addOns = 0;
              double subTotal = 0;
              double total = 0;
              double orderAmount = 0;
              if (storeController.store != null &&
                  cartController.cartList.isNotEmpty) {
                for (var cartModel in cartController.cartList) {
                  // List<AddOns> addOnList = [];
                  // for (var addOnId in cartModel!.addOnIds!) {
                  //   for (AddOns addOns in cartModel.item!.addOns!) {
                  //     if (addOns.id == addOnId.id) {
                  //       addOnList.add(addOns);
                  //       break;
                  //     }
                  //   }
                  // }

                  // for (int index = 0; index < addOnList.length; index++) {
                  //   addOns = addOns +
                  //       (addOnList[index].price! *
                  //           cartModel.addOnIds![index].quantity!);
                  // }
                  price = price + (cartModel.price! * cartModel.quantity!);
                  double? dis = (storeController.store!.discount != null &&
                          DateConverter.isAvailable(
                              storeController.store!.discount!.startTime,
                              storeController.store!.discount!.endTime))
                      ? storeController.store!.discount!.discount
                      : cartModel.item!.discount;
                  print('helll::: disccount ${dis}');
                  String? disType = (storeController.store!.discount != null &&
                          DateConverter.isAvailable(
                              storeController.store!.discount!.startTime,
                              storeController.store!.discount!.endTime))
                      ? 'percent'
                      : cartModel.item!.discountType;
                  discount = discount! +
                      ((cartModel.price! -
                              PriceConverter.convertWithDiscount(
                                  cartModel.price, dis, disType)!) *
                          cartModel.quantity!);
                }
                if (storeController.store != null &&
                    storeController.store!.discount != null) {
                  if (storeController.store!.discount!.maxDiscount != 0 &&
                      storeController.store!.discount!.maxDiscount! <
                          discount!) {
                    discount = storeController.store!.discount!.maxDiscount;
                  }
                  if (storeController.store!.discount!.minPurchase != 0 &&
                      storeController.store!.discount!.minPurchase! >
                          (price + addOns)) {
                    discount = 0;
                  }
                }

                price = PriceConverter.toFixed(price);
                addOns = PriceConverter.toFixed(addOns);
                discount = PriceConverter.toFixed(discount!);
                couponDiscount = PriceConverter.toFixed(couponDiscount);

                subTotal = price + addOns;
                orderAmount = (price - discount) + addOns - couponDiscount;
                total = subTotal +
                    deliveryCharge! -
                    discount -
                    couponDiscount +
                    (taxIncluded ? 0 : tax) +
                    (orderController.orderType != 'take_away'
                        ? orderController.tips
                        : 0);
                total = PriceConverter.toFixed(total);
              }

              return BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  var cubit = BlocProvider.of<CartCubit>(context);
                  return SizedBox(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.payment_outlined,
                            color: AppConstants.primaryColor,
                          ),
                          SizedBox(
                            width: context.width * 0.03,
                          ),
                          Text(
                            'payment_method'.tr,
                            style: robotoRegular,
                          )
                        ],
                      ),
                      SizedBox(
                        height: context.height * 0.15,
                        child: ListView.builder(
                            itemCount:
                                orderController.paymentMethodList?.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var payemnt =
                                  orderController.paymentMethodList?[index];
                              if (cubit.paymentKey.runtimeType == Null) {
                                cubit.changePaymentMethod(payemnt!.key);
                              }
                              return GestureDetector(
                                onTap: () {
                                  cubit.changePaymentMethod(payemnt!.key);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: cubit.paymentKey ==
                                                        payemnt?.key
                                                    ? AppConstants.primaryColor
                                                    : Colors.white,
                                                width: 1)),
                                        width: context.width * 0.28,
                                        height: context.width * 0.23,
                                        margin: const EdgeInsets.all(5.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                                child: CustomImage(
                                                  image: payemnt?.icon ?? '',
                                                  height: context.height * 0.07,
                                                  width: context.height * 0.1,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                              Text(
                                                payemnt?.key.tr ?? '',
                                                textAlign: TextAlign.center,
                                                style: robotoRegular.copyWith(
                                                    fontSize: 11),
                                              ),
                                            ]),
                                      ),
                                      cubit.paymentKey == payemnt?.key
                                          ? Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppConstants
                                                        .primaryColor),
                                                child: const Icon(
                                                  Icons.done_outlined,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      recipientDetails(cubit, context),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      deliveryTime(cubit, context),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      message(cubit, context),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      promoCode(cubit, context, price, discount ?? 0, addOns,
                          deliveryCharge ?? 0, storeController),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      summary(
                          cubit,
                          context,
                          couponController,
                          orderController,
                          subTotal,
                          total,
                          discount ?? 0,
                          deliveryCharge ?? 0,
                          tax,
                          taxIncluded),
                      SizedBox(
                        height: context.height * 0.03,
                      ),
                      reviewYourOrder(cartController, context),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      CustomButton(
                        onPressed: () {
                          String? message = cubit.validator(5);
                          if (message.runtimeType != Null) {
                          } else {
                            cubit.placeOrder(
                                orderController,
                                cartController,
                                storeController,
                                orderAmount,
                                null,
                                maxCodOrderAmount,
                                total,
                                deliveryCharge!,
                                tax,
                                discount!);
                          }
                        },
                        buttonText: 'continue'.tr,
                        radius: 30,
                      ),
                      SizedBox(
                        height: context.height * 0.04,
                      ),
                    ],
                  ));
                },
              );
            });
          });
        });
      });
    });
  }

  Widget recipientDetails(CartCubit cubit, BuildContext context) {
    return Column(
      children: [
        // recipient details
        Row(
          children: [
            const Icon(Icons.place_outlined, color: AppConstants.primaryColor),
            SizedBox(
              width: context.width * 0.03,
            ),
            Text(
              'deliver_to'.tr,
              style: robotoMedium,
            ),
            SizedBox(
              width: context.width * 0.03,
            ),
            BlocBuilder<LocationCubit, LocationState>(
              bloc: BlocProvider.of<LocationCubit>(context)
                ..readCountryAndCity(),
              builder: (context, state) {
                var cubit = BlocProvider.of<LocationCubit>(context);
                return Container(
                  child: Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Image.network(
                          cubit.countrySelected?.flagLink ?? '',
                          errorBuilder: ((context, error, stackTrace) {
                            return Image.asset(Images.logoColor);
                          }),
                        ),
                      ),
                      Text(
                        "${cubit.cityName ?? ''}",
                        textAlign: TextAlign.center,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
        SizedBox(
          height: context.height * 0.02,
        ),
        SizedBox(
          width: context.width * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('receiver_name'.tr,
                      textAlign: TextAlign.start,
                      style: robotoRegular.copyWith(fontSize: 12)),
                  Text(cubit.fullNameController.text, style: robotoRegular),
                ],
              ),
              SizedBox(
                height: context.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('receiver_phone_number'.tr,
                      style: robotoRegular.copyWith(fontSize: 12)),
                  Text(
                      '${cubit.countryDialCode} ${cubit.phoneNumerController.text}',
                      style: robotoRegular),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: context.height * 0.02,
        ),
      ],
    );
  }

  Widget deliveryTime(CartCubit cubit, BuildContext context) {
    return Column(
      children: [
        // delivery time
        Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: AppConstants.primaryColor, size: 20),
            SizedBox(
              width: context.width * 0.03,
            ),
            SizedBox(
              child: Text(
                'delivery_time'.tr,
                style: robotoMedium,
              ),
            ),
          ],
        ),
        SizedBox(
          height: context.height * 0.02,
        ),
        SizedBox(
          width: context.width * 0.7,
          child: Text('${cubit.deliveryDate} ${'at'.tr} ${cubit.deliveryTime}',
              textAlign: TextAlign.start,
              style: robotoRegular.copyWith(fontSize: 12)),
        ),
      ],
    );
  }

  Widget message(CartCubit cubit, BuildContext context) {
    return cubit.messageController.text.isNotEmpty ||
            cubit.generatedMessage.runtimeType != Null
        ? Column(
            children: [
              // delivery time
              Row(
                children: [
                  const Icon(Icons.mail_outline,
                      color: AppConstants.primaryColor, size: 20),
                  SizedBox(
                    width: context.width * 0.03,
                  ),
                  SizedBox(
                    child: Text(
                      'message'.tr,
                      style: robotoMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              SizedBox(
                width: context.width * 0.7,
                child: Text(
                    cubit.generatedMessage.runtimeType != Null
                        ? cubit.generatedMessage ?? ''
                        : cubit.messageController.text,
                    textAlign: TextAlign.start,
                    style: robotoRegular.copyWith(fontSize: 12)),
              ),
            ],
          )
        : SizedBox();
  }

  Widget promoCode(
      CartCubit cubit,
      BuildContext context,
      double price,
      double discount,
      double addOns,
      double deliveryCharge,
      StoreController storeController) {
    return // Coupon
        GetBuilder<CouponController>(
      builder: (couponController) {
        return Container(
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  const Icon(Icons.place_outlined,
                      color: AppConstants.primaryColor),
                  SizedBox(
                    width: context.width * 0.03,
                  ),
                  Text('promo_code'.tr, style: robotoMedium),
                ],
              ),
              InkWell(
                onTap: () {
                  if (ResponsiveHelper.isDesktop(context)) {
                    Get.dialog(const Dialog(child: CouponBottomSheet()))
                        .then((value) {
                      if (value != null) {
                        cubit.couponController.text = value.toString();
                      }
                    });
                  } else {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (con) => const CouponBottomSheet(),
                    ).then((value) {
                      if (value != null) {
                        cubit.couponController.text = value.toString();
                      }
                      if (cubit.couponController.text.isNotEmpty) {
                        if (couponController.discount! < 1 &&
                            !couponController.freeDelivery) {
                          if (cubit.couponController.text.isNotEmpty &&
                              !couponController.isLoading) {
                            couponController
                                .applyCoupon(
                                    cubit.couponController.text,
                                    (price - discount) + addOns,
                                    deliveryCharge,
                                    storeController.store!.id)
                                .then((discount) {
                              if (discount! > 0) {
                                cubit.couponController.text =
                                    'coupon_applied'.tr;
                                showCustomSnackBar(
                                  '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                                  isError: false,
                                );
                              }
                            });
                          } else if (cubit.couponController.text.isEmpty) {
                            showCustomSnackBar('enter_a_coupon_code'.tr);
                          }
                        } else {
                          couponController.removeCouponData(true);
                          cubit.couponController.text = '';
                        }
                      }
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(children: [
                    Text('add_voucher'.tr,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).primaryColor)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Icon(Icons.add,
                        size: 20, color: Theme.of(context).primaryColor),
                  ]),
                ),
              )
            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeLarge),
              child: Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      controller: cubit.couponController,
                      style: robotoRegular.copyWith(
                          height:
                              ResponsiveHelper.isMobile(context) ? null : 2),
                      decoration: InputDecoration(
                        hintText: 'enter_promo_code'.tr,
                        hintStyle: robotoRegular.copyWith(
                            color: Theme.of(context).hintColor),
                        isDense: true,
                        filled: true,
                        enabled: couponController.discount == 0,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(
                                Get.find<LocalizationController>().isLtr
                                    ? 10
                                    : 0),
                            right: Radius.circular(
                                Get.find<LocalizationController>().isLtr
                                    ? 0
                                    : 10),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Image.asset(Images.couponIcon,
                              height: 10,
                              width: 20,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    String couponCode = cubit.couponController.text.trim();
                    if (couponController.discount! < 1 &&
                        !couponController.freeDelivery) {
                      if (couponCode.isNotEmpty &&
                          !couponController.isLoading) {
                        couponController
                            .applyCoupon(
                                couponCode,
                                (price - discount) + addOns,
                                deliveryCharge,
                                storeController.store!.id)
                            .then((discount) {
                          if (discount! > 0) {
                            showCustomSnackBar(
                              '${'you_got_discount_of'.tr} ${PriceConverter.convertPrice(discount)}',
                              isError: false,
                            );
                          }
                        });
                      } else if (couponCode.isEmpty) {
                        showCustomSnackBar('enter_a_coupon_code'.tr);
                      }
                    } else {
                      couponController.removeCouponData(true);
                      cubit.couponController.text = '';
                    }
                  },
                  child: Container(
                    height: 45,
                    width: (couponController.discount! <= 0 &&
                            !couponController.freeDelivery)
                        ? 100
                        : 50,
                    alignment: Alignment.center,
                    margin:
                        const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: (couponController.discount! <= 0 &&
                              !couponController.freeDelivery)
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: (couponController.discount! <= 0 &&
                            !couponController.freeDelivery)
                        ? !couponController.isLoading
                            ? Text(
                                'apply'.tr,
                                style: robotoMedium.copyWith(
                                    color: Theme.of(context).cardColor),
                              )
                            : const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white)),
                              )
                        : Icon(Icons.clear,
                            color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ]),
        );
      },
    );
  }

  Widget summary(
      CartCubit cart,
      BuildContext context,
      CouponController couponController,
      OrderController orderController,
      double subTotal,
      double total,
      double discount,
      double deliveryCharge,
      double tax,
      bool taxIncluded) {
    bool takeAway = orderController.orderType == 'take_away';
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.receipt_outlined,
              color: AppConstants.primaryColor,
              size: 23,
            ),
            SizedBox(
              width: context.width * 0.03,
            ),
            Text(
              'summary'.tr,
              style: robotoMedium,
            ),
          ],
        ),
        SizedBox(
          height: context.height * 0.03,
        ),
        SizedBox(
          width: context.width * 0.7,
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('subtotal'.tr, style: robotoRegular),
                Text(PriceConverter.convertPrice(subTotal),
                    style: robotoRegular, textDirection: TextDirection.ltr),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('discount'.tr, style: robotoRegular),
                Text('(-) ${PriceConverter.convertPrice(discount)}',
                    style: robotoRegular, textDirection: TextDirection.ltr),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              (couponController.discount! > 0 || couponController.freeDelivery)
                  ? Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('coupon_discount'.tr, style: robotoRegular),
                            (couponController.coupon != null &&
                                    couponController.coupon!.couponType ==
                                        'free_delivery')
                                ? Text(
                                    'free_delivery'.tr,
                                    style: robotoRegular.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  )
                                : Text(
                                    '(-) ${PriceConverter.convertPrice(couponController.discount)}',
                                    style: robotoRegular,
                                    textDirection: TextDirection.ltr,
                                  ),
                          ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                    ])
                  : const SizedBox(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                    '${'vat_tax'.tr} ${taxIncluded ? 'tax_included'.tr : ''} ($_taxPercent%)',
                    style: robotoRegular),
                Text(
                    (taxIncluded ? '' : '(+) ') +
                        PriceConverter.convertPrice(tax),
                    style: robotoRegular,
                    textDirection: TextDirection.ltr),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              (!takeAway &&
                      Get.find<SplashController>().configModel!.dmTipsStatus ==
                          1)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('delivery_man_tips'.tr, style: robotoRegular),
                        Text(
                            '(+) ${PriceConverter.convertPrice(orderController.tips)}',
                            style: robotoRegular,
                            textDirection: TextDirection.ltr),
                      ],
                    )
                  : const SizedBox.shrink(),
              SizedBox(
                  height: !takeAway &&
                          Get.find<SplashController>()
                                  .configModel!
                                  .dmTipsStatus ==
                              1
                      ? Dimensions.paddingSizeSmall
                      : 0.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('delivery_fee'.tr, style: robotoRegular),
                orderController.distance == -1
                    ? Text(
                        'calculating'.tr,
                        style: robotoRegular.copyWith(color: Colors.red),
                      )
                    : (deliveryCharge == 0 ||
                            (couponController.coupon != null &&
                                couponController.coupon!.couponType ==
                                    'free_delivery'))
                        ? Text(
                            'free'.tr,
                            style: robotoRegular.copyWith(
                                color: Theme.of(context).primaryColor),
                          )
                        : Text(
                            '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
                            style: robotoRegular,
                            textDirection: TextDirection.ltr,
                          ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall),
                child: Divider(
                    thickness: 1,
                    color: Theme.of(context).hintColor.withOpacity(0.5)),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('total_amount'.tr, style: robotoRegular),
                Text(
                  PriceConverter.convertPrice(total),
                  style: robotoRegular,
                  textDirection: TextDirection.ltr,
                ),
              ]),
            ],
          ),
        )
      ],
    );
  }

  Widget reviewYourOrder(CartController cartController, BuildContext context) {
    return Column(
      children: [
        // Product
        Row(
          children: [
            const Icon(
              Icons.preview_outlined,
              color: AppConstants.primaryColor,
              size: 23,
            ),
            SizedBox(
              width: context.width * 0.03,
            ),
            Text(
              'review_your_order'.tr,
              style: robotoMedium,
            ),
          ],
        ),
        SizedBox(
          height: context.height * 0.01,
        ),
        WebConstrainedBox(
          dataLength: cartController.cartList.length,
          minLength: 5,
          minHeight: 0.6,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cartController.cartList.length,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              itemBuilder: (context, index) {
                return CartItemWidget(
                    cart: cartController.cartList[index],
                    forReview: true,
                    cartIndex: index,
                    addOns: cartController.addOnsList[index],
                    isAvailable: cartController.availableList[index]);
              },
            ),
            const Divider(thickness: 0.5, height: 5),
          ]),
        ),
      ],
    );
  }
}
