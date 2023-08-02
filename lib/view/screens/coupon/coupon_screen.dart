import 'package:warda/controller/auth_controller.dart';
import 'package:warda/controller/coupon_controller.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/view/base/custom_app_bar.dart';
import 'package:warda/view/base/custom_snackbar.dart';
import 'package:warda/view/base/footer_view.dart';
import 'package:warda/view/base/menu_drawer.dart';
import 'package:warda/view/base/no_data_screen.dart';
import 'package:warda/view/base/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:warda/view/screens/coupon/widget/coupon_card.dart';

import '../../../util/images.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key, this.fromNav = false}) : super(key: key);
  final bool fromNav;
  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall() {
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<CouponController>().getCouponList();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
        title: 'coupon'.tr,
        backButton: !widget.fromNav,
      ),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: isLoggedIn
          ? GetBuilder<CouponController>(builder: (couponController) {
              return couponController.couponList != null
                  ? couponController.couponList!.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await couponController.getCouponList();
                          },
                          child: Center(
                              child: SizedBox(
                                  width: Dimensions.webMaxWidth,
                                  height: context.height * 0.55,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        couponController.couponList!.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeLarge),
                                    itemBuilder: (context, index) {
                                      int currentIndex = index;
                                      // index = 0;
                                      return InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: couponController
                                                  .couponList![currentIndex]
                                                  .code!));
                                          showCustomSnackBar(
                                              'coupon_code_copied'.tr,
                                              isError: false);
                                        },
                                        child: CouponCard(
                                            couponController: couponController,
                                            couponImg: (index + 1) % 3 == 0
                                                ? Images.couponCoffee
                                                : (index + 1) % 2 == 0
                                                    ? Images.couponGreen
                                                    : Images.couponRed,
                                            index: currentIndex),
                                      );
                                    },
                                  ))),
                        )
                      : NoDataScreen(
                          text: 'no_coupon_found'.tr, showFooter: true)
                  : const Center(child: CircularProgressIndicator());
            })
          : NotLoggedInScreen(callBack: (bool value) {
              initCall();
              setState(() {});
            }),
    );
  }
}
