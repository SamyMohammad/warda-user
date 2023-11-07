import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
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
import '../../../base/custom_controller.dart';
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
  // final CustomContainerController _customContainerController=CustomContainerController();

  @override
  void initState() {
    // TODO: implement initState
    Get.find<SplashController>().getConfigData();
    // print(Get.find<SplashController>().configModel!.storeSchedule!.length);
    BlocProvider.of<CartCubit>(context)
        .setupCountryCode(Get.find<UserController>());
    BlocProvider.of<CartCubit>(context).getTimeSlotsList();
    BlocProvider.of<CartCubit>(context).getFirstDate();
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
          // Get.find<SplashController>().getConfigData();
          return GetBuilder<UserController>(
            builder: (userController) {
              bool isLoggedIn = Get.find<AuthController>().isLoggedIn();

              return Container(
                padding: EdgeInsets.only(
                  top: context.height * 0.02,
                ),
                height: context.height * 0.8,
                child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                      const Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      // time delivery data
                      Padding(
                        padding: const EdgeInsets.only(left: 9.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                color: AppConstants.primaryColor, size: 22),
                            SizedBox(
                              width: context.width * 0.04,
                            ),
                            Text(
                              'delivery_time'.tr,
                              style: robotoRegular,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      // TabBar(
                      //     controller: cubit.tabController,
                      //     // controller: tabController,
                      //     unselectedLabelColor: Colors.grey,
                      //     labelColor: AppConstants.greenColor,
                      //     indicatorPadding: EdgeInsets.symmetric(
                      //         horizontal: context.width * 0.05),
                      //     indicatorColor: AppConstants.greenColor,
                      //     labelStyle: robotoMedium.copyWith(
                      //         fontWeight: FontWeight.w600),
                      //     unselectedLabelStyle: robotoRegular.copyWith(),
                      //     isScrollable: true,
                      //     tabs: [
                      //       Container(
                      //         width: context.width * 0.18,
                      //         alignment: Alignment.center,
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(5.0),
                      //           child: Text(
                      //             'fast'.tr,
                      //           ),
                      //         ),
                      //       ),
                      //       Container(
                      //         alignment: Alignment.center,
                      //         padding: const EdgeInsets.symmetric(
                      //             vertical: 5.0, horizontal: 2),
                      //         width: context.width * 0.35,
                      //         child: Text(
                      //           'tomorrow'.tr,
                      //         ),
                      //       ),
                      //       Container(
                      //         width: context.width * 0.2,
                      //         alignment: Alignment.center,
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(5.0),
                      //           child: Text(
                      //             'custom'.tr,
                      //           ),
                      //         ),
                      //       ),
                      //     ]),

                      customTabBody(
                        cubit,
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

  // Widget fastTomorrowTabBody(CartCubit cubit, bool isToday) {
  //   return ListView(
  //     physics: const NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     children: [
  //       SizedBox(
  //         height: context.height * 0.02,
  //       ),
  //       // Text(
  //       //   isToday
  //       //       ? '${'delivery_will_arrive'.tr} ${'today'.tr} - ${cubit.dateToday} ${'at_time'.tr}'
  //       //       : '${'delivery_will_arrive'.tr} ${'tomorrow'.tr} - ${cubit.dateTomorrow} ${'at_time'.tr}',
  //       //   style: robotoRegular.copyWith(color: AppConstants.primaryColor),
  //       // ),
  //       SizedBox(
  //         height: context.height * 0.02,
  //       ),
  //       Row(
  //         children: [
  //           const Icon(
  //             Icons.access_time_outlined,
  //             color: AppConstants.primaryColor,
  //           ),
  //           SizedBox(
  //             width: context.width * 0.03,
  //           ),
  //           Text(
  //             'select_a_time'.tr,
  //             style: robotoRegular,
  //           )
  //         ],
  //       ),
  //       Stack(
  //         alignment: Alignment.center,
  //         children: [
  //           Container(
  //             height: context.height * 0.04,
  //             width: context.width * 0.5,
  //             decoration: BoxDecoration(color: AppConstants.lightPinkColor),
  //           ),
  //           TimePickerSpinner(
  //             is24HourMode: false,
  //             normalTextStyle: robotoRegular.copyWith(color: Colors.grey),
  //             highlightedTextStyle:
  //                 robotoRegular.copyWith(color: AppConstants.primaryColor),
  //             // spacing: 10,
  //             itemHeight: context.height * 0.04,
  //             isForce2Digits: true,
  //             itemWidth: context.width * 0.06,
  //             onTimeChange: (time) {
  //               cubit.changeArriveTime(time, isToday: isToday);
  //             },
  //           ),
  //         ],
  //       ),
  //       // const ContinueCartBtn(),
  //     ],
  //   );
  // }

  Widget customTabBody(
    CartCubit cubit,
  ) {
    // List<String?>? timeSlots = cubit.getTimeSlotsList(
    //     day: cubit
    //         .convertDateTimeDayToDaysFromApi(cubit.range.first?.weekday ?? 0));
// String? currentOption=timeSlots?[0];

    TextDirection textDirection = TextDirection.rtl;
    return Column(
      // physics: const NeverScrollableScrollPhysics(),
      // shrinkWrap: true,
      children: [
        // SizedBox(
        //   height: context.height * 0.02,
        // ),
        // Text(
        //   '${cubit.dateCustom} ${'atTime'.tr} ${cubit.arriveTimeCustom}',
        //   style: robotoRegular.copyWith(color: AppConstants.primaryColor),
        // ),
        SizedBox(
          height: context.height * 0.02,
        ),
        SizedBox(
          height: context.height * 0.3,
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
                selectableDayPredicate: cubit.isDaySelectable,
                calendarType: CalendarDatePicker2Type.single,
                currentDate: cubit.range.first,
                firstDate: cubit.range.first,
                selectedDayHighlightColor: AppConstants.greenColor,
                lastDate: DateTime.now().add(const Duration(days: 365))),
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
        Column(
          children: [
            // Container(
            //   height: context.height * 0.04,
            //   width: context.width * 0.5,
            //   decoration: const BoxDecoration(color: AppConstants.lightPinkColor),
            // ),
            SizedBox(
              height: context.height * 0.03,
            ),
            ...cubit.timeSlots
                .map((item) => timeSlotWidget(textDirection, item, cubit))
                .toList(),

//             SizedBox(
//               height: context.height * 0.2,
//               width: context.width * 0.5,
//               child: CupertinoTheme(
//                 data: CupertinoThemeData(
//                   textTheme: CupertinoTextThemeData(
//                     dateTimePickerTextStyle: robotoRegular.copyWith(
//                         color: AppConstants.primaryColor,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 child: CupertinoDatePicker(
//                   initialDateTime: DateTime.now().copyWith(
//                       hour: cubit
//                           .getOpeningTime(
//                           day: cubit.convertDateTimeDayToDaysFromApi(
//                               cubit.range.first?.weekday ?? 0))
//                           .hour,
//                       minute: cubit
//                           .getOpeningTime(
//                           day: cubit.convertDateTimeDayToDaysFromApi(
//                               cubit.range.first?.weekday ?? 0))
//                           .minute),
//                   //               initialDateTime: cubit.getOpeningTime(
//                   // day: cubit.convertDateTimeDayToDaysFromApi(
//                   // cubit.range.first?.weekday??0)),
//                   //               minimumDate: cubit.getOpeningTime(
//                   //                   day: cubit.convertDateTimeDayToDaysFromApi(
//                   //                       cubit.range.first?.weekday??0)),
//                   use24hFormat: true,
//                   minimumDate: DateTime.now().copyWith(
//                       hour: cubit
//                           .getOpeningTime(
//                               day: cubit.convertDateTimeDayToDaysFromApi(
//                                   cubit.range.first?.weekday ?? 0))
//                           .hour,
//                       minute: cubit
//                           .getOpeningTime(
//                               day: cubit.convertDateTimeDayToDaysFromApi(
//                                   cubit.range.first?.weekday ?? 0))
//                           .minute),
//                   maximumDate: DateTime.now().copyWith(
//                       hour: cubit
//                           .getClosingTime(
//                               day: cubit.convertDateTimeDayToDaysFromApi(
//                                   cubit.range.first?.weekday ?? 0))
//                           .hour,
//                       minute: cubit
//                           .getClosingTime(
//                               day: cubit.convertDateTimeDayToDaysFromApi(
//                                   cubit.range.first?.weekday ?? 0))
//                           .minute),
// //
// //                   maximumDate: cubit.getClosingTime(
// //                       day: cubit.convertDateTimeDayToDaysFromApi(
// //                           cubit.range.first?.weekday??0)),
//                   mode: CupertinoDatePickerMode.time,
//
//                   onDateTimeChanged: (DateTime newDateTime) {
//                     print(newDateTime);
//
//                     cubit.changeArriveTime(
//                       newDateTime,
//                     );
//                   },
//                 ),
//               ),
//             )
            // TimePickerSpinner(
            //   is24HourMode: false,
            //   normalTextStyle: robotoRegular.copyWith(color: Colors.grey),
            //   highlightedTextStyle: robotoRegular.copyWith(
            //       color: AppConstants.primaryColor,
            //       fontWeight: FontWeight.w600),
            //
            //   // spacing: 10,
            //   itemHeight: context.height * 0.04,
            //   isForce2Digits: true,
            //
            //   itemWidth: context.width * 0.055,
            //   onTimeChange: (time) {
            //     cubit.changeArriveTime(
            //       time,
            //     );
            //   },
            // ),
          ],
        ),
        // const ContinueCartBtn(),
      ],
    );
  }

  Column timeSlotWidget(
      TextDirection textDirection, String? item, CartCubit cubit) {
    return Column(
      children: [
        Directionality(
          textDirection: textDirection,
          child: RadioListTile<String>(
            activeColor: AppConstants.primaryColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            value: item!,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(9)),
              side: BorderSide(color: Colors.black.withOpacity(.7)),
            ),
            groupValue: cubit.currentOption,

            onChanged: cubit.onChangedRadioButton,
            title: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  if (textDirection == TextDirection.ltr) const Spacer(),
                  Text(
                    cubit.convertTimeFormat(item),
                    style: robotoMedium.copyWith(
                        color: Colors.black.withOpacity(.7), fontSize: 16),
                  ),
                  if (textDirection == TextDirection.rtl) const Spacer(),
                ],
              ),
            ),

            // child: Text(
            //   item!,
            //   style:  robotoRegular.copyWith(
            //       color: AppConstants.primaryColor,
            //       fontWeight: FontWeight.w600),
            //   overflow: TextOverflow.ellipsis,
            // ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
