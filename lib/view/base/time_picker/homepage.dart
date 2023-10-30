// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/app_constants.dart';
import '../../../util/styles.dart';
import '../custom_controller.dart';
import 'am_pm.dart';
import 'hours.dart';
import 'minutes.dart';
import 'tile.dart';

class TimePickerWheel extends StatefulWidget {
  TimePickerWheel(
      {Key? key,
        // required this.customContainerController,
      required this.minTime,
      required this.maxTime,
      this.onSelectedMinuteChanged,
        this.onSelectedHourChanged,
       // required this.customContainerController
      })
      : super(key: key);
  final Function(int)? onSelectedMinuteChanged;
  final Function(int)? onSelectedHourChanged;
  TimeOfDay selectedTime = TimeOfDay.now();
  final TimeOfDay minTime; // Example minimum time (9:00 AM)
  final TimeOfDay maxTime;
  // final CustomContainerController customContainerController;

  //
  // String selectedHour = '00';
  // String selectedMinute = '00';

  @override
  TimePickerWheelState createState() => TimePickerWheelState();
}

class TimePickerWheelState extends State<TimePickerWheel> {
  late FixedExtentScrollController _controller;
  List<String> hours = [];
  List<String> minutes = [];
  late DateTime _selectedDateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hours = List<String>.generate(widget.maxTime.hour - widget.minTime.hour + 1,
        (i) => i.toString().padLeft(2, '0'));
    minutes = List<String>.generate(60, (i) => i.toString().padLeft(2, '0'));
    _controller = FixedExtentScrollController();

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // hours wheel
        Container(
          width: context.width * 0.055,
          height: context.height * .15,
          child: ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: 50,
            perspective: 0.005,
            diameterRatio: 1.2,
            onSelectedItemChanged: (index){

            },
            physics: FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildLoopingListDelegate(
              children: hours
                  .map((h) => Text(h,
                      style: robotoRegular.copyWith(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.w600)))
                  .toList(),
              // childCount: widget.maxTime.hour - widget.minTime.hour + 1,
              // builder: (context, index) {
              //   return MyHours(
              //     hours: index,
              //   );
              // },
            ),
          ),
        ),

        SizedBox(
          width: 10,
        ),

        // minutes wheel
        Container(
          width: context.width * 0.055,
          height: context.height * .15,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 50,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index){},
            childDelegate: ListWheelChildLoopingListDelegate(

              children: minutes
                  .map((m) => Text(
                        m,
                        style: robotoRegular.copyWith(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w600),
                      ))
                  .toList(),
              // childCount: 60,
              // builder: (context, index) {
              //   return MyMinutes(
              //     mins: index,
              //   );
              // },
            ),
          ),
        ),

        SizedBox(
          width: 15,
        ),

        // am or pm
        Container(
          width: context.width * 0.055,
          height: context.height * .15,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 50,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: 2,
              builder: (context, index) {
                if (index == 0) {
                  return AmPm(
                    isItAm: true,
                  );
                } else {
                  return AmPm(
                    isItAm: false,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
  // void _updateDateTime() {
  //   _selectedDateTime = DateTime(_selectedDateTime.year,
  //       _selectedDateTime.month, _selectedDateTime.day,
  //       widget.selectedHour, widget.selectedMinute);
  //   print(_selectedDateTime);
  // }
}
