import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
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
import 'continue_widget.dart';

class CartRecipientDetailsWidget extends StatefulWidget {
  const CartRecipientDetailsWidget({Key? key}) : super(key: key);

  @override
  State<CartRecipientDetailsWidget> createState() =>
      _RecipientDetailsWidgetState();
}

class _RecipientDetailsWidgetState extends State<CartRecipientDetailsWidget>
    with TickerProviderStateMixin {
  // late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<CartCubit>(context)
        .setupCountryCode(Get.find<UserController>());
    BlocProvider.of<CartCubit>(context).tabController =
        TabController(length: 3, vsync: this);

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
              return SizedBox(
                height: context.height * 0.8,
                child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(
                            width: context.width * 0.04,
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
                            // ? CountryCode.fromCountryCode(
                            //         Get.find<SplashController>()
                            //             .configModel!
                            //             .country!)
                            //     .code
                            ? cubit.countryDialCode
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
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      // time delivery data
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              color: AppConstants.primaryColor, size: 20),
                          SizedBox(
                            width: context.width * 0.04,
                          ),
                          Text(
                            'delivery_time'.tr,
                            style: robotoRegular,
                          )
                        ],
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      TabBar(
                          controller: cubit.tabController,
                          // controller: tabController,
                          unselectedLabelColor: Colors.grey,
                          labelColor: AppConstants.greenColor,
                          indicatorPadding: EdgeInsets.symmetric(
                              horizontal: context.width * 0.05),
                          indicatorColor: AppConstants.greenColor,
                          labelStyle: robotoMedium.copyWith(
                              fontWeight: FontWeight.w600),
                          unselectedLabelStyle: robotoRegular.copyWith(),
                          isScrollable: true,
                          tabs: [
                            Container(
                              width: context.width * 0.18,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'fast'.tr,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 2),
                              width: context.width * 0.35,
                              child: Text(
                                'tomorrow'.tr,
                              ),
                            ),
                            Container(
                              width: context.width * 0.2,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'custom'.tr,
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: cubit.tabController.index != 2
                            // tabController.index != 2
                            ? context.height * 0.25
                            : context.height * 0.56,
                        child: TabBarView(
                            controller: cubit.tabController,
                            // controller: tabController,
                            children: [
                              fastTomorrowTabBody(cubit, true),
                              fastTomorrowTabBody(cubit, false),
                              customTabBody(cubit)
                            ]),
                      ),

                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      Text(
                        'delivery_notes'.tr,
                        style: robotoRegular.copyWith(),
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      CustomTextField(
                        controller: cubit.deliveryNotes,
                        titleText: 'delivery_notes'.tr,
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      ContinueCartBtn(),

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

  Widget fastTomorrowTabBody(CartCubit cubit, bool isToday) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(
          height: context.height * 0.02,
        ),
        Text(
          isToday
              ? '${'delivery_will_arrive'.tr} ${'today'.tr} - ${cubit.dateToday} ${'at_time'.tr}'
              : '${'delivery_will_arrive'.tr} ${'tomorrow'.tr} - ${cubit.dateTomorrow} ${'at_time'.tr}',
          style: robotoRegular.copyWith(color: AppConstants.primaryColor),
        ),
        SizedBox(
          height: context.height * 0.02,
        ),
        Row(
          children: [
            const Icon(
              Icons.access_time_outlined,
              color: AppConstants.primaryColor,
            ),
            SizedBox(
              width: context.width * 0.03,
            ),
            Text(
              'select_a_time'.tr,
              style: robotoRegular,
            )
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: context.height * 0.04,
              width: context.width * 0.5,
              decoration: BoxDecoration(color: AppConstants.lightPinkColor),
            ),
            TimePickerSpinner(
              is24HourMode: false,
              normalTextStyle: robotoRegular.copyWith(color: Colors.grey),
              highlightedTextStyle:
                  robotoRegular.copyWith(color: AppConstants.primaryColor),
              // spacing: 10,
              itemHeight: context.height * 0.04,
              isForce2Digits: true,
              itemWidth: context.width * 0.06,
              onTimeChange: (time) {
                cubit.changeArriveTime(time, isToday: isToday);
              },
            ),
          ],
        ),
        // const ContinueCartBtn(),
      ],
    );
  }

  Widget customTabBody(
    CartCubit cubit,
  ) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(
          height: context.height * 0.02,
        ),
        Text(
          '${cubit.dateCustom} ${'atTime'.tr} ${cubit.arriveTimeCustom}',
          style: robotoRegular.copyWith(color: AppConstants.primaryColor),
        ),
        SizedBox(
          height: context.height * 0.02,
        ),
        SizedBox(
          height: context.height * 0.3,
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.single,
                firstDate: DateTime.now(),
                selectedDayHighlightColor: AppConstants.greenColor,
                lastDate: DateTime.now().add(const Duration(days: 60))),
            value: cubit.range,
            onValueChanged: (dates) {
              cubit.changeArriveDate(dates);
            },
          ),
        ),
        SizedBox(
          height: context.height * 0.02,
        ),
        Row(
          children: [
            const Icon(
              Icons.access_time_outlined,
              color: AppConstants.primaryColor,
            ),
            SizedBox(
              width: context.width * 0.03,
            ),
            Text(
              'select_a_time'.tr,
              style: robotoRegular,
            )
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: context.height * 0.04,
              width: context.width * 0.5,
              decoration: BoxDecoration(color: AppConstants.lightPinkColor),
            ),
            TimePickerSpinner(
              is24HourMode: false,
              normalTextStyle: robotoRegular.copyWith(color: Colors.grey),
              highlightedTextStyle: robotoRegular.copyWith(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w600),

              // spacing: 10,
              itemHeight: context.height * 0.04,
              isForce2Digits: true,
              itemWidth: context.width * 0.055,
              onTimeChange: (time) {
                cubit.changeArriveTime(
                  time,
                );
              },
            ),
          ],
        ),
        // const ContinueCartBtn(),
      ],
    );
  }
}
