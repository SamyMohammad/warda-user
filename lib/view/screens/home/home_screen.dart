import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warda/controller/auth_controller.dart';
import 'package:warda/controller/banner_controller.dart';
import 'package:warda/controller/campaign_controller.dart';
import 'package:warda/controller/category_controller.dart';
import 'package:warda/controller/location_controller.dart';
import 'package:warda/controller/notification_controller.dart';
import 'package:warda/controller/item_controller.dart';
import 'package:warda/controller/parcel_controller.dart';
import 'package:warda/controller/store_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/controller/user_controller.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/images.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/item_view.dart';
import 'package:warda/view/base/menu_drawer.dart';
import 'package:warda/view/base/paginated_list_view.dart';
import 'package:warda/view/base/web_menu_bar.dart';
import 'package:warda/view/screens/home/theme1/theme1_home_screen.dart';
import 'package:warda/view/screens/home/web_home_screen.dart';
import 'package:warda/view/screens/home/widget/discount_widget.dart';
import 'package:warda/view/screens/home/widget/filter_view.dart';
import 'package:warda/view/screens/home/widget/popular_item_view.dart';
import 'package:warda/view/screens/home/widget/item_campaign_view.dart';
import 'package:warda/view/screens/home/widget/popular_store_view.dart';
import 'package:warda/view/screens/home/widget/banner_view.dart';
import 'package:warda/view/screens/home/widget/category_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warda/view/screens/home/widget/module_view.dart';
import 'package:warda/view/screens/location/cubit/location_cubit.dart';
import 'package:warda/view/screens/parcel/parcel_category_screen.dart';

import '../../../controller/order_controller.dart';
import '../../../controller/search_controller.dart';
import '../../../controller/wishlist_controller.dart';
import '../../../util/app_constants.dart';
import '../search/cubit/filter_cubit.dart';
import '../search/widget/search_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Future<void> loadData(bool reload) async {
    //Get.find<LocationController>().syncZoneData();
    if (Get.find<SplashController>().module != null &&
        !Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<BannerController>().getBannerList(reload);
      //Get.find<LocationController>().syncZoneData();
      Get.find<CategoryController>().getCategoryList(reload);
      //Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      // Get.find<CampaignController>().getItemCampaignList(reload);
      // Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      // Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
      //   Get.find<StoreController>().getStoreList(1, reload);
      Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      Get.find<ItemController>().getDiscountItemList(true, 'all', false);
    }
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
    }
    Get.find<SplashController>().getModules();
    if (Get.find<SplashController>().module == null &&
        Get.find<SplashController>().configModel!.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<LocationController>().getAddressList();
      }
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<SearchingController>().getOccasionFilter();
    Get.find<SearchingController>().getFlowerColorsFilter();
    Get.find<SearchingController>().getFlowerTypesFilter();
    Get.find<SearchingController>().getSizesFilter();
    Get.find<SearchingController>().getFAQ();
    Get.find<WishListController>().getWishList();

    Get.find<OrderController>().getPaymentMethods();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HomeScreen.loadData(true);
      if (!ResponsiveHelper.isWeb()) {
        Get.find<LocationController>().getZone(false, updateInAddress: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      bool showMobileModule = !ResponsiveHelper.isDesktop(context) &&
          splashController.module == null &&
          splashController.configModel!.module == null;
      bool isParcel = splashController.module != null &&
          splashController.configModel!.moduleConfig!.module!.isParcel!;
      // bool isTaxiBooking = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isTaxi!;

      return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: ResponsiveHelper.isDesktop(context)
            ? Theme.of(context).cardColor
            : splashController.module == null
                ? Theme.of(context).colorScheme.background
                : null,
        body: /*isTaxiBooking ? const RiderHomeScreen() :*/
            GetBuilder<CategoryController>(builder: (categoryController) {
          return GetBuilder<SearchingController>(builder: (searchController) {
            return isParcel
                ? const ParcelCategoryScreen()
                : SafeArea(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        Get.find<SearchingController>().getOccasionFilter();
                        Get.find<SearchingController>().getFlowerColorsFilter();
                        Get.find<SearchingController>().getFlowerTypesFilter();
                        Get.find<SearchingController>().getSizesFilter();
                        if (Get.find<SplashController>().module != null) {
                          await Get.find<BannerController>()
                              .getBannerList(true);
                          //await Get.find<LocationController>().syncZoneData();
                          await Get.find<CategoryController>()
                              .getCategoryList(true);
                          // await Get.find<StoreController>()
                          //     .getPopularStoreList(true, 'all', false);
                          // await Get.find<CampaignController>()
                          //     .getItemCampaignList(true);
                          await Get.find<ItemController>()
                              .getPopularItemList(true, 'all', false);

                          await Get.find<ItemController>()
                              .getDiscountItemList(true, 'all', false);
                          // await Get.find<StoreController>()
                          //     .getLatestStoreList(true, 'all', false);
                          // await Get.find<ItemController>()
                          //     .getReviewedItemList(true, 'all', false);
                          // await Get.find<StoreController>()
                          //     .getStoreList(1, true);
                          if (Get.find<AuthController>().isLoggedIn()) {
                            await Get.find<UserController>().getUserInfo();
                            await Get.find<NotificationController>()
                                .getNotificationList(true);
                          }
                        } else {
                          await Get.find<BannerController>()
                              .getFeaturedBanner();
                          await Get.find<SplashController>().getModules();
                          if (Get.find<AuthController>().isLoggedIn()) {
                            await Get.find<LocationController>()
                                .getAddressList();
                          }
                          await Get.find<StoreController>()
                              .getFeaturedStoreList();
                        }
                      },
                      child: ResponsiveHelper.isDesktop(context)
                          ? WebHomeScreen(
                              scrollController: _scrollController,
                            )
                          : (Get.find<SplashController>().module != null &&
                                  Get.find<SplashController>()
                                          .module!
                                          .themeId ==
                                      2)
                              ? Theme1HomeScreen(
                                  scrollController: _scrollController,
                                  splashController: splashController,
                                  showMobileModule: showMobileModule,
                                )
                              : CustomScrollView(
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    // App Bar
                                    SliverAppBar(
                                      floating: true,
                                      elevation: 0,
                                      automaticallyImplyLeading: false,
                                      backgroundColor:
                                          ResponsiveHelper.isDesktop(context)
                                              ? Colors.transparent
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                      title: Center(
                                          child: Container(
                                        width: Dimensions.webMaxWidth,
                                        height: 50,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              (splashController.module !=
                                                          null &&
                                                      splashController
                                                              .configModel!
                                                              .module ==
                                                          null)
                                                  ? InkWell(
                                                      onTap: () =>
                                                          splashController
                                                              .removeModule(),
                                                      child: Image.asset(
                                                          Images.moduleIcon,
                                                          height: 22,
                                                          width: 22,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(
                                                  width: (splashController
                                                                  .module !=
                                                              null &&
                                                          splashController
                                                                  .configModel!
                                                                  .module ==
                                                              null)
                                                      ? Dimensions
                                                          .paddingSizeExtraSmall
                                                      : 0),
                                              Image.asset(
                                                Images.logoColor,
                                                alignment: Alignment.centerLeft,
                                                width: context.width * 0.35,
                                                height: context.height * 0.03,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              InkWell(
                                                onTap: () => Get.find<
                                                        LocationController>()
                                                    .navigateToLocationScreen(
                                                        'home'),
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: Dimensions
                                                          .paddingSizeSmall,
                                                      horizontal: ResponsiveHelper
                                                              .isDesktop(
                                                                  context)
                                                          ? Dimensions
                                                              .paddingSizeSmall
                                                          : 0,
                                                    ),
                                                    child: BlocBuilder<
                                                        LocationCubit,
                                                        LocationState>(
                                                      bloc: BlocProvider.of<
                                                              LocationCubit>(
                                                          context)
                                                        ..readCountryAndCity(),
                                                      builder:
                                                          (context, state) {
                                                        var cubit = BlocProvider
                                                            .of<LocationCubit>(
                                                                context);
                                                        return Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration: BoxDecoration(
                                                                    color: AppConstants
                                                                        .lightPinkColor,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                margin: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        2),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              400),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(0),
                                                                    child: Image
                                                                        .network(
                                                                      cubit.countrySelected
                                                                              ?.flagLink ??
                                                                          '',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: ((context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return Image.asset(
                                                                            Images.logoColor);
                                                                      }),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                //${cubit.countryName ?? ''} -
                                                                " ${cubit.cityName ?? ''}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    robotoRegular
                                                                        .copyWith(
                                                                  color: Colors
                                                                      .green
                                                                      .shade800,
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeDefault,
                                                                ),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .keyboard_arrow_down_outlined,
                                                                color: Colors
                                                                    .green
                                                                    .shade800,
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    )),
                                              ),
                                            ]),
                                      )),
                                      actions: const [SizedBox()],
                                    ),

                                    // Search Button
                                    !showMobileModule
                                        ? SliverPersistentHeader(
                                            pinned: true,
                                            delegate: SliverDelegate(
                                                child: Center(
                                                    child: Container(
                                                        height: context.height *
                                                            0.045,
                                                        width: context.width *
                                                            0.85,
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                        child: BlocBuilder<
                                                            FilterCubit,
                                                            FilterState>(
                                                          builder:
                                                              (context, state) {
                                                            var cubit = BlocProvider
                                                                .of<FilterCubit>(
                                                                    context);
                                                            return Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      Dimensions
                                                                          .paddingSizeSmall),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .radiusExtraSmall),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey[Get.isDarkMode
                                                                              ? 800
                                                                              : 200]!
                                                                          .withOpacity(
                                                                              0.4),
                                                                      spreadRadius:
                                                                          1,
                                                                      offset:
                                                                          Offset(
                                                                              1,
                                                                              1),
                                                                      blurRadius:
                                                                          5)
                                                                ],
                                                              ),
                                                              child: Center(
                                                                child:
                                                                    SearchField(
                                                                  controller: cubit
                                                                      .searchController,
                                                                  suffixIcon:
                                                                      Icons
                                                                          .search,
                                                                  suffixIconColor:
                                                                      Colors
                                                                          .grey,
                                                                  hint:
                                                                      'search_item_or_store'
                                                                          .tr,
                                                                  // suffixIcon: Icons.filter_alt,
                                                                  iconPressed:
                                                                      () {},
                                                                  onSubmit:
                                                                      (text) {
                                                                    Get.toNamed(RouteHelper.getSearchRoute(
                                                                        queryText:
                                                                            text));
                                                                    //   actionSearch(
                                                                    // true,
                                                                    // cubit
                                                                    //     .searchController
                                                                    //     .text
                                                                    //     .trim(),
                                                                    // false,
                                                                    // Get.find<
                                                                    //     SearchingController>(),
                                                                    // Get.find<
                                                                    //     CategoryController>())
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )

                                                        // InkWell(
                                                        //   onTap: () => Get.toNamed(
                                                        //       RouteHelper
                                                        //           .getSearchRoute()),
                                                        //   child: Container(
                                                        // padding: const EdgeInsets
                                                        //         .symmetric(
                                                        //     horizontal: Dimensions
                                                        //         .paddingSizeSmall),
                                                        // decoration: BoxDecoration(
                                                        //   color: Theme.of(context)
                                                        //       .cardColor,
                                                        //   borderRadius: BorderRadius
                                                        //       .circular(Dimensions
                                                        //           .radiusExtraSmall),
                                                        //   boxShadow: [
                                                        //     BoxShadow(
                                                        //         color: Colors.grey[
                                                        //                 Get.isDarkMode
                                                        //                     ? 800
                                                        //                     : 200]!
                                                        //             .withOpacity(0.4),
                                                        //         spreadRadius: 1,
                                                        //         offset: Offset(1, 1),
                                                        //         blurRadius: 5)
                                                        //   ],
                                                        // ),
                                                        //     child: Row(
                                                        //         mainAxisAlignment:
                                                        //             MainAxisAlignment.end,
                                                        //         children: const [
                                                        // Icon(
                                                        //   Icons.search,
                                                        //   size: 23,
                                                        //   color: Colors.grey,
                                                        // ),
                                                        //         ]),
                                                        //   ),
                                                        // ),

                                                        ))),
                                          )
                                        : const SliverToBoxAdapter(),

                                    SliverToBoxAdapter(
                                      child: Center(
                                          child: SizedBox(
                                        width: context.width,
                                        child: !showMobileModule
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                    const BannerView(
                                                        isFeatured: false),
                                                    const CategoryView(),
                                                    // const PopularStoreView(
                                                    //     isPopular: true,
                                                    //     isFeatured: false),
                                                    //const ItemCampaignView(),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  context.width *
                                                                      0.075),
                                                      child:
                                                          const DiscountWidget(),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          context.height * 0.02,
                                                    ),
                                                    const PopularItemView(
                                                        isPopular: true),
                                                    SizedBox(
                                                      height:
                                                          context.height * 0.03,
                                                    )

                                                    // const PopularStoreView(
                                                    //     isPopular: false,
                                                    //     isFeatured: false),
                                                    // const PopularItemView(
                                                    //     isPopular: false),
                                                    // Padding(
                                                    //   padding:
                                                    //       const EdgeInsets.fromLTRB(
                                                    //           10, 15, 0, 5),
                                                    //   child: Row(children: [
                                                    //     Expanded(
                                                    //         child: Text(
                                                    //       Get.find<SplashController>()
                                                    //               .configModel!
                                                    //               .moduleConfig!
                                                    //               .module!
                                                    //               .showRestaurantText!
                                                    //           ? 'all_restaurants'.tr
                                                    //           : 'all_stores'.tr,
                                                    //       style: robotoMedium.copyWith(
                                                    //           fontSize: Dimensions
                                                    //               .fontSizeLarge),
                                                    //     )),
                                                    //     const FilterView(),
                                                    //   ]),
                                                    // ),
                                                    // GetBuilder<StoreController>(
                                                    //     builder: (storeController) {
                                                    //   return PaginatedListView(
                                                    //     scrollController:
                                                    //         _scrollController,
                                                    //     totalSize: storeController
                                                    //                 .storeModel !=
                                                    //             null
                                                    //         ? storeController
                                                    //             .storeModel!
                                                    //             .totalSize
                                                    //         : null,
                                                    //     offset: storeController
                                                    //                 .storeModel !=
                                                    //             null
                                                    //         ? storeController
                                                    //             .storeModel!.offset
                                                    //         : null,
                                                    //     onPaginate: (int?
                                                    //             offset) async =>
                                                    //         await storeController
                                                    //             .getStoreList(
                                                    //                 offset!, false),
                                                    //     itemView: ItemsView(
                                                    //       isStore: true,
                                                    //       items: null,
                                                    //       stores: storeController
                                                    //                   .storeModel !=
                                                    //               null
                                                    //           ? storeController
                                                    //               .storeModel!
                                                    //               .stores
                                                    //           : null,
                                                    //       padding:
                                                    //           EdgeInsets.symmetric(
                                                    //         horizontal: ResponsiveHelper
                                                    //                 .isDesktop(
                                                    //                     context)
                                                    //             ? Dimensions
                                                    //                 .paddingSizeExtraSmall
                                                    //             : Dimensions
                                                    //                 .paddingSizeSmall,
                                                    //         vertical: ResponsiveHelper
                                                    //                 .isDesktop(
                                                    //                     context)
                                                    //             ? Dimensions
                                                    //                 .paddingSizeExtraSmall
                                                    //             : 0,
                                                    //       ),
                                                    //     ),
                                                    //   );
                                                    // }),
                                                  ])
                                            : ModuleView(
                                                splashController:
                                                    splashController),
                                      )),
                                    ),
                                  ],
                                ),
                    ),
                  );
          });
        }),
      );
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
