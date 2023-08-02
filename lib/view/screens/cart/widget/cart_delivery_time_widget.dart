import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';

import '../../../../util/app_constants.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/custom_text_field.dart';
import '../cubit/cart_cubit.dart';

class CartDeliveryTimeWidget extends StatefulWidget {
  const CartDeliveryTimeWidget({Key? key}) : super(key: key);

  @override
  State<CartDeliveryTimeWidget> createState() => _CartDeliveryTimeWidgetState();
}

class _CartDeliveryTimeWidgetState extends State<CartDeliveryTimeWidget>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<CartCubit>(context).tabController =
        TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        var cubit = BlocProvider.of<CartCubit>(context);
        return SizedBox(
          height: context.height * 0.7,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
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
                unselectedLabelColor: Colors.grey,
                labelColor: AppConstants.greenColor,
                indicatorPadding:
                    EdgeInsets.symmetric(horizontal: context.width * 0.05),
                indicatorColor: AppConstants.greenColor,
                labelStyle: robotoMedium.copyWith(fontSize: 18),
                unselectedLabelStyle: robotoMedium.copyWith(fontSize: 14),
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'fast'.tr,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'tomorrow'.tr,
                      style: robotoMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'custom'.tr,
                      style: robotoMedium,
                    ),
                  ),
                ]),
            Expanded(
              child: TabBarView(controller: cubit.tabController, children: [
                fastTomorrowTabBody(cubit, true),
                fastTomorrowTabBody(cubit, false),
                customTabBody(cubit)
              ]),
            )
          ]),
        );
      },
    );
  }

  Widget fastTomorrowTabBody(CartCubit cubit, bool isToday) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        TimePickerSpinner(
          is24HourMode: false,
          normalTextStyle: robotoRegular.copyWith(color: Colors.grey),
          highlightedTextStyle:
              robotoRegular.copyWith(color: AppConstants.primaryColor),
          // spacing: 10,
          itemHeight: context.height * 0.04,
          isForce2Digits: true,
          itemWidth: context.width * 0.05,
          onTimeChange: (time) {
            cubit.changeArriveTime(time, isToday: isToday);
          },
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
          height: context.height * 0.03,
        ),
        // CustomButton(
        //   onPressed: () async {
        //     String? message = cubit.validator(4);
        //     if (message.runtimeType != Null) {
        //       print('hello validator :: $message');
        //       showCustomSnackBar(message, isError: true);
        //     } else {
        //       cubit.changeActiveStep(4);
        //     }
        //   },
        //   radius: 30,
        //   buttonText: 'continue'.tr,
        // ),
      ],
    );
  }

  Widget customTabBody(
    CartCubit cubit,
  ) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          TimePickerSpinner(
            is24HourMode: false,
            normalTextStyle: robotoRegular.copyWith(color: Colors.grey),
            highlightedTextStyle:
                robotoRegular.copyWith(color: AppConstants.primaryColor),
            // spacing: 10,
            itemHeight: context.height * 0.04,
            isForce2Digits: true,
            itemWidth: context.width * 0.05,
            onTimeChange: (time) {
              cubit.changeArriveTime(
                time,
              );
            },
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
            height: context.height * 0.03,
          ),
          CustomButton(
            onPressed: () {
              String? message = cubit.validator(4);
              if (message.runtimeType != Null) {
                showCustomSnackBar(message, isError: true);
              } else {
                cubit.changeActiveStep(4);
              }
            },
            radius: 30,
            buttonText: 'continue'.tr,
          ),
          SizedBox(
            height: context.height * 0.03,
          ),
        ],
      ),
    );
  }
}
