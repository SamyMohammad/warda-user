import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../../../controller/category_controller.dart';
import '../../../../controller/search_controller.dart';
import '../../../../data/model/response/category_model.dart';
import '../../../../data/model/response/flower_colors_model.dart';
import '../../../../data/model/response/flower_types_model.dart';
import '../../../../data/model/response/occasion_model.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';

import '../../../../data/model/response/sizes_model.dart';
part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());
  int? selectedCategoryId;
  int? selectedOccasionId;
  int? selectedSizeId;
  double? minumimPrice;
  double? maximumPrice;
  final TextEditingController searchController = TextEditingController();

  List<Occasion> occasionListSelected = [];
  List<SizeItem> sizeListSelected = [];
  List<FlowerType> flowerTypeListSelected = [];
  List<FlowerColor> flowerColorListSelected = [];
  List<CategoryModel> categoryListSelected = [];

  showBottomSheet(
      {required BuildContext context,
      required String title,
      required Function()? onTapConfirm,
      required dynamic itemList,
      bool multiSelection = true}) {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusDefault),
          topRight: Radius.circular(Dimensions.radiusDefault),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setState) {
          bool isCategory = title.toLowerCase() == 'category';
          bool isFlowerType = title.toLowerCase() == 'flower';
          bool isFlowerColor = title.toLowerCase() == 'color';
          bool isOccasion = title.toLowerCase() == 'occasion';
          bool isSize = title.toLowerCase() == 'size';
          return Container(
            height: context.height * 0.5,
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeSmall,
                horizontal: Dimensions.paddingSizeDefault),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: robotoBlack.copyWith(
                            fontSize: 19, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            emit(FilterLoading());
                            emit(FilterInitial());
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),

                  //items
                  SizedBox(
                    height: context.height * 0.32,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          String itemName = '';
                          bool itemSelected = false;
                          var element = itemList[index];
                          // bool isCategory = title.toLowerCase() == 'category';
                          // bool isFlowerType = title.toLowerCase() == 'flower';
                          // bool isFlowerColor = title.toLowerCase() == 'color';
                          // bool isOccasion = title.toLowerCase() == 'occasion';
                          // bool isSize = title.toLowerCase() == 'size';

                          if (isCategory) {
                            itemList = itemList as List<CategoryModel>?;
                            itemName = itemList[index].name ?? '';
                            itemSelected =
                                categoryListSelected.contains(element);
                          } else if (isOccasion) {
                            itemName = itemList[index].name ?? '';
                            itemSelected =
                                occasionListSelected.contains(element);
                          } else if (isFlowerColor) {
                            itemName = itemList[index].color ?? '';
                            itemSelected =
                                flowerColorListSelected.contains(element);
                          } else if (isFlowerType) {
                            itemName = itemList[index].type ?? '';
                            itemSelected =
                                flowerTypeListSelected.contains(element);
                          } else if (isSize) {
                            itemName = itemList[index].name ?? '';
                            itemSelected = sizeListSelected.contains(element);
                          }

                          return Container(
                              alignment: Alignment.centerLeft,
                              // ignore: prefer_const_constructors
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeSmall),
                              child: isCategory
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          filterItemClicked(title, element);
                                        });
                                      },
                                      child: SizedBox(
                                        width: context.width,
                                        child: Text(
                                          itemName,
                                          style: itemSelected
                                              ? robotoRegular.copyWith(
                                                  fontWeight: FontWeight.bold)
                                              : robotoRegular,
                                        ),
                                      ),
                                    )
                                  : CheckboxListTile(
                                      value: itemSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          filterItemClicked(title, element);
                                        });
                                      },
                                      title: Text(
                                        itemName,
                                        style: itemSelected
                                            ? robotoRegular.copyWith(
                                                fontWeight: FontWeight.bold)
                                            : robotoRegular,
                                      )));
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: itemList.length),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          emit(FilterLoading());
                          setState(() {
                            if (isCategory) {
                              categoryListSelected.clear();
                            } else if (isOccasion) {
                              occasionListSelected.clear();
                            } else if (isFlowerColor) {
                              flowerColorListSelected.clear();
                            } else if (isFlowerType) {
                              flowerTypeListSelected.clear();
                            } else if (isSize) {
                              sizeListSelected.clear();
                            }
                          });
                          emit(FilterInitial());
                        },
                        child: Container(
                          width: context.width * 0.45,
                          height: context.height * 0.07,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            border:
                                Border.all(color: AppConstants.primaryColor),
                          ),
                          child: Center(
                              child: Text(
                            'Clear all',
                            style: robotoRegular.copyWith(
                                fontWeight: FontWeight.w300),
                          )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          search();
                        },
                        child: Container(
                          width: context.width * 0.45,
                          height: context.height * 0.07,
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSmall),
                            border:
                                Border.all(color: AppConstants.primaryColor),
                          ),
                          child: Center(
                              child: Text(
                            'Confirm',
                            style: robotoRegular.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context).cardColor),
                          )),
                        ),
                      ),
                    ],
                  )
                ]),
          );
        },
      ),
    );
  }

  filterItemClicked(String title, dynamic element) {
    bool isCategory = title.toLowerCase() == 'category';
    bool isFlowerType = title.toLowerCase() == 'flower';
    bool isFlowerColor = title.toLowerCase() == 'color';
    bool isOccasion = title.toLowerCase() == 'occasion';
    bool isSize = title.toLowerCase() == 'size';
    if (isCategory) {
      if (categoryListSelected.contains(element)) {
        categoryListSelected.remove(element);
      } else {
        categoryListSelected.add(element);
      }
    } else if (isOccasion) {
      if (occasionListSelected.contains(element)) {
        occasionListSelected.remove(element);
      } else {
        occasionListSelected.add(element);
      }
    } else if (isFlowerColor) {
      if (flowerColorListSelected.contains(element)) {
        flowerColorListSelected.remove(element);
      } else {
        flowerColorListSelected.add(element);
      }
    } else if (isSize) {
      print('hello i just clicked');
      if (sizeListSelected.contains(element)) {
        sizeListSelected.remove(element);
      } else {
        sizeListSelected.add(element);
      }
    } else if (isFlowerType) {
      if (flowerTypeListSelected.contains(element)) {
        flowerTypeListSelected.remove(element);
      } else {
        flowerTypeListSelected.add(element);
      }
    }
    emit(FilterLoading());
    emit(FilterInitial());
  }

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
    List<int> categoryIds = [];
    List<int> occasionIds = [];
    List<int> colorIds = [];
    List<int> typeIds = [];
    List<int> sizeIds = [];
    for (var element in categoryListSelected) {
      categoryIds.add(element.id ?? 0);
    }
    for (var element in occasionListSelected) {
      occasionIds.add(element.id);
    }
    for (var element in flowerColorListSelected) {
      colorIds.add(element.id);
    }
    for (var element in flowerTypeListSelected) {
      typeIds.add(element.id);
    }
    for (var element in sizeListSelected) {
      sizeIds.add(element.id);
    }
    Get.find<SearchingController>().searchData(searchText, false,
        categoryIds: categoryIds,
        sizeIds: sizeIds,
        occationIds: occasionIds,
        flowerColorIds: colorIds,
        flowerTypeIds: typeIds);
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
      backgroundColor: Colors.white,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                SizedBox(
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
                                        SizeItem size =
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
                            Platform.isIOS
                                ? SizedBox(
                                    height: context.height * 0.07,
                                  )
                                : const SizedBox(),
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
