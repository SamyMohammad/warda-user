import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:warda/controller/search_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/screens/search/widget/filter_widget.dart';
import 'package:warda/view/screens/search/widget/item_view.dart';
import 'package:get/get.dart';

import '../../../../controller/category_controller.dart';
import '../../../../data/model/response/occasion_model.dart';
import '../../../base/custom_button.dart';
import '../cubit/filter_cubit.dart';

class SearchResultWidget extends StatefulWidget {
  final String searchText;
  const SearchResultWidget({Key? key, required this.searchText})
      : super(key: key);

  @override
  SearchResultWidgetState createState() => SearchResultWidgetState();
}

class SearchResultWidgetState extends State<SearchResultWidget>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<FilterCubit>(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GetBuilder<CategoryController>(builder: (categoryController) {
        return GetBuilder<SearchingController>(builder: (searchController) {
          bool isNull = true;
          int length = 0;
          isNull = searchController.searchItemList == null;
          if (!isNull) {
            length = searchController.searchItemList!.length;
          }

          return isNull
              ? const SizedBox()
              : Center(
                  child: SizedBox(
                      width: Dimensions.webMaxWidth,
                      child: Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Row(children: [
                          Text(
                            length.toString(),
                            style: robotoBold.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          Expanded(
                              child: Text(
                            'results_found'.tr,
                            style: robotoRegular.copyWith(
                                color: Theme.of(context).disabledColor,
                                fontSize: Dimensions.fontSizeSmall),
                          )),
                          // widget.searchText.isNotEmpty
                          //     ? InkWell(
                          //         onTap: () {
                          //           // Get.dialog(FilterWidget(
                          //           //     maxValue: maxValue,
                          //           //     isStore: Get.find<SearchingController>()
                          //           //         .isStore));
                          //           cubit.filterBottomSheet(searchController,
                          //               categoryController, context);
                          //         },
                          //         child: const Icon(Icons.filter_list),
                          //       )
                          //     : const SizedBox(),
                        ]),
                      )));
        });
      }),
      Center(
          child: Container(
        width: Dimensions.webMaxWidth,
        color: Theme.of(context).cardColor,
        // child: TabBar(
        //   controller: _tabController,
        //   indicatorColor: Theme.of(context).primaryColor,
        //   indicatorWeight: 3,
        //   labelColor: Theme.of(context).primaryColor,
        //   unselectedLabelColor: Theme.of(context).disabledColor,
        //   unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
        //   labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
        //   tabs: [
        //     Tab(text: 'item'.tr),
        //     Tab(text: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
        //         ? 'restaurants'.tr : 'stores'.tr),
        //   ],
        // ),
      )),
      Expanded(
          child: NotificationListener(
              onNotification: (dynamic scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  BlocProvider.of<FilterCubit>(context).search();
                }
                return false;
              },
              child: const ItemView(isItem: false))),
    ]);
  }
}
