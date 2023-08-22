import 'package:warda/controller/auth_controller.dart';
import 'package:warda/controller/order_controller.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/custom_app_bar.dart';
import 'package:warda/view/base/menu_drawer.dart';
import 'package:warda/view/base/not_logged_in_screen.dart';
import 'package:warda/view/screens/order/widget/order_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    initCall();
  }

  void initCall() {
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<OrderController>().getRunningOrders(1);
      Get.find<OrderController>().getHistoryOrders(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return Scaffold(
      appBar: CustomAppBar(title: 'my_orders'.tr, backButton: true),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: _isLoggedIn
          ? GetBuilder<OrderController>(
              builder: (orderController) {
                return Column(children: [
                  Center(
                    child: Container(
                      width: Dimensions.webMaxWidth,
                      color: Theme.of(context).cardColor,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Color.fromRGBO(8, 117, 107, 1),
                        indicatorWeight: 2,
                        labelPadding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.symmetric(
                            horizontal: context.width * 0.1, vertical: 0),
                        labelColor: AppConstants.greenColor,
                        unselectedLabelColor: Theme.of(context).disabledColor,
                        unselectedLabelStyle: robotoRegular.copyWith(
                            color: Theme.of(context).disabledColor,
                            fontSize: Dimensions.fontSizeSmall),
                        labelStyle: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: AppConstants.greenColor),
                        tabs: [
                          Tab(text: 'running'.tr),
                          Tab(text: 'history'.tr),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: const [
                      OrderView(isRunning: true),
                      OrderView(isRunning: false),
                    ],
                  )),
                ]);
              },
            )
          : NotLoggedInScreen(callBack: (value) {
              initCall();
              setState(() {});
            }),
    );
  }
}
