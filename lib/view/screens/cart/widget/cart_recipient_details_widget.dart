import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/cart_controller.dart';
import '../../../../controller/localization_controller.dart';
import '../../../../controller/splash_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/custom_text_field.dart';
import '../../checkout/checkout_screen.dart';
import '../../location/cubit/location_cubit.dart';
import '../cubit/cart_cubit.dart';

class CartRecipientDetailsWidget extends StatefulWidget {
  const CartRecipientDetailsWidget({Key? key}) : super(key: key);

  @override
  State<CartRecipientDetailsWidget> createState() =>
      _RecipientDetailsWidgetState();
}

class _RecipientDetailsWidgetState extends State<CartRecipientDetailsWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        var cubit = BlocProvider.of<CartCubit>(context);
        return GetBuilder<CartController>(builder: (cartController) {
          return GetBuilder<UserController>(
            builder: (userController) {
              bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
              if (userController.userInfoModel != null) {
                cubit.phoneNumerController.text = userController
                        .userInfoModel!.phone
                        ?.replaceAll(cubit.countryDialCode ?? '', '') ??
                    '';

                String fullname =
                    '${userController.userInfoModel!.fName ?? ''} ${userController.userInfoModel!.lName ?? ''}';
                cubit.fullNameController.text = fullname;
              }
              return SizedBox(
                height: context.height * 0.7,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.place_outlined,
                            color: AppConstants.primaryColor,
                            size: 25,
                          ),
                          Text(
                            'deliver_to'.tr,
                            style: robotoRegular,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          BlocBuilder<LocationCubit, LocationState>(
                            bloc: BlocProvider.of<LocationCubit>(context)
                              ..readCountryAndCity(),
                            builder: (context, state) {
                              var cubit =
                                  BlocProvider.of<LocationCubit>(context);
                              return Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Image.network(
                                        cubit.countrySelected?.flagLink ?? '',
                                        errorBuilder:
                                            ((context, error, stackTrace) {
                                          return Image.asset(Images.logoColor);
                                        }),
                                      ),
                                    ),
                                    Text(
                                      "${cubit.cityName ?? ''}",
                                      textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      Text(
                        '${'receiver_name'.tr} *',
                        style: robotoRegular,
                      ),
                      CustomTextField(
                        controller: cubit.fullNameController,
                        titleText: 'receiver_name'.tr,
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      Text(
                        '${'receiver_phone_number'.tr} *',
                        style: robotoRegular,
                      ),
                      CustomTextField(
                        titleText: ResponsiveHelper.isDesktop(context)
                            ? 'phone'.tr
                            : 'phone'.tr,
                        controller: cubit.phoneNumerController,
                        inputType: TextInputType.phone,
                        isPhone: true,
                        showTitle: ResponsiveHelper.isDesktop(context),
                        onCountryChanged: (CountryCode countryCode) {
                          cubit.countryDialCode = countryCode.dialCode;
                        },
                        countryDialCode: cubit.countryDialCode != null
                            ? CountryCode.fromCountryCode(
                                    Get.find<SplashController>()
                                        .configModel!
                                        .country!)
                                .code
                            : Get.find<LocalizationController>()
                                .locale
                                .countryCode,
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      Text(
                        '${'receiver_address'.tr} *',
                        style: robotoRegular,
                      ),
                      CustomTextField(
                        controller: cubit.adressController,
                        titleText: 'address'.tr,
                      ),

                      // SizedBox(
                      //   height: context.height * 0.02,
                      // ),
                      // CustomTextField(
                      //   controller: cubit.areaController,
                      //   titleText: 'area'.tr,
                      // ),

                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: CheckboxListTile(
                            value: cubit.keepSecret,

                            // checkColor: AppConstants.primaryColor,

                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: SizedBox(
                              width: context.width * 0.9,
                              child: Text(
                                'keep_my_identity_secret'.tr,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            side: const BorderSide(
                                color: AppConstants.primaryColor),
                            onChanged: (value) {
                              setState(() {
                                cubit.keepSecret = value ?? false;
                              });
                            }),
                      ),

                      // CustomButton(
                      //   buttonText: 'continue'.tr,
                      //   onPressed: () {
                      //     String? message = cubit.validator(3);
                      //     if (message.runtimeType != Null) {
                      //       print('hello validator :: $message');
                      //       showCustomSnackBar(message, isError: true);
                      //     } else {
                      //       cubit.changeActiveStep(3);
                      //     }
                      //   },
                      // )
                    ]),
              );
            },
          );
        });
      },
    );
  }
}
