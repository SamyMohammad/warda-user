import 'package:warda/controller/category_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/custom_image.dart';
import 'package:warda/view/base/title_widget.dart';
import 'package:warda/view/screens/home/widget/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../util/app_constants.dart';
import '../../../../util/images.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return (categoryController.categoryList != null &&
              categoryController.categoryList!.isEmpty)
          ? const SizedBox()
          : Padding(
              padding: EdgeInsets.only(left: context.width * 0.065),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: context.width * 0.075),
                    child: TitleWidget(
                        title: 'categories'.tr,
                        onTap: () =>
                            Get.toNamed(RouteHelper.getCategoryRoute())),
                  ),
                  SizedBox(
                    height: context.height * 0.015,
                  ),
                  Container(
                    // color: Colors.teal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: context.width * 0.26,
                            child: categoryController.categoryList != null
                                ? ListView.separated(
                              separatorBuilder:  (context, index)=>SizedBox(width: context.width*.07 ,),
                                    controller: scrollController,
                                    itemCount: categoryController
                                                .categoryList!.length >
                                            15
                                        ? 15
                                        : categoryController
                                            .categoryList!.length,
                                    // padding: const EdgeInsets.only(
                                    //     left: Dimensions.paddingSizeSmall),
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      //index = 0;
                                      return InkWell(
                                        onTap: () => Get.toNamed(
                                            RouteHelper.getCategoryItemRoute(
                                          categoryController
                                              .categoryList![index].id,
                                          categoryController
                                              .categoryList![index].name!,
                                        )),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: context.width * 0.13,
                                                width: context.width * 0.13,
                                                decoration: const BoxDecoration(
                                                    color: AppConstants
                                                        .lightPinkColor,
                                                    shape: BoxShape.circle),
                                                // margin: const EdgeInsets
                                                //     .symmetric(horizontal: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          400),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Image.network(
                                                      '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList?[index].image}',
                                                      fit: BoxFit.contain,
                                                      errorBuilder: ((context,
                                                          error, stackTrace) {
                                                        return Image.asset(
                                                            Images.logoColor);
                                                      }),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Container(
                                                height: context.width * 0.08,
                                                // width: context.width * 0.4,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  categoryController
                                                          .categoryList?[
                                                              index]
                                                          .name ??
                                                      '',
                                                  style:
                                                      robotoRegular.copyWith(
                                                          fontSize: 11,
                                                          fontFamily:
                                                              'Poppins',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Theme.of(
                                                                  context)
                                                              .hintColor),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ]),
                                      );
                                    },
                                  )
                                : CategoryShimmer(
                                    categoryController: categoryController),
                          ),
                        ),
                        ResponsiveHelper.isMobile(context)
                            ? const SizedBox()
                            : categoryController.categoryList != null
                                ? Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (con) => Dialog(
                                                  child: SizedBox(
                                                      height: 550,
                                                      width: 600,
                                                      child: CategoryPopUp(
                                                        categoryController:
                                                            categoryController,
                                                      ))));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right:
                                                  Dimensions.paddingSizeSmall),
                                          child: CircleAvatar(
                                            radius: 35,
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            child: Text('view_all'.tr,
                                                style: TextStyle(
                                                    fontSize: Dimensions
                                                        .paddingSizeDefault,
                                                    color: Theme.of(context)
                                                        .cardColor)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  )
                                : CategoryAllShimmer(
                                    categoryController: categoryController)
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const CategoryShimmer({Key? key, required this.categoryController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 14,
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: categoryController.categoryList == null,
              child: Column(children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
                const SizedBox(height: 5),
                Container(height: 10, width: 50, color: Colors.grey[300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const CategoryAllShimmer({Key? key, required this.categoryController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: categoryController.categoryList == null,
          child: Column(children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),
            const SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}
