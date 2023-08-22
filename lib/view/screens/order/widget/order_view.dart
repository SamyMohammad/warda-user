import 'package:warda/controller/order_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/data/model/response/order_model.dart';
import 'package:warda/helper/date_converter.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/images.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/custom_image.dart';
import 'package:warda/view/base/footer_view.dart';
import 'package:warda/view/base/no_data_screen.dart';
import 'package:warda/view/base/paginated_list_view.dart';
import 'package:warda/view/screens/order/order_details_screen.dart';
import 'package:warda/view/screens/order/widget/order_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/price_converter.dart';
import '../../../base/custom_button.dart';
import 'cancellation_dialogue.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  const OrderView({Key? key, required this.isRunning}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      body: GetBuilder<OrderController>(builder: (orderController) {
        PaginatedOrderModel? paginatedOrderModel;
        if (orderController.runningOrderModel != null &&
            orderController.historyOrderModel != null) {
          paginatedOrderModel = isRunning
              ? orderController.runningOrderModel
              : orderController.historyOrderModel;
        }

        return paginatedOrderModel != null
            ? paginatedOrderModel.orders!.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      if (isRunning) {
                        await orderController.getRunningOrders(1,
                            isUpdate: true);
                      } else {
                        await orderController.getHistoryOrders(1,
                            isUpdate: true);
                      }
                    },
                    child: Scrollbar(
                        controller: scrollController,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: FooterView(
                            child: SizedBox(
                              width: Dimensions.webMaxWidth,
                              child: PaginatedListView(
                                scrollController: scrollController,
                                onPaginate: (int? offset) {
                                  if (isRunning) {
                                    Get.find<OrderController>()
                                        .getRunningOrders(offset!,
                                            isUpdate: true);
                                  } else {
                                    Get.find<OrderController>()
                                        .getHistoryOrders(offset!,
                                            isUpdate: true);
                                  }
                                },
                                totalSize: paginatedOrderModel.totalSize,
                                offset: paginatedOrderModel.offset,
                                itemView: ListView.builder(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeSmall),
                                  itemCount: paginatedOrderModel.orders!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    bool isParcel = paginatedOrderModel!
                                            .orders![index].orderType ==
                                        'parcel';
                                    bool isPrescription = paginatedOrderModel
                                        .orders![index].prescriptionOrder!;

                                    return InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          RouteHelper.getOrderDetailsRoute(
                                              paginatedOrderModel!
                                                  .orders![index].id),
                                          arguments: OrderDetailsScreen(
                                            orderId: paginatedOrderModel
                                                .orders![index].id,
                                            orderModel: paginatedOrderModel
                                                .orders![index],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding:
                                            ResponsiveHelper.isDesktop(context)
                                                ? const EdgeInsets.all(
                                                    Dimensions.paddingSizeSmall)
                                                : null,
                                        margin:
                                            ResponsiveHelper.isDesktop(context)
                                                ? const EdgeInsets.only(
                                                    bottom: Dimensions
                                                        .paddingSizeSmall)
                                                : null,
                                        decoration: ResponsiveHelper.isDesktop(
                                                context)
                                            ? BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions.radiusSmall),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey[
                                                          Get.isDarkMode
                                                              ? 700
                                                              : 300]!,
                                                      blurRadius: 5,
                                                      spreadRadius: 1)
                                                ],
                                              )
                                            : null,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Stack(children: [
                                                  Container(
                                                    height: 80,
                                                    width: 70,
                                                    alignment: Alignment.center,
                                                    decoration: !isParcel
                                                        ? BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                        .radiusExtraSmall),
                                                            color: AppConstants
                                                                .lightPinkColor,
                                                          )
                                                        : null,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                              .radiusExtraSmall),
                                                      child: CustomImage(
                                                        image: isParcel
                                                            ? '${Get.find<SplashController>().configModel!.baseUrls!.parcelCategoryImageUrl}'
                                                                '/${paginatedOrderModel.orders![index].parcelCategory != null ? paginatedOrderModel.orders![index].parcelCategory!.image : ''}'
                                                            : '${Get.find<SplashController>().configModel!.baseUrls!.storeImageUrl}/${paginatedOrderModel.orders![index].store != null ? paginatedOrderModel.orders![index].store!.logo : ''}',
                                                        height:
                                                            isParcel ? 35 : 80,
                                                        width:
                                                            isParcel ? 35 : 70,
                                                        fit: isParcel
                                                            ? null
                                                            : BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  isParcel
                                                      ? Positioned(
                                                          left: 0,
                                                          top: 10,
                                                          child: Container(
                                                            padding: const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    Dimensions
                                                                        .paddingSizeExtraSmall),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                      .horizontal(
                                                                  right: Radius
                                                                      .circular(
                                                                          Dimensions
                                                                              .radiusSmall)),
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                            child: Text(
                                                                'parcel'.tr,
                                                                style:
                                                                    robotoMedium
                                                                        .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeExtraSmall,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ))
                                                      : const SizedBox(),
                                                  isPrescription
                                                      ? Positioned(
                                                          left: 0,
                                                          top: 10,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        2),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                      .horizontal(
                                                                  right: Radius
                                                                      .circular(
                                                                          Dimensions
                                                                              .radiusSmall)),
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                            child: Text(
                                                                'prescription'
                                                                    .tr,
                                                                style:
                                                                    robotoMedium
                                                                        .copyWith(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ))
                                                      : const SizedBox(),
                                                ]),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeSmall),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(children: [
                                                                Text(
                                                                  '${isParcel ? 'delivery_id'.tr : 'order_id'.tr}:',
                                                                  style: robotoRegular
                                                                      .copyWith(
                                                                          fontSize:
                                                                              Dimensions.fontSizeSmall),
                                                                ),
                                                                const SizedBox(
                                                                    width: Dimensions
                                                                        .paddingSizeExtraSmall),
                                                                Text(
                                                                    '#${paginatedOrderModel.orders![index].id}',
                                                                    style: robotoMedium.copyWith(
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall)),
                                                              ]),
                                                              Text(
                                                                DateConverter.dateTimeStringToDateTime(
                                                                    paginatedOrderModel
                                                                        .orders![
                                                                            index]
                                                                        .createdAt!),
                                                                style: robotoRegular.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                                    fontSize:
                                                                        Dimensions
                                                                            .fontSizeSmall),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  PriceConverter.convertPrice(paginatedOrderModel
                                                                      .orders![
                                                                          index]
                                                                      .orderAmount),
                                                                  style: robotoMedium.copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeDefault,
                                                                      color: AppConstants
                                                                          .primaryColor)),

                                                              isRunning
                                                                  ? CustomButton(
                                                                      onPressed:
                                                                          () {
                                                                        orderController
                                                                            .setOrderCancelReason('');
                                                                        Get.dialog(
                                                                            CancellationDialogue(
                                                                          orderId: paginatedOrderModel!
                                                                              .orders![index]
                                                                              .id,
                                                                              
                                                                        ));
                                                                      },
                                                                      width: context
                                                                              .width *
                                                                          0.3,
                                                                      height: context
                                                                              .height *
                                                                          0.03,
                                                                      fontSize:
                                                                          11,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .cardColor,
                                                                      textColor:
                                                                          AppConstants
                                                                              .primaryColor,
                                                                      buttonText:
                                                                          'cancel_order'
                                                                              .tr,
                                                                    )
                                                                  : SizedBox()
                                                              // : Text(
                                                              //     '${paginatedOrderModel.orders![index].detailsCount} ${paginatedOrderModel.orders![index].detailsCount! > 1 ? 'items'.tr : 'item'.tr}',
                                                              //     style: robotoRegular
                                                              //         .copyWith(
                                                              //             fontSize:
                                                              //                 Dimensions
                                                              //                     .fontSizeExtraSmall),
                                                              //   ),
                                                            ],
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeSmall),
                                              ]),
                                              (index ==
                                                          paginatedOrderModel
                                                                  .orders!
                                                                  .length -
                                                              1 ||
                                                      ResponsiveHelper
                                                          .isDesktop(context))
                                                  ? const SizedBox()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0),
                                                      child: Divider(
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                        height: Dimensions
                                                            .paddingSizeLarge,
                                                      ),
                                                    ),
                                            ]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        )),
                  )
                : NoDataScreen(text: 'no_order_found'.tr, showFooter: true)
            : OrderShimmer(orderController: orderController);
      }),
    );
  }
}
