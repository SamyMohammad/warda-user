import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warda/controller/auth_controller.dart';
import 'package:warda/controller/cart_controller.dart';
import 'package:warda/controller/location_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/controller/wishlist_controller.dart';
import 'package:warda/data/model/body/notification_body.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/images.dart';
import 'package:warda/view/base/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/cashe_helper.dart';
import '../location/cubit/location_cubit.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  const SplashScreen({Key? key, required this.body}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    Get.find<CartController>().getCartData();
    _route();
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() async {
    bool haveZoneId =
        await BlocProvider.of<LocationCubit>(context).haveCityId();
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          double? minimumVersion = 0;
          if (GetPlatform.isAndroid) {
            minimumVersion = Get.find<SplashController>()
                .configModel!
                .appMinimumVersionAndroid;
          } else if (GetPlatform.isIOS) {
            minimumVersion =
                Get.find<SplashController>().configModel!.appMinimumVersionIos;
          }
          if (AppConstants.appVersion < minimumVersion! ||
              Get.find<SplashController>().configModel!.maintenanceMode!) {
            Get.offNamed(RouteHelper.getUpdateRoute(
                AppConstants.appVersion < minimumVersion));
          } else {
            if (widget.body != null) {
              if (widget.body!.notificationType == NotificationType.order) {
                Get.offNamed(RouteHelper.getOrderDetailsRoute(
                    widget.body!.orderId,
                    fromNotification: true));
              } else if (widget.body!.notificationType ==
                  NotificationType.general) {
                Get.offNamed(
                    RouteHelper.getNotificationRoute(fromNotification: true));
              } else {
                Get.offNamed(RouteHelper.getChatRoute(
                    notificationBody: widget.body,
                    conversationID: widget.body!.conversationId,
                    fromNotification: true));
              }
            } else {
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
                if (Get.find<LocationController>().getUserAddress() != null) {
                  await Get.find<WishListController>().getWishList();
                  Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
                } else if (haveZoneId) {
                  Get.offNamed(RouteHelper.getInitialRoute(fromSplash: true));
                } else {
                  print('hello spash:: zone id is write >  ${haveZoneId}');
                  Get.find<LocationController>()
                      .navigateToLocationScreen('splash', offNamed: true);
                }
              } else {
                // if (Get.find<SplashController>().showIntro()!) {
                //   if (AppConstants.languages.length > 1) {
                //     Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                //   } else {
                //     Get.offNamed(RouteHelper.getOnBoardingRoute());
                //   }
                // }
                // else {

                Get.offNamed(
                    RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                // Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                // }

                //  Get.offNamed(RouteHelper.getOnBoardingRoute());
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>().initSharedData();
    if (Get.find<LocationController>().getUserAddress() != null &&
        Get.find<LocationController>().getUserAddress()!.zoneIds == null) {
      Get.find<AuthController>().clearSharedAddress();
    }

    return Scaffold(
      key: _globalKey,
      backgroundColor: AppConstants.splashBackgroundColor,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.hasConnection
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(Images.splashLogo, width: context.width * 0.9),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    // Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: 25)),
                  ],
                )
              : NoInternetScreen(child: SplashScreen(body: widget.body)),
        );
      }),
    );
  }
}
