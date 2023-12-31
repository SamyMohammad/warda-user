import 'dart:async';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/scheduler.dart';
import 'package:warda/controller/auth_controller.dart';
import 'package:warda/controller/location_controller.dart';
import 'package:warda/controller/order_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/data/model/response/order_model.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/view/base/cart_widget.dart';
import 'package:warda/view/base/custom_dialog.dart';
import 'package:warda/view/screens/checkout/widget/congratulation_dialogue.dart';
import 'package:warda/view/screens/coupon/coupon_screen.dart';
import 'package:warda/view/screens/dashboard/widget/address_bottom_sheet.dart';
import 'package:warda/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:warda/view/screens/favourite/favourite_screen.dart';
import 'package:warda/view/screens/home/home_screen.dart';
import 'package:warda/view/screens/menu/menu_screen_new.dart';
import 'package:warda/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/images.dart';
import '../cart/cart_screen.dart';
import '../category/category_screen.dart';
import 'widget/running_order_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final bool fromSplash;
  const DashboardScreen(
      {Key? key, required this.pageIndex, this.fromSplash = false})
      : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();

  // void _openEndDrawer() {
  //   _drawerKey.currentState!.openEndDrawer();
  // }

  // void _closeEndDrawer() {
  //   Navigator.of(context).pop();
  // }

  late bool _isLogin;
  bool active = false;

  returnConfigData() async {
    await Get.find<SplashController>().getConfigData();
  }

  @override
  void initState() {
    super.initState();

    _isLogin = Get.find<AuthController>().isLoggedIn();
    returnConfigData();

    if (_isLogin) {
      if (Get.find<SplashController>().configModel!.loyaltyPointStatus == 1 &&
          Get.find<AuthController>().getEarningPint().isNotEmpty &&
          !ResponsiveHelper.isDesktop(Get.context)) {
        Future.delayed(const Duration(seconds: 1),
            () => showAnimatedDialog(context, const CongratulationDialogue()));
      }
      //  suggestAddressBottomSheet();
      Get.find<OrderController>().getRunningOrders(1);
    }

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(),
      CartScreen(fromNav: true),
      const CategoryScreen(
        fromNav: true,
      ),
      const CouponScreen(
        fromNav: true,
      ),
      const MenuScreenNew()
      // const ProfileScreen()
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  // Future<void> suggestAddressBottomSheet() async {
  //   active = await Get.find<LocationController>().checkLocationActive();
  //   if (widget.fromSplash &&
  //       Get.find<LocationController>().showLocationSuggestion &&
  //       active) {
  //     Future.delayed(const Duration(seconds: 1), () {
  //       showModalBottomSheet(
  //         context: context,
  //         isScrollControlled: true,
  //         backgroundColor: Colors.transparent,
  //         builder: (con) => const AddressBottomSheet(),
  //       ).then((value) {
  //         Get.find<LocationController>().hideSuggestedLocation();
  //         setState(() {});
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          setPage(0);
          return false;
        } else {
          if (!ResponsiveHelper.isDesktop(context) &&
              Get.find<SplashController>().module != null &&
              Get.find<SplashController>().configModel!.module == null) {
            Get.find<SplashController>().setModule(null);
            return false;
          } else {
            if (_canExit) {
              return true;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('back_press_again_to_exit'.tr,
                    style: const TextStyle(color: Colors.white)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              ));
              _canExit = true;
              Timer(const Duration(seconds: 2), () {
                _canExit = false;
              });
              return false;
            }
          }
        }
      },
      child: GetBuilder<OrderController>(builder: (orderController) {
        List<OrderModel> runningOrder =
            orderController.runningOrderModel != null
                ? orderController.runningOrderModel!.orders!
                : [];

        List<OrderModel> reversOrder = List.from(runningOrder.reversed);

        return Scaffold(
          key: _scaffoldKey,

          // endDrawer: const MenuScreenNew(),

          // floatingActionButton: ResponsiveHelper.isDesktop(context)
          //     ? null
          //     : (widget.fromSplash &&
          //             Get.find<LocationController>().showLocationSuggestion &&
          //             active)
          //         ? null
          //         : (orderController.showBottomSheet &&
          //                 orderController.runningOrderModel != null &&
          //                 orderController.runningOrderModel!.orders!.isNotEmpty)
          //             ? const SizedBox()
          //             : FloatingActionButton(
          //                 elevation: 5,
          //                 backgroundColor: _pageIndex == 2
          //                     ? Theme.of(context).primaryColor
          //                     : Theme.of(context).cardColor,
          //                 onPressed: () {
          //                   // setPage(2);
          //                   Get.toNamed(RouteHelper.getCartRoute());
          //                 },
          //                 child: CartWidget(
          //                     color: _pageIndex == 2
          //                         ? Theme.of(context).cardColor
          //                         : Theme.of(context).disabledColor,
          //                     size: 30),
          //               ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: ResponsiveHelper.isDesktop(context)
              ? const SizedBox()
              : (widget.fromSplash &&
                      Get.find<LocationController>().showLocationSuggestion &&
                      active)
                  ? const SizedBox()
                  :
                  // (orderController.showBottomSheet
                  //     //  &&
                  //     //         orderController.runningOrderModel != null &&
                  //     //         orderController.runningOrderModel!.orders!.isNotEmpty

                  //     )
                  //     ? const SizedBox()
                  //     :
                  BottomAppBar(
                      elevation: 5,
                      notchMargin: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: const CircularNotchedRectangle(),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: context.width * 0.15,
                              ),
                              BottomNavItem(
                                  selectedImg: Images.cartColor,
                                  unselectedImg: Images.cartBlack,
                                  title: 'cart',
                                  isSelected: _pageIndex == 1,
                                  onTap: () => setPage(1)),

                              BottomNavItem(
                                  selectedImg: Images.categoriesColor,
                                  unselectedImg: Images.categoriesBlack,
                                  title: 'home',
                                  isSelected: _pageIndex == 0,
                                  onTap: () => setPage(0)),

                              // BottomNavItem(
                              //     selectedImg: Images.categoriesColor,
                              //     unselectedImg: Images.categoriesBlack,
                              //     title: 'categories',
                              //     isSelected: _pageIndex == 2,
                              //     isCategoryItem: true,
                              //     onTap: () => setPage(2)),

                              // BottomNavItem(
                              //     selectedImg: Images.couponColor,
                              //     unselectedImg: Images.couponBlack,
                              //     title: 'Coupon',
                              //     isSelected: _pageIndex == 3,
                              //     onTap: () => setPage(3)),
                              BottomNavItem(
                                  selectedImg: Images.profileColor,
                                  unselectedImg: Images.profileBlack,
                                  title: 'profile',
                                  isSelected: _pageIndex == 4,
                                  onTap: () => setPage(4)),

                              SizedBox(
                                width: context.width * 0.15,
                              ),
                              // BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () => _openEndDrawer()),
                              // BottomNavItem(iconData: Icons.menu, isSelected: _pageIndex == 4, onTap: () {
                              //   Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
                              // }),
                            ]),
                      ),
                    ),
          body: ExpandableBottomSheet(
              background: PageView.builder(
                controller: _pageController,
                itemCount: _screens.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _screens[index];
                },
              ),
              persistentContentHeight: (widget.fromSplash &&
                      Get.find<LocationController>().showLocationSuggestion &&
                      active)
                  ? 0
                  : 100,
              onIsContractedCallback: () {
                if (!orderController.showOneOrder) {
                  orderController.showOrders();
                }
              },
              onIsExtendedCallback: () {
                if (orderController.showOneOrder) {
                  orderController.showOrders();
                }
              },
              enableToggle: true,
              expandableContent: (widget.fromSplash &&
                      Get.find<LocationController>().showLocationSuggestion &&
                      active &&
                      !ResponsiveHelper.isDesktop(context))
                  ? const SizedBox()
                  : (ResponsiveHelper.isDesktop(context) ||
                          !_isLogin ||
                          orderController.runningOrderModel == null ||
                          orderController.runningOrderModel!.orders!.isEmpty ||
                          !orderController.showBottomSheet)
                      ? const SizedBox()
                      : const SizedBox()
              // : Dismissible(
              //     key: UniqueKey(),
              //     onDismissed: (direction) {
              //       if (orderController.showBottomSheet) {
              //         orderController.showRunningOrders();
              //       }
              //     },
              //     child: RunningOrderViewWidget(reversOrder: reversOrder),
              //   ),
              ),
        );
      }),
    );
  }

  void setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {

// }
//     });
  }

  Widget trackView(BuildContext context, {required bool status}) {
    return Container(
        height: 3,
        decoration: BoxDecoration(
            color: status
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)));
  }
}
