import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:warda/util/images.dart';
import 'package:warda/util/styles.dart';

class AuthOnBoardingScreen extends StatelessWidget {
  final bool exitFromApp;
  final bool backFromThis;
  const AuthOnBoardingScreen(
      {Key? key, required this.exitFromApp, required this.backFromThis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width,
        height: context.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(Images.authBackground))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.logoWhite),
            SizedBox(
              height: context.height * 0.07,
            ),
            Text(
              "The most fulfiling shopping experience",
              textAlign: TextAlign.center,
              style: wardaRegular.copyWith(
                  color: Colors.white,
                  fontSize: context.width * 0.09,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: context.height * 0.15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buttubAuthOnboarding(
                    context.width * 0.35,
                    context.height * 0.08,
                    Text(
                      'Login'.toUpperCase(),
                      style: robotoRegular.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                SizedBox(
                  width: context.width * 0.05,
                ),
                buttubAuthOnboarding(
                    context.width * 0.35,
                    context.height * 0.08,
                    Text(
                      'Sing up'.toUpperCase(),
                      style: robotoRegular.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: context.height * 0.015,
            ),
            buttubAuthOnboarding(
                context.width * 0.75,
                context.height * 0.08,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.facebook_outlined,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Connect with facebook'.toUpperCase(),
                        style: robotoRegular.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: context.width * 0.04),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: context.height * 0.015,
            ),
            buttubAuthOnboarding(
                context.width * 0.75,
                context.height * 0.08,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.facebook,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Connect with google'.toUpperCase(),
                        style: robotoRegular.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: context.width * 0.04),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget buttubAuthOnboarding(double width, double height, Widget brnContent) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: brnContent,
        ),
      ),
    );
  }
}
