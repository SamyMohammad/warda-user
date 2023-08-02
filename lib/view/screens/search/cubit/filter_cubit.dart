import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../../../controller/category_controller.dart';
import '../../../../controller/search_controller.dart';
import '../../../../data/model/response/occasion_model.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';

import '../../../../data/model/response/sizes_model.dart' as sizeModel;
part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());
  int? selectedCategoryId;
  int? selectedOccasionId;
  int? selectedSizeId;
  double? minumimPrice;
  double? maximumPrice;
  final TextEditingController searchController = TextEditingController();

  changeCategoryId(int newCategoryId) {
    emit(FilterLoading());
    selectedCategoryId = newCategoryId;
    emit(FilterInitial());
  }

  changeOccasionId(int? occasionId) {
    emit(FilterLoading());
    selectedOccasionId = occasionId;
    emit(FilterInitial());
  }

  changeSizeId(int? sizeId) {
    emit(FilterLoading());
    selectedSizeId = sizeId;
    emit(FilterInitial());
  }

  search() {
    String? searchText = searchController.text;
    Get.find<SearchingController>().searchData(searchText, false,
        categoryId: selectedCategoryId,
        sizeId: selectedSizeId,
        occationId: selectedOccasionId);
  }

  clearFilter() {
    emit(FilterLoading());
    selectedCategoryId = null;
    selectedOccasionId = null;
    selectedSizeId = null;
    emit(FilterInitial());
  }

  filterBottomSheet(SearchingController searchController,
      CategoryController categoryController, BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      expand: true,
      builder: (context) => BlocBuilder<FilterCubit, FilterState>(
        builder: (context, state) {
          var cubit = BlocProvider.of<FilterCubit>(context);

          return SafeArea(
            child: Stack(
              children: [
                Container(
                  width: context.width,
                  height: context.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                      AppConstants.primaryColor.withOpacity(0.1),
                      Colors.white,
                      // AppConstants.primaryColor
                    ],
                  )),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        height: context.height,
                        width: context.width,
                        padding: EdgeInsets.symmetric(
                            horizontal: context.width * 0.03),
                        // color: Colors.white.withOpacity(0.8),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    searchController.resetFilter();
                                    cubit.clearFilter();
                                  },
                                  child: Text(
                                    'clear'.tr,
                                    style: robotoRegular.copyWith(
                                        color: AppConstants.greenColor,
                                        fontSize: 14),
                                  ),
                                ),
                                Text(
                                  'filter'.tr,
                                  style: robotoMedium.copyWith(fontSize: 18),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.highlight_off_outlined,
                                      color: AppConstants.primaryColor,
                                    ))
                              ],
                            ),
                            const Divider(
                              height: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'categories'.tr,
                                  style: robotoMedium.copyWith(fontSize: 16),
                                ),
                                SizedBox(
                                  height: context.height * 0.02,
                                ),
                                Container(
                                  height: context.height * 0.05,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: categoryController
                                          .categoryList?.length,
                                      itemBuilder: (context, index) {
                                        int categoryId = categoryController
                                                .categoryList?[index].id ??
                                            0;

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              cubit
                                                  .changeCategoryId(categoryId);
                                            },
                                            child: Container(
                                              height: context.height * 0.05,
                                              margin: const EdgeInsets.only(
                                                  right: 12),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: categoryId ==
                                                          cubit
                                                              .selectedCategoryId
                                                      ? AppConstants
                                                          .primaryColor
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4),
                                                child: Center(
                                                  child: Text(
                                                    categoryController
                                                            .categoryList?[
                                                                index]
                                                            .name ??
                                                        '',
                                                    style: robotoRegular.copyWith(
                                                        color: categoryId ==
                                                                cubit
                                                                    .selectedCategoryId
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                SizedBox(
                                  height: context.height * 0.04,
                                ),
                              ],
                            ),
                            const Divider(
                              height: 8,
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'occasion'.tr,
                                    style: robotoMedium.copyWith(fontSize: 16),
                                  ),
                                  GridView.builder(
                                    itemCount:
                                        searchController.occasionList?.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 1.7,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 3),
                                    //searchController.occasionList?.length,
                                    itemBuilder: (context, index) {
                                      // int index = 0;
                                      Occasion occasion =
                                          searchController.occasionList![index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: SizedBox(
                                            child: Container(
                                                child: GestureDetector(
                                                    onTap: () {},
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                              height: 24.0,
                                                              width: 24.0,
                                                              child: Checkbox(
                                                                  value: cubit
                                                                          .selectedOccasionId ==
                                                                      occasion
                                                                          .id,
                                                                  onChanged:
                                                                      (value) {
                                                                    if (value!) {
                                                                      cubit.changeOccasionId(
                                                                          occasion
                                                                              .id);
                                                                    } else {
                                                                      cubit.changeOccasionId(
                                                                          null);
                                                                    }
                                                                  })),
                                                          const SizedBox(
                                                              width: 10.0),
                                                          Text(
                                                            occasion.name,
                                                            style:
                                                                robotoRegular,
                                                          )
                                                        ])))),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: context.height * 0.02,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 8,
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: Text(
                                      'size'.tr,
                                      style:
                                          robotoMedium.copyWith(fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    child: GridView.builder(
                                      itemCount:
                                          searchController.sizeList?.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              childAspectRatio: 1.7,
                                              mainAxisSpacing: 5,
                                              crossAxisSpacing: 3),
                                      //searchController.occasionList?.length,
                                      itemBuilder: (context, index) {
                                        // int index = 0;
                                        sizeModel.Size size =
                                            searchController.sizeList![index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: SizedBox(
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                SizedBox(
                                                    height: 24.0,
                                                    width: 24.0,
                                                    child: Checkbox(
                                                        value: cubit
                                                                .selectedSizeId ==
                                                            size.id,
                                                        onChanged: (value) {
                                                          if (value!) {
                                                            cubit.changeSizeId(
                                                                size.id);
                                                          } else {
                                                            cubit.changeSizeId(
                                                                null);
                                                          }
                                                        })),
                                                const SizedBox(width: 10.0),
                                                Text(
                                                  size.name,
                                                  style: robotoRegular,
                                                )
                                              ])),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: context.height * 0.02,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: context.height * 0.04,
                            ),
                            CustomButton(
                              onPressed: () {
                                cubit.search();
                                Navigator.pop(context);
                              },
                              buttonText: 'apply_filter'.tr,
                              radius: 30,
                            ),
                            SizedBox(
                              height: context.height * 0.04,
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
