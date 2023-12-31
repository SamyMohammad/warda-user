import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/images.dart';
import 'package:warda/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warda/view/base/footer_view.dart';
import 'package:warda/view/screens/dashboard/dashboard_screen.dart';
import 'package:warda/view/screens/home/cubit/home_cubit.dart';

class NoDataScreen extends StatelessWidget {
  final bool isCart;
  final bool showFooter;
  final String? text;
  final bool fromAddress;
  const NoDataScreen(
      {Key? key,
      required this.text,
      this.isCart = false,
      this.showFooter = false,
      this.fromAddress = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FooterView(
        visibility: showFooter,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  fromAddress
                      ? Images.address
                      : isCart
                          ? Images.emptyCart
                          : Images.noDataFound,
                  width: MediaQuery.of(context).size.height * 0.25,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text(
                isCart ? 'cart_is_empty'.tr : text!,
                style: robotoMedium.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.0175,
                    color: fromAddress
                        ? Theme.of(context).textTheme.bodyMedium!.color
                        : Theme.of(context).disabledColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              fromAddress
                  ? Text(
                      'please_add_your_address_for_your_better_experience'.tr,
                      style: robotoMedium.copyWith(
                          fontSize: MediaQuery.of(context).size.height * 0.0175,
                          color: Theme.of(context).disabledColor),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              fromAddress
                  ? InkWell(
                      onTap: () => Get.toNamed(
                          RouteHelper.getAddAddressRoute(false, false, 0)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Theme.of(context).primaryColor,
                        ),
                        width: context.width * 0.75,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_circle_outline_sharp,
                                size: 18.0, color: Theme.of(context).cardColor),
                            Text('add_address'.tr,
                                style: robotoMedium.copyWith(
                                    color: Theme.of(context).cardColor)),
                          ],
                        ),
                      ),
                    )
                  : isCart
                      ? InkWell(
                          onTap: () {
                            // Get.toNamed(
                            //     RouteHelper.getInitialRoute(fromSplash: true));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const DashboardScreen(pageIndex: 0)));
                            // DashboardScreenState().setPage(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Theme.of(context).primaryColor,
                            ),
                            width: context.width * 0.75,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('start_shopping'.tr,
                                    style: robotoMedium.copyWith(
                                        color: Theme.of(context).cardColor)),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
            ]),
      ),
    );
  }
}
