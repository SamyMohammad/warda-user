import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warda/controller/category_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/data/model/response/item_model.dart';
import 'package:warda/data/model/response/store_model.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/cart_widget.dart';
import 'package:warda/view/base/item_view.dart';
import 'package:warda/view/base/menu_drawer.dart';
import 'package:warda/view/base/veg_filter_widget.dart';
import 'package:warda/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/search_controller.dart';
import '../../base/custom_app_bar.dart';
import '../home/home_screen.dart';
import '../search/cubit/filter_cubit.dart';

class CategoryItemScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const CategoryItemScreen(
      {Key? key, required this.categoryID, required this.categoryName})
      : super(key: key);

  @override
  CategoryItemScreenState createState() => CategoryItemScreenState();
}

class CategoryItemScreenState extends State<CategoryItemScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  TabController? _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 1, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryItemList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    storeScrollController.addListener(() {
      if (storeScrollController.position.pixels ==
              storeScrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryStoreList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
            (Get.find<CategoryController>().restPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryStoreList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Item>? item;
      List<Store>? stores;
      if (catController.isSearching
          ? catController.searchItemList != null
          : catController.categoryItemList != null) {
        item = [];
        if (catController.isSearching) {
          item.addAll(catController.searchItemList!);
        } else {
          item.addAll(catController.categoryItemList!);
        }
      }
      if (catController.isSearching
          ? catController.searchStoreList != null
          : catController.categoryStoreList != null) {
        stores = [];
        if (catController.isSearching) {
          stores.addAll(catController.searchStoreList!);
        } else {
          stores.addAll(catController.categoryStoreList!);
        }
      }

      return WillPopScope(
        onWillPop: () async {
          if (catController.isSearching) {
            catController.toggleSearch();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: AppConstants.lightPinkColor,
          appBar: (ResponsiveHelper.isDesktop(context)
              ? const WebMenuBar()
              : PreferredSize(
                  preferredSize: Size(
                      context.width,
                      Platform.isIOS
                          ? context.height * 0.08
                          : context.height * 0.1),
                  child: CustomAppBar(
                    title: widget.categoryName,
                    // actions: [
                    //   Container(
                    //     alignment: Alignment.topCenter,
                    //     child: GestureDetector(
                    //       onTap: () {
                    //         Get.toNamed(RouteHelper.getSearchRoute());
                    //         BlocProvider.of<FilterCubit>(context)
                    //             .filterBottomSheet(
                    //                 Get.find<SearchingController>(),
                    //                 Get.find<CategoryController>(),
                    //                 context);
                    //       },
                    //       // child: SizedBox(
                    //       //   height: 30,
                    //       //   width: 30,
                    //       // )
                    //       child: Icon(
                    //         Icons.filter_alt,
                    //         // color: AppConstants.primaryColor,
                    //         size: 30,
                    //       ),
                    //     ),
                    //   ),
                    // ],
                    titleWidget:
                        // ? Container(
                        //     width: context.width * 0.9,
                        //     height: context.height * 0.05,
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(30)),
                        //     child: TextField(
                        //         autofocus: true,
                        //         textInputAction: TextInputAction.search,
                        //         decoration: const InputDecoration(
                        //             hintText: 'Search...',
                        //             border: InputBorder.none,
                        //             contentPadding:
                        //                 EdgeInsets.only(left: 15, bottom: 8)),
                        //         style: robotoRegular.copyWith(
                        //             fontSize: Dimensions.fontSizeLarge),
                        //         onSubmitted: (String query) {
                        //           catController.searchData(
                        //             query,
                        //             catController.subCategoryIndex == 0
                        //                 ? widget.categoryID
                        //                 : catController
                        //                     .subCategoryList![
                        //                         catController.subCategoryIndex]
                        //                     .id
                        //                     .toString(),
                        //             catController.type,
                        //           );
                        //         }),
                        //   ) : null
                        Center(
                            child: Container(
                      height: context.height * 0.04,
                      width: context.width * 0.75,
                      color: AppConstants.lightPinkColor,
                      child: InkWell(
                        onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      Colors.grey[Get.isDarkMode ? 800 : 200]!,
                                  spreadRadius: 1,
                                  offset: Offset(1, 1),
                                  blurRadius: 5)
                            ],
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  Icons.search,
                                  size: 23,
                                  color: Colors.grey,
                                ),
                              ]),
                        ),
                      ),
                    )),
                    showLogo: true,
                    backButton: true,
                    onBackPressed: () {
                      if (catController.isSearching) {
                        catController.toggleSearch();
                      } else {
                        Get.back();
                      }
                    },
                    // actions: [
                    //   catController.isSearching
                    //       ? const SizedBox()
                    //       : GestureDetector(
                    //           onTap: () => catController.toggleSearch(),
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    //             child: Center(
                    //               child: Icon(
                    //                 catController.isSearching
                    //                     ? Icons.close_sharp
                    //                     : Icons.search,
                    //                 size: 25,
                    //                 color: Theme.of(context)
                    //                     .textTheme
                    //                     .bodyLarge!
                    //                     .color,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    // ],
                  ))),
          endDrawer: const MenuDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: Center(
              child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(children: [
              (catController.subCategoryList != null &&
                      !catController.isSearching)
                  ? Center(
                      child: Container(
                      height: 40,
                      width: Dimensions.webMaxWidth,
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: ListView.builder(
                        key: scaffoldKey,
                        scrollDirection: Axis.horizontal,
                        itemCount: catController.subCategoryList!.length,
                        padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeSmall),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => catController.setSubCategoryIndex(
                                index, widget.categoryID),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.paddingSizeExtraSmall),
                              margin: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                color: index == catController.subCategoryIndex
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1)
                                    : Colors.transparent,
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      catController
                                          .subCategoryList![index].name!,
                                      style: index ==
                                              catController.subCategoryIndex
                                          ? robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .primaryColor)
                                          : robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                    ),
                                  ]),
                            ),
                          );
                        },
                      ),
                    ))
                  : const SizedBox(),
              Expanded(
                  child: NotificationListener(
                onNotification: (dynamic scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    if ((_tabController!.index == 1 &&
                            !catController.isStore) ||
                        _tabController!.index == 0 && catController.isStore) {
                      catController.setRestaurant(_tabController!.index == 1);
                      if (catController.isSearching) {
                        catController.searchData(
                          catController.searchText,
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                                  .subCategoryList![
                                      catController.subCategoryIndex]
                                  .id
                                  .toString(),
                          catController.type,
                        );
                      } else {
                        if (_tabController!.index == 1) {
                          catController.getCategoryStoreList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList![
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            catController.type,
                            false,
                          );
                        } else {
                          catController.getCategoryItemList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList![
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            catController.type,
                            false,
                          );
                        }
                      }
                    }
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: ItemsView(
                    isStore: false,
                    items: item,
                    stores: null,
                    noDataText: 'no_category_item_found'.tr,
                  ),
                ),
              )),
              catController.isLoading
                  ? Center(
                      child: Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    ))
                  : const SizedBox(),
            ]),
          )),
        ),
      );
    });
  }
}
