import 'package:bloc/bloc.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../../controller/splash_controller.dart';
import '../widget/cart_checkout_widget.dart';
import '../widget/cart_delivery_time_widget.dart';
import '../widget/cart_items_list_widget.dart';
import '../widget/cart_message_widget.dart';
import '../widget/cart_recipient_details_widget.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  final ScrollController scrollController = ScrollController();
  late TabController tabController;
  int activeStep = 0;
  //recipient details params
  final fullNameController = TextEditingController();
  final phoneNumerController = TextEditingController();
  final areaController = TextEditingController();
  final adressController = TextEditingController();
  final buildingNumerController = TextEditingController();
  final streetController = TextEditingController();
  final floorController = TextEditingController();
  String? countryDialCode = CountryCode.fromCountryCode(
          Get.find<SplashController>().configModel!.country!)
      .dialCode;
  bool keepSecret = false;
  //deliver time params
  String dateToday = DateFormat.yMMMMd('en_US').format(DateTime.now());
  String dateCustom = DateFormat.yMMMMd('en_US').format(DateTime.now());
  String dateTomorrow = DateFormat.yMMMMd('en_US').format(
      DateFormat.yMMMMd('en_US')
          .parse(DateFormat.yMMMMd('en_US').format(DateTime.now()))
          .add(Duration(days: 1)));
  String deliveryDate = '';
  late String arriveTimeToday = DateFormat.jm().format(DateTime.now());
  late String arriveTimeTomorrow = DateFormat.jm().format(DateTime.now());
  late String arriveTimeCustom = DateFormat.jm().format(DateTime.now());
  late String deliveryTime = '';
  final deliveryNotes = TextEditingController();

  //promoCode
  final TextEditingController couponController = TextEditingController();

  List<Widget> cartBodyList = [
    const CartItemsListWidget(),
    const CartMessageWidget(),
    const CartRecipientDetailsWidget(),
    const CartDeliveryTimeWidget(),
    CartCheckoutWidget(),
  ];
  List<DateTime?> range = [
    DateTime.now(),
  ];
  changeActiveStep(int newIndex) {
    emit(CartLoading());
    activeStep = newIndex;
    switch (tabController.index) {
      case 0:
        deliveryDate = dateToday;
        deliveryTime = arriveTimeToday;
        break;
      case 1:
        deliveryDate = dateTomorrow;
        deliveryTime = arriveTimeTomorrow;
        break;
      case 2:
        deliveryDate = dateCustom;
        deliveryTime = arriveTimeCustom;
        break;
      default:
    }
    emit(CartInitial());
  }

  changeArriveTime(DateTime newArriveTime, {bool? isToday}) {
    emit(CartLoading());
    if (isToday.runtimeType != Null) {
      if (isToday!) {
        arriveTimeToday = DateFormat.jm().format(newArriveTime);
      } else {
        arriveTimeTomorrow = DateFormat.jm().format(newArriveTime);
      }
    } else {
      arriveTimeCustom = DateFormat.jm().format(newArriveTime);
    }

    emit(CartInitial());
  }

  changeArriveDate(List<DateTime?> newArriveDate) {
    emit(CartLoading());
    range = newArriveDate;
    dateCustom = DateFormat.yMMMMd('en_US')
        .format(newArriveDate.first ?? DateTime.now());
    deliveryDate = dateCustom;
    emit(CartInitial());
  }
}
