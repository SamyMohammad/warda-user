import 'package:warda/data/model/response/onboarding_model.dart';
import 'package:warda/util/images.dart';
import 'package:get/get.dart';
import 'package:warda/util/styles.dart';

class OnBoardingRepo {
  Future<Response> getOnBoardingList() async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(
            Images.onboard_1,
            'on_boarding_1_title'.tr,
            'on_boarding_1_description'.tr,
            onBoradingBackground1,
            onboradingTextColor1),
        OnBoardingModel(
            Images.onboard_2,
            'on_boarding_2_title'.tr,
            'on_boarding_2_description'.tr,
            onBoradingBackground2,
            onboradingTextColor2),
        OnBoardingModel(
            Images.onboard_3,
            'on_boarding_3_title'.tr,
            'on_boarding_3_description'.tr,
            onBoradingBackground3,
            onboradingTextColor3),
      ];

      Response response = Response(body: onBoardingList, statusCode: 200);
      return response;
    } catch (e) {
      return const Response(
          statusCode: 404, statusText: 'Onboarding data not found');
    }
  }
}
