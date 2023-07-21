import 'package:warda/controller/onboarding_controller.dart';
import 'package:warda/controller/splash_controller.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/helper/route_helper.dart';
import 'package:warda/util/app_constants.dart';
import 'package:warda/util/dimensions.dart';
import 'package:warda/util/styles.dart';
import 'package:warda/view/base/custom_button.dart';
import 'package:warda/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    Get.find<OnBoardingController>().getOnBoardingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      body: GetBuilder<OnBoardingController>(
        builder: (onBoardingController) => onBoardingController
                .onBoardingList.isNotEmpty
            ? SafeArea(
                child: Center(
                    child: SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: Stack(alignment: Alignment.center, children: [
                          PageView.builder(
                            itemCount:
                                onBoardingController.onBoardingList.length,
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: onBoardingController
                                          .onBoardingList[index]
                                          .backgroundColor,
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                ),
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: context.height * 0.2),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: _pageIndicators(
                                                  onBoardingController,
                                                  context),
                                            ),
                                            SizedBox(
                                                height: context.height * 0.02),
                                            Text(
                                              onBoardingController
                                                  .onBoardingList[index].title,
                                              style: wardaRegular.copyWith(
                                                  fontSize:
                                                      context.height * 0.036,
                                                  color: onBoardingController
                                                      .onBoardingList[index]
                                                      .textColor),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                                height: context.height * 0.025),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeLarge),
                                              child: Text(
                                                onBoardingController
                                                    .onBoardingList[index]
                                                    .description,
                                                style: robotoRegular.copyWith(
                                                    fontSize:
                                                        context.height * 0.0165,
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Image.asset(
                                            onBoardingController
                                                .onBoardingList[index].imageUrl,
                                            fit: BoxFit.fill,
                                            width: context.width * 0.9,
                                            filterQuality: FilterQuality.high,
                                            height: context.height * 0.9),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: index == 2
                                            ? Padding(
                                                padding: const EdgeInsets.all(
                                                    Dimensions
                                                        .paddingSizeSmall),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      // onBoardingController
                                                      //             .selectedIndex ==
                                                      //         2
                                                      //     ? const SizedBox()
                                                      //     : Expanded(
                                                      //         child: CustomButton(
                                                      //           transparent: true,
                                                      //           onPressed: () {
                                                      //             Get.find<
                                                      //                     SplashController>()
                                                      //                 .disableIntro();
                                                      //             Get.offNamed(RouteHelper
                                                      //                 .getSignInRoute(
                                                      //                     RouteHelper
                                                      //                         .onBoarding));
                                                      //           },
                                                      //           buttonText: 'skip'.tr,
                                                      //         ),
                                                      //       ),
                                                      CustomButton(
                                                        buttonText:
                                                            onBoardingController
                                                                        .selectedIndex !=
                                                                    2
                                                                ? 'next'.tr
                                                                : 'get_started'
                                                                    .tr,
                                                        width:
                                                            context.width * 0.3,
                                                        height: context.height *
                                                            0.05,
                                                        color: AppConstants
                                                            .primaryColor,
                                                        onPressed: () {
                                                          if (onBoardingController
                                                                  .selectedIndex !=
                                                              2) {
                                                            _pageController.nextPage(
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                curve: Curves
                                                                    .ease);
                                                          } else {
                                                            Get.find<
                                                                    SplashController>()
                                                                .disableIntro();
                                                            Get.offNamed(RouteHelper
                                                                .getAuthOnBoardingRoute(
                                                                    RouteHelper
                                                                        .onBoarding));
                                                          }
                                                        },
                                                      ),
                                                    ]),
                                              )
                                            : SizedBox(),
                                      )
                                    ]),
                              );
                            },
                            onPageChanged: (index) {
                              onBoardingController.changeSelectIndex(index);
                            },
                          ),
                        ]))),
              )
            : const SizedBox(),
      ),
    );
  }

  List<Widget> _pageIndicators(
      OnBoardingController onBoardingController, BuildContext context) {
    List<Container> indicators = [];

    for (int i = 0; i < onBoardingController.onBoardingList.length; i++) {
      indicators.add(
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: i == onBoardingController.selectedIndex
                  ? Colors.white
                  : Colors.transparent,
              borderRadius: i == onBoardingController.selectedIndex
                  ? BorderRadius.circular(50)
                  : BorderRadius.circular(25),
              border: Border.all(color: Colors.white)),
        ),
      );
    }
    return indicators;
  }
}
