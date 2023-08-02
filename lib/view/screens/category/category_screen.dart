import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'
    as staggeredGridview;
import 'package:warda/controller/category_controller.dart';
import 'package:warda/controller/search_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/custom_app_bar.dart';
import 'package:warda/view/base/custom_image.dart';
import 'package:warda/view/base/footer_view.dart';
import 'package:warda/view/base/menu_drawer.dart';
import 'package:warda/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/app_constants.dart';
import '../search/cubit/filter_cubit.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key, this.fromNav = false}) : super(key: key);
  final bool fromNav;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    Get.find<CategoryController>().getCategoryList(false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(context.width, context.height * 0.12),
        child: CustomAppBar(
          title: 'categories'.tr,
          showLogo: true,
          backButton: !widget.fromNav,
          actions: [
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.getSearchRoute());
                BlocProvider.of<FilterCubit>(context).filterBottomSheet(
                    Get.find<SearchingController>(),
                    Get.find<CategoryController>(),
                    context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.filter_alt, color: AppConstants.primaryColor),
              ),
            ),
          ],
        ),
      ),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: Center(
        child: SafeArea(
            child: Container(
          width: context.width * 0.95,
          alignment: Alignment.center,
          child: Scrollbar(
              child: SingleChildScrollView(
                  child: FooterView(
                      child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Container(
              child: GetBuilder<CategoryController>(builder: (catController) {
                return catController.categoryList != null
                    ? catController.categoryList!.isNotEmpty
                        ? staggeredGridview.StaggeredGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            children: List.generate(
                                catController.categoryList!.length, (index) {
                              int indexFakeData = index;
                              return staggeredGridview.StaggeredGridTile.count(
                                crossAxisCellCount: (((index + 1) % 3 == 0 &&
                                                (index + 2) % 4 == 0) ||
                                            ((index + 1) % 4 == 0 &&
                                                (index) % 3 == 0)) ||
                                        ((index + 2) % 4 == 0 &&
                                            (index) % 3 == 0) ||
                                        ((index + 1) % 4 == 0 &&
                                            (index - 1) % 3 == 0) ||
                                        ((index + 2) % 4 == 0 &&
                                            (index - 1) % 3 == 0) ||
                                        ((index + 1) % 4 == 0 &&
                                            (index - 2) % 3 == 0)
                                    ? 1
                                    : 2,
                                mainAxisCellCount: 1.1,
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  width: context.width * 0.8,
                                  height: context.height * 0.1,
                                  child: InkWell(
                                    onTap: () => Get.toNamed(
                                        RouteHelper.getCategoryItemRoute(
                                      catController
                                          .categoryList![indexFakeData].id,
                                      catController
                                          .categoryList![indexFakeData].name!,
                                    )),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).hintColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[
                                                  Get.isDarkMode ? 800 : 200]!,
                                              blurRadius: 5,
                                              spreadRadius: 1)
                                        ],
                                        // image: DecorationImage(
                                        //     onError: (exception, stackTrace) {},
                                        //     image: NetworkImage(
                                        //         '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${catController.categoryList![indexFakeData].image}')
                                      ),
                                      alignment: Alignment.center,
                                      child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusSmall),
                                              child: CustomImage(
                                                fit: BoxFit.cover,
                                                width: context.width,
                                                height: context.height * 0.255,
                                                image:
                                                    '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${catController.categoryList![indexFakeData].image}',
                                              ),
                                            ),
                                            Text(
                                              catController
                                                  .categoryList![indexFakeData]
                                                  .name!,
                                              textAlign: TextAlign.center,
                                              style: wardaRegular.copyWith(
                                                  fontSize: 30,
                                                  color: Colors.white),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          )
                        : NoDataScreen(text: 'no_category_found'.tr)
                    : const Center(child: CircularProgressIndicator());
              }),
            ),
          )))),
        )),
      ),
    );
  }
}
