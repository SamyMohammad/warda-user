import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:warda/controller/campaign_controller.dart';
import 'package:warda/controller/item_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/controller/theme_controller.dart';
import 'package:warda/helper/price_converter.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/custom_button.dart';
import 'package:warda/view/base/custom_image.dart';
import 'package:warda/view/base/discount_tag.dart';
import 'package:warda/view/base/not_available_widget.dart';
import 'package:warda/view/base/rating_bar.dart';
import 'package:warda/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../controller/banner_controller.dart';

class ItemCampaignView extends StatelessWidget {
  const ItemCampaignView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      return (bannerController.campaignModel != null &&
              bannerController.campaignModel!.banners!.isEmpty)
          ? const SizedBox()
          : Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                //   child: TitleWidget(title: 'campaigns'.tr, onTap: () => Get.toNamed(RouteHelper.getItemCampaignRoute())),
                // ),
                bannerController.campaignModel != null
                    ? CarouselSlider.builder(
                        itemCount:
                            bannerController.campaignModel!.banners!.length,
                        itemBuilder: (BuildContext context, int index,
                                int pageViewIndex) =>
                            Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              // child: Stack(
                              //   children: [
                              //
                              //   ],
                              // ),
                              // child: CustomImage(
                              //
                              //   image: 'https://img.freepik.com/premium-photo/autumn-flowers-rustic-ceramic-vase-background-gray-wall_176873-10312.jpg?w=740'
                              //   ,height: context.height*.27, width:context.width*.8 , fit: BoxFit.contain,
                              // ),
                              child: CachedNetworkImage(
                                imageUrl: Get.find<BannerController>()
                                    .campaignModel!
                                    .banners![index]
                                    .image!,
                                height: context.height * .25,
                                width: context.width * .94,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                top: 20,
                                left: 20,
                                child: Container(
                                    width: context.width * .4,
                                    child: Text(
                                      Get.find<BannerController>()
                                          .campaignModel!
                                          .banners![index]
                                          .description!,
                                      style: robotoBold.copyWith(
                                          color: Colors.black87, fontSize: 22),
                                    ))),
                            Positioned(
                                bottom: 20,
                                left: 20,
                                child: FittedBox(
                                    child: CustomButton(
                                  buttonText: Get.find<BannerController>()
                                      .campaignModel!
                                      .banners![index]
                                      .buttonText!,
                                  onPressed: () {
                                    Get.toNamed(
                                        RouteHelper.getCategoryItemRoute(
                                      Get.find<BannerController>()
                                          .campaignModel!
                                          .banners![index]
                                          .category
                                          ?.id
                                          ?.toInt(),
                                      Get.find<BannerController>()
                                          .campaignModel!
                                          .banners![index]
                                          .category!
                                          .name!,
                                    ));
                                  },
                                  color: Color(0xff165668),
                                  width: context.width * .26,
                                  textColor: Colors.white,
                                  fontSize: 15,
                                      height: 40,
                                  radius: 9,
                                )))
                          ],
                        ),
                        options: CarouselOptions(
                          height: context.height * .25,

                          // aspectRatio: 2/1,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,

                          autoPlayInterval: Duration(seconds: 4),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.6,
                          scrollDirection: Axis.horizontal,
                        ),
                      )
                    : ItemCampaignShimmer(bannerController: bannerController),
                // SizedBox(
                //   height: 150,
                //   child: campaignController.itemCampaignList != null ? ListView.builder(
                //     controller: ScrollController(),
                //     physics: const BouncingScrollPhysics(),
                //     scrollDirection: Axis.horizontal,
                //     padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                //     itemCount: campaignController.itemCampaignList!.length > 10 ? 10 : campaignController.itemCampaignList!.length,
                //     itemBuilder: (context, index){
                //       return Padding(
                //         padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
                //         child: InkWell(
                //           onTap: () {
                //             Get.find<ItemController>().navigateToItemPage(campaignController.itemCampaignList![index], context, isCampaign: true);
                //           },
                //           child: Container(
                //             height: 150,
                //             width: 130,
                //             decoration: BoxDecoration(
                //               color: Theme.of(context).cardColor,
                //               borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                //               boxShadow: [BoxShadow(
                //                 color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 300]!,
                //                 blurRadius: 5, spreadRadius: 1,
                //               )],
                //             ),
                //             child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                //
                //               Stack(children: [
                //                 ClipRRect(
                //                   borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSmall)),
                //                   child: CustomImage(
                //                     image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}'
                //                         '/${campaignController.itemCampaignList![index].image}',
                //                     height: 90, width: 130, fit: BoxFit.cover,
                //                   ),
                //                 ),
                //                 DiscountTag(
                //                   discount: campaignController.itemCampaignList![index].storeDiscount! > 0
                //                       ? campaignController.itemCampaignList![index].storeDiscount
                //                       : campaignController.itemCampaignList![index].discount,
                //                   discountType: campaignController.itemCampaignList![index].storeDiscount! > 0 ? 'percent'
                //                       : campaignController.itemCampaignList![index].discountType,
                //                 ),
                //                 Get.find<ItemController>().isAvailable(campaignController.itemCampaignList![index])
                //                     ? const SizedBox() : const NotAvailableWidget(),
                //               ]),
                //
                //               Expanded(
                //                 child: Padding(
                //                   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                //                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                //                     Text(
                //                       campaignController.itemCampaignList![index].name!,
                //                       style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                //                       maxLines: 1, overflow: TextOverflow.ellipsis,
                //                     ),
                //                     const SizedBox(height: 2),
                //
                //                     Text(
                //                       campaignController.itemCampaignList![index].storeName!,
                //                       style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                //                       maxLines: 1, overflow: TextOverflow.ellipsis,
                //                     ),
                //                     const SizedBox(height: 2),
                //
                //                     Row(
                //                       children: [
                //                         Expanded(
                //                           child: Text(
                //                             PriceConverter.convertPrice(campaignController.itemCampaignList![index].price),
                //                             style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                //                           ),
                //                         ),
                //                         Icon(Icons.star, color: Theme.of(context).primaryColor, size: 12),
                //                         Text(
                //                           campaignController.itemCampaignList![index].avgRating!.toStringAsFixed(1),
                //                           style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                //                         ),
                //                       ],
                //                     ),
                //                   ]),
                //                 ),
                //               ),
                //
                //             ]),
                //           ),
                //         ),
                //       );
                //     },
                //   ) : ItemCampaignShimmer(campaignController: campaignController),
                // ),
              ],
            );
    });
  }
}

class ItemCampaignShimmer extends StatelessWidget {
  final BannerController bannerController;

  const ItemCampaignShimmer({Key? key, required this.bannerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * .27,
      width: context.width * .8,
      margin:
          const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: [
            BoxShadow(color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)
          ]),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: bannerController.campaignModel?.banners == null,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Dimensions.radiusSmall)),
              color: Colors.grey[300]),
        ),
      ),
    );
  }
}
