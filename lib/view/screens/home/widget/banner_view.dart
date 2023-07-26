import 'package:carousel_slider/carousel_slider.dart';
import 'package:warda/controller/banner_controller.dart';
import 'package:warda/controller/item_controller.dart';
import 'package:warda/controller/location_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/data/model/response/basic_campaign_model.dart';
import 'package:warda/data/model/response/item_model.dart';
import 'package:warda/data/model/response/module_model.dart';
import 'package:warda/data/model/response/store_model.dart';
import 'package:warda/data/model/response/zone_response_model.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/view/base/custom_image.dart';
import 'package:warda/view/base/custom_snackbar.dart';
import 'package:warda/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BannerView extends StatelessWidget {
  final bool isFeatured;
  const BannerView({Key? key, required this.isFeatured}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      List<String?>? bannerList = isFeatured
          ? bannerController.featuredBannerList
          : bannerController.bannerImageList;
      List<dynamic>? bannerDataList = isFeatured
          ? bannerController.featuredBannerDataList
          : bannerController.bannerDataList;
      return (bannerList != null && bannerList.isEmpty)
          ? const SizedBox()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: GetPlatform.isDesktop ? 500 : context.height * 0.25,
              // color: Colors.red,
              padding:
                  const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
              child: bannerList != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: context.width * 0.9,
                            height: context.height * 0.22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ListView.builder(
                                itemCount: bannerDataList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      if (bannerDataList?[index] is Item) {
                                        Item? item = bannerDataList?[index];
                                        Get.find<ItemController>()
                                            .navigateToItemPage(item, context);
                                      } else if (bannerDataList?[index]
                                          is Store) {
                                        Store? store = bannerDataList?[index];
                                        if (isFeatured &&
                                            (Get.find<LocationController>()
                                                        .getUserAddress()!
                                                        .zoneData !=
                                                    null &&
                                                Get.find<LocationController>()
                                                    .getUserAddress()!
                                                    .zoneData!
                                                    .isNotEmpty)) {
                                          for (ModuleModel module
                                              in Get.find<SplashController>()
                                                  .moduleList!) {
                                            if (module.id == store!.moduleId) {
                                              Get.find<SplashController>()
                                                  .setModule(module);
                                              break;
                                            }
                                          }
                                          ZoneData zoneData =
                                              Get.find<LocationController>()
                                                  .getUserAddress()!
                                                  .zoneData!
                                                  .firstWhere((data) =>
                                                      data.id == store!.zoneId);

                                          Modules module = zoneData.modules!
                                              .firstWhere((module) =>
                                                  module.id == store!.moduleId);
                                          Get.find<SplashController>()
                                              .setModule(ModuleModel(
                                                  id: module.id,
                                                  moduleName: module.moduleName,
                                                  moduleType: module.moduleType,
                                                  themeId: module.themeId,
                                                  storesCount:
                                                      module.storesCount));
                                        }
                                        Get.toNamed(
                                          RouteHelper.getStoreRoute(store!.id,
                                              isFeatured ? 'module' : 'banner'),
                                          arguments: StoreScreen(
                                              store: store,
                                              fromModule: isFeatured),
                                        );
                                      } else if (bannerDataList?[index]
                                          is BasicCampaignModel) {
                                        BasicCampaignModel campaign =
                                            bannerDataList?[index];
                                        Get.toNamed(
                                            RouteHelper.getBasicCampaignRoute(
                                                campaign));
                                      } else {
                                        String url =
                                            bannerDataList?[index] ?? '';
                                        if (await canLaunchUrlString(url)) {
                                          await launchUrlString(url,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } else {
                                          showCustomSnackBar(
                                              'unable_to_found_url'.tr);
                                        }
                                      }
                                    },
                                    child: Container(
                                        height: context.height * 0.2,
                                        width: context.width * 0.9,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(20)),
                                          clipBehavior: Clip.antiAlias,
                                          child: CustomImage(
                                            image: '${bannerList[index]}',
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    // child: ClipRRect(
                                    //   child: Container(
                                    //     color: Colors.red,
                                    //   ),

                                    // CustomImage(
                                    //   image: '${bannerList[index]}',
                                    // height: context.height * 0.2,
                                    // width: context.width * 0.9,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    //)
                                  );
                                })),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerList.map((bnr) {
                            int index = bannerList.indexOf(bnr);
                            return Container(
                              width: 30,
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: index == bannerController.currentIndex
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: bannerList == null,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            color: Colors.grey[300],
                          )),
                    ),
            );
    });
  }
}
