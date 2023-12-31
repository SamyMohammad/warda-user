import 'package:bloc/bloc.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:universal_html/html.dart' as html;

import '../../../../controller/auth_controller.dart';
import '../../../../controller/cart_controller.dart';
import '../../../../controller/coupon_controller.dart';
import '../../../../controller/location_controller.dart';
import '../../../../controller/order_controller.dart';
import '../../../../controller/splash_controller.dart';
import '../../../../controller/store_controller.dart';
import '../../../../controller/user_controller.dart';
import '../../../../data/model/body/place_order_body.dart';
import '../../../../data/model/response/address_model.dart';
import '../../../../data/model/response/cart_model.dart';
import '../../../../data/model/response/config_model.dart';
import '../../../../data/model/response/questions_model.dart';
import '../../../../helper/date_converter.dart';
import '../../../../helper/price_converter.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/app_constants.dart';
import '../../../base/custom_snackbar.dart';
import '../../home/home_screen.dart';
import '../widget/cart_checkout_widget.dart';
import '../widget/cart_delivery_time_widget.dart';
import '../widget/cart_items_list_widget.dart';
import '../widget/cart_message_widget.dart';
import '../widget/cart_recipient_details_widget.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
  bool showLinkArrowUp = false;
  String? paymentKey;

  //deliver time params
  // String dateToday = DateFormat.yMMMMd('en_US').format(DateTime.now());
  // String dateTomorrow = DateFormat.yMMMMd('en_US').format(
  //     DateFormat.yMMMMd('en_US')
  //         .parse(DateFormat.yMMMMd('en_US').format(DateTime.now()))
  //         .add(Duration(days: 1)));
  String dateCustom = DateFormat.yMMMMd('en_US').format(DateTime.now());

  String deliveryDate = '';

  // late String arriveTimeToday = DateFormat.jm().format(DateTime.now());
  // late String arriveTimeTomorrow = DateFormat.jm().format(DateTime.now());
  // late String arriveTimeCustom = currentOption;
  late String deliveryTime = '';
  final deliveryNotes = TextEditingController();

  //Message
  String? generatedMessage;
  bool showGeneratedMessage = false;
  bool showGeneratedQrCode = false;
  bool generateMessageWithAI = false;
  Map<String, TextEditingController>? messageQuestionsControllers;
  Map<String, bool>? messageQuestionsBool;
  Map<String, List<Map<String, bool>>>? questionChoises;
  final TextEditingController linkSongController = TextEditingController();
  List<Question> questions = [];
  final messageController = TextEditingController();

  //promoCode
  final TextEditingController couponController = TextEditingController();

  List<Widget> cartBodyList = [
    const CartItemsListWidget(),
    const CartRecipientDetailsWidget(),
    const CartDeliveryTimeWidget(),
    const CartMessageWidget(),
    CartCheckoutWidget(),
  ];
  DateTime initialDateTime = DateTime.now();

  late List<DateTime?> range = [initialDateTime];

  changePaymentMethod(String key) {
    emit(CartLoading());
    paymentKey = key;
    emit(CartInitial());
  }

  changeLinkArrowUp() {
    emit(CartLoading());
    showLinkArrowUp = !showLinkArrowUp;
    emit(CartInitial());
  }

  getQuestions() {
    emit(CartLoading());
    messageQuestionsControllers = {};
    questionChoises = {};
    messageQuestionsBool = {};
    questions = Get.find<OrderController>().questionsList ?? [];
    for (var element in questions) {
      if (element.type != 'text') {
        messageQuestionsBool?.addEntries({element.q: false}.entries);
      } else {
        if (element.choices.isNotEmpty) {
          List<Map<String, bool>> chociesList = [];

          for (var choice in element.choices) {
            chociesList.add({choice.name: false});
          }
          questionChoises?[element.q] = chociesList;
          print('helloOO ;:: ${questionChoises?.entries}');
        } else {
          messageQuestionsControllers
              ?.addEntries({element.q: TextEditingController()}.entries);
        }
      }
    }
    print('helll::: ${messageQuestionsControllers?.length}');
    emit(CartInitial());
  }

  changeQuestionBoolValue(Question question, bool value,
      {bool isChoice = false, String? choiceName}) {
    emit(CartLoading());
    if (isChoice && choiceName.runtimeType != Null) {
      List<Map<String, bool>> choiseList = questionChoises?[question.q] ?? [];
      for (var element in choiseList) {
        element.updateAll((key, value) => false);
      }
      for (var element in choiseList) {
        if (element.containsKey(choiceName)) {
          element[choiceName!] = value;
        }
      }
    } else {
      messageQuestionsBool?[question.q] = value;
    }
    emit(CartInitial());
  }

  showQuestion() {
    emit(CartLoading());
    showGeneratedMessage = false;
    messageController.clear();
    generateMessageWithAI = true;

    emit(CartInitial());
  }

  generateQrCode() {
    emit(CartLoading());
    if (linkSongController.text.isNotEmpty) {
      showGeneratedQrCode = true;
    } else {
      print('errrrr::');
      showCustomSnackBar('please add media link', isError: true);
    }
    emit(CartInitial());
  }

  changeAudioLink() {
    emit(CartLoading());
    showGeneratedQrCode = false;
    emit(CartInitial());
  }

  showMessageController() {
    emit(CartLoading());
    showGeneratedMessage = false;
    generatedMessage = null;
    generateMessageWithAI = false;

    emit(CartInitial());
  }

  generateMessage() async {
    emit(CartLoading());
    List<Map<String, String>> answers = [];
    for (var element in questions) {
      if (element.type == 'text') {
        List<Map<String, bool>> choiseList = questionChoises?[element.q] ?? [];
        bool containChoise = false;
        for (var element in choiseList) {
          containChoise = element.containsValue(true);
        }

        if (element.choices.isNotEmpty && containChoise) {
          // choiseList.firstWhere((element) => false);
          var choice =
              choiseList.firstWhere((element) => element.values.first == true);
          answers.add({"q": element.q, "a": choice.keys.first});
        } else {
          answers.add({
            "q": element.q,
            "a": messageQuestionsControllers![element.q]?.text ?? ""
          });
        }
      } else {
        answers.add(
            {"q": element.q, "a": messageQuestionsBool![element.q].toString()});
      }
    }

    Map<String, dynamic> body = {"answers": answers};

    await Get.find<OrderController>().generateMessage(body);
    generatedMessage = Get.find<OrderController>().generatedMessage ?? '';
    showGeneratedMessage = true;

    emit(CartInitial());
  }

  changeActiveStep(int newIndex) {
    emit(CartLoading());
    print('hello::: ${newIndex}');

    activeStep = newIndex;
    deliveryDate = dateCustom;
    deliveryTime = currentOption;
    // if (tabController.runtimeType != Null) {
    //   switch (tabController.index) {
    //     case 0:
    //       deliveryDate = dateToday;
    //       deliveryTime = arriveTimeToday;
    //       break;
    //     case 1:
    //       deliveryDate = dateTomorrow;
    //       deliveryTime = arriveTimeTomorrow;
    //       break;
    //     case 2:
    //       deliveryDate = dateCustom;
    //       deliveryTime = arriveTimeCustom;
    //       break;
    //     default:
    //   }
    // }
    emit(CartInitial());
  }

  Map<int, String>? validator(int index) {
    print('hello plz validate this $index');
    Map<int, Map<String, dynamic>> inputs = {
      3: {
        // 'message_to'.tr:messageToController,
        //'message'.tr: messageController,
        //'message_to'.tr:messageToController,
        //'link'.tr:linkSongController,
      },
      1: {
        'receiver_name'.tr: fullNameController.text,
        'receiver_phone_number'.tr: phoneNumerController.text,
        'receiver_address'.tr: adressController.text,
      },
      2: {'delivery_time'.tr: deliveryDate, 'time'.tr: deliveryTime},
    };

    for (var indexKey in inputs.keys) {
      if (indexKey <= index) {
        for (var element in inputs[indexKey]!.entries) {
          if (element.value.isEmpty) {
            return {indexKey: '${element.key.tr} ${'required'.tr}'};
          }
        }
      }
    }
  }

  List<String?> timeSlots = [];

  late String currentOption = timeSlots[0]!;

  onChangedRadioButton(String? value) {
    emit(CartLoading());
    currentOption = value.toString();
    deliveryTime = currentOption;

    print('deliveryTime$deliveryTime');

    emit(CartInitial());
  }

  changeArriveTime(DateTime newArriveTime, {bool? isToday}) {
    emit(CartLoading());

    deliveryTime = DateFormat.jm().format(newArriveTime);

    emit(CartInitial());
  }

  changeArriveDate(List<DateTime?> newArriveDate) {
    emit(CartLoading());
    range = newArriveDate;
    dateCustom = DateFormat.yMMMMd('en_US')
        .format(newArriveDate.first ?? DateTime.now());
    deliveryDate = dateCustom;
    getTimeSlotsList();
    currentOption = timeSlots[0]!;
    deliveryTime = currentOption;
    emit(CartInitial());
  }

  DateTime getOpeningTime({required num day}) {
    List<StoreSchedule>? storeSchedule =
        Get.find<SplashController>().configModel!.storeSchedule!;
    StoreSchedule selectedDay = StoreSchedule();
    if (!getDisabledDays().contains(day)) {
      selectedDay = storeSchedule.firstWhere((time) => time.day == day);
    }

    return convertStringToDateTime("20:40:30" ?? "20:40:30");
  }

  DateTime getClosingTime({required num day}) {
    List<StoreSchedule>? storeSchedule =
        Get.find<SplashController>().configModel!.storeSchedule!;
    StoreSchedule selectedDay = StoreSchedule();
// timeSlots.last;
    print('timeSlotsLast');
    print(timeSlots.last);
    int lastIndex = timeSlots.length - 1;
    String? lastTime = timeSlots[lastIndex];
    var closingTime = '${lastTime?.substring(0, 5)}';
    print('closingTime $closingTime:00');
    if (!getDisabledDays().contains(day)) {
      selectedDay = storeSchedule.firstWhere((time) => time.day == day);
    }
    return convertStringToDateTime("$closingTime:00" ?? "01:59:59");
  }

  getTimeSlotsList() {
    List<StoreSchedule>? storeSchedule =
        Get.find<SplashController>().configModel!.storeSchedule!;
    StoreSchedule selectedDay = StoreSchedule();
    final day = convertDateTimeDayToDaysFromApi(range.first?.weekday ?? 0);
    if (!getDisabledDays().contains(day)) {
      selectedDay = storeSchedule.firstWhere((time) => time.day == day);
    }
    print('selectedDay${selectedDay.timeSlots}');

    timeSlots = selectedDay.timeSlots ?? [];
  }

  DateTime convertStringToDateTime(String timeString) {
    DateFormat format = DateFormat.Hms();
    DateTime dateTime = format.parse(timeString);
    print(' date time $dateTime');

    return dateTime;
  }

  bool isTomorrow() {
    return DateTime.now().isAfter(getClosingTime(
        day: convertDateTimeDayToDaysFromApi(DateTime.now().weekday)));
    // return current.isAfter(startTime) && current.isBefore(endTime);
  }

  String? selectedValue;

  getFirstDate() {
    int counter = 0;
    DateTime firstDateTime = DateTime.now();
    List<num?>? storeScheduleDays = Get.find<SplashController>()
        .configModel!
        .storeSchedule!
        .map((schedule) => schedule?.day)
        .toList();
    // firstDateTime =  storeScheduleDays.firstWhere((element) => storeScheduleDays.contains(element),orElse:()=>-1 );
    if (isTomorrow()) {
      counter++;
      while (true) {
        if (!storeScheduleDays.contains(convertDateTimeDayToDaysFromApi(
            firstDateTime.add(Duration(days: counter)).weekday))) {
          counter++;
        }

        if (storeScheduleDays.contains(convertDateTimeDayToDaysFromApi(
            firstDateTime.add(Duration(days: counter)).weekday))) {
          break;
        }
      }
      print('firstDateTimedActive');
      print(counter);
      initialDateTime = firstDateTime.add(Duration(days: counter));
      // return firstDateTime.add(Duration(days: counter));
    } else {
      initialDateTime = firstDateTime;
      // return firstDateTime;
    }
  }

  List<num> getDisabledDays() {
    List<num?>? storeScheduleDays = Get.find<SplashController>()
        .configModel!
        .storeSchedule!
        .map((schedule) => schedule?.day)
        .toList();

    List<num> disabledDays = [];
    for (var i = 0; i <= 6; i++) {
      if (!storeScheduleDays.contains(i)) {
        disabledDays.add(i);
      }
    }

    return disabledDays;
  }

// List<String?> timeSlots=Get.find<SplashController>()
//       .configModel!
//       .storeSchedule!
//       .map((schedule) => schedule?.timeSlots)
//       .toList();
  bool isDaySelectable(DateTime day) {
    List<num?>? storeScheduleDays = Get.find<SplashController>()
        .configModel!
        .storeSchedule!
        .map((schedule) => schedule?.day)
        .toList();
    print('storeScheduleDays $storeScheduleDays');
    List<num> disabledDays = [];
    for (var i = 0; i <= 6; i++) {
      if (!storeScheduleDays.contains(i)) {
        disabledDays.add(i);
      }
    }

    return storeScheduleDays!.contains(day.weekday);
// for
//     return day.weekday != DateTime.saturday && day.weekday != DateTime.sunday;
  }

  convertDaysFromApiToDateTimeDay(int day) {
    switch (day) {
      case 0:
        return DateTime.sunday;
      case 1:
        return DateTime.monday;
      case 2:
        return DateTime.tuesday;
      case 3:
        return DateTime.wednesday;
      case 4:
        return DateTime.thursday;
      case 5:
        return DateTime.friday;
      case 6:
        return DateTime.saturday;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }

  convertDateTimeDayToDaysFromApi(int day) {
    switch (day) {
      case 7:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 3;
      case 4:
        return 4;
      case 5:
        return 5;
      case 6:
        return 6;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }

  String convertTimeFormat(String inputTime) {
    // Split the input time into start and end times
    List<String> times = inputTime.split('-');

    // Convert the times to 12-hour format with AM/PM labels
    String formattedStartTime = formatTime(times[0]);
    String formattedEndTime = formatTime(times[1]);

    return '$formattedStartTime - $formattedEndTime';
  }

  String formatTime(String time) {
    // Split the time into hours and minutes
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    // Determine AM or PM
    String period = (hours < 12) ? 'AM' : 'PM';

    // Convert hours to 12-hour format
    if (hours > 12) {
      hours -= 12;
    }

    // Format the time
    String formattedTime =
        '$hours:${minutes.toString().padLeft(2, '0')} $period';

    return formattedTime;
  }

  placeOrder(
      OrderController orderController,
      CartController cartController,
      StoreController storeController,
      double orderAmount,
      int? storeID,
      double? maxCodOrderAmount,
      double total,
      double deliveryCharge,
      double tax,
      double discount) {
    List<CartModel>? _cartList = cartController.cartList;
    bool isAvailable = true;
    bool? _isCashOnDeliveryActive =
        Get.find<SplashController>().configModel!.cashOnDelivery!;
    bool? _isDigitalPaymentActive =
        Get.find<SplashController>().configModel!.digitalPayment!;
    bool? _isWalletActive =
        Get.find<SplashController>().configModel!.customerWalletStatus == 1;

    bool todayClosed = storeController.isStoreClosed(
        true,
        storeController.store!.active!,
        storeController.store!.schedules,
        storeController.store!.orderPlaceToScheduleInterval,
        storeController.store!.open);
    bool tomorrowClosed = storeController.isStoreClosed(
        false,
        storeController.store!.active!,
        storeController.store!.schedules,
        storeController.store!.orderPlaceToScheduleInterval,
        storeController.store!.open);
    DateTime scheduleStartDate = DateTime.now();
    DateTime scheduleEndDate = DateTime.now();
    if (orderController.timeSlots == null ||
        orderController.timeSlots!.isEmpty) {
      // isAvailable = false;
    } else {
      DateTime date = orderController.selectedDateSlot == 0
          ? DateTime.now()
          : DateTime.now().add(const Duration(days: 1));
      DateTime startTime = orderController
          .timeSlots![orderController.selectedTimeSlot].startTime!;
      DateTime endTime =
          orderController.timeSlots![orderController.selectedTimeSlot].endTime!;
      scheduleStartDate = DateTime(date.year, date.month, date.day,
          startTime.hour, startTime.minute + 1);
      scheduleEndDate = DateTime(
          date.year, date.month, date.day, endTime.hour, endTime.minute + 1);
      if (_cartList.isNotEmpty) {
        for (CartModel? cart in _cartList) {
          if (!DateConverter.isAvailable(
                cart!.item!.availableTimeStarts,
                cart.item!.availableTimeEnds,
                time: storeController.store!.scheduleOrder!
                    ? scheduleStartDate
                    : null,
              ) &&
              !DateConverter.isAvailable(
                cart.item!.availableTimeStarts,
                cart.item!.availableTimeEnds,
                time: storeController.store!.scheduleOrder!
                    ? scheduleEndDate
                    : null,
              )) {
            isAvailable = false;
            break;
          }
        }
      }
    }
    if (!_isCashOnDeliveryActive &&
        !_isDigitalPaymentActive &&
        !_isWalletActive) {
      showCustomSnackBar('no_payment_method_is_enabled'.tr);
    } else if (orderAmount < storeController.store!.minimumOrder! &&
        storeID == null) {
      showCustomSnackBar(
          '${'minimum_order_amount_is'.tr} ${storeController.store!.minimumOrder}');
    } else if ((
            // orderController.selectedDateSlot == 0 &&
            todayClosed) ||
        (orderController.selectedDateSlot == 1 && tomorrowClosed)) {
      showCustomSnackBar(Get.find<SplashController>()
              .configModel!
              .moduleConfig!
              .module!
              .showRestaurantText!
          ? 'restaurant_is_closed'.tr
          : 'store_is_closed'.tr);
    } else if (orderController.paymentMethodIndex == 0 &&
        _isCashOnDeliveryActive &&
        maxCodOrderAmount != null &&
        maxCodOrderAmount != 0 &&
        (total > maxCodOrderAmount) &&
        storeID == null) {
      showCustomSnackBar(
          '${'you_cant_order_more_then'.tr} ${PriceConverter.convertPrice(maxCodOrderAmount)} ${'in_cash_on_delivery'.tr}');
    } else if (orderController.paymentMethodIndex != 0 && storeID != null) {
      showCustomSnackBar('payment_method_is_not_available'.tr);
    } else if (!isAvailable) {
      showCustomSnackBar(
          'one_or_more_products_are_not_available_for_this_selected_time'.tr);
    } else if (orderController.orderType != 'take_away' &&
        orderController.distance == -1 &&
        deliveryCharge == -1) {
      showCustomSnackBar('delivery_fee_not_set_yet'.tr);
    } else if (storeID != null && storeController.pickedPrescriptions.isEmpty) {
      showCustomSnackBar('please_upload_your_prescription_images'.tr);
    } else if (!orderController.acceptTerms) {
      showCustomSnackBar(
          'please_accept_privacy_policy_trams_conditions_refund_policy_first'
              .tr);
    } else {
      // AddressModel? finalAddress = address[orderController.addressIndex ?? 0];

      if (storeID == null) {
        List<Cart> carts = [];
        for (int index = 0; index < _cartList.length; index++) {
          CartModel cart = _cartList[index];
          List<int?> addOnIdList = [];
          List<int?> addOnQtyList = [];
          for (var addOn in cart.addOnIds!) {
            addOnIdList.add(addOn.id);
            addOnQtyList.add(addOn.quantity);
          }

          List<OrderVariation> variations = [];
          if (Get.find<SplashController>()
              .getModuleConfig(cart.item!.moduleType)
              .newVariation!) {
            for (int i = 0; i < cart.item!.foodVariations!.length; i++) {
              if (cart.foodVariations![i].contains(true)) {
                variations.add(OrderVariation(
                    name: cart.item!.foodVariations![i].name,
                    values: OrderVariationValue(label: [])));
                for (int j = 0;
                    j < cart.item!.foodVariations![i].variationValues!.length;
                    j++) {
                  if (cart.foodVariations![i][j]!) {
                    variations[variations.length - 1].values!.label!.add(cart
                        .item!.foodVariations![i].variationValues![j].level);
                  }
                }
              }
            }
          }
          carts.add(Cart(
            cart.isCampaign! ? null : cart.item!.id,
            cart.isCampaign! ? cart.item!.id : null,
            cart.discountedPrice.toString(),
            '',
            Get.find<SplashController>()
                    .getModuleConfig(cart.item!.moduleType)
                    .newVariation!
                ? null
                : cart.variation,
            Get.find<SplashController>()
                    .getModuleConfig(cart.item!.moduleType)
                    .newVariation!
                ? variations
                : null,
            cart.quantity,
            addOnIdList,
            cart.addOns,
            addOnQtyList,
          ));
        }

        orderController.placeOrder(
            PlaceOrderBody(
              cart: carts,
              couponDiscountAmount: Get.find<CouponController>().discount,
              distance: 0,
              scheduleAt: !storeController.store!.scheduleOrder!
                  ? null
                  : (orderController.selectedDateSlot == 0 &&
                          orderController.selectedTimeSlot == 0)
                      ? null
                      : DateConverter.dateToDateAndTime(scheduleEndDate),
              orderAmount: total,
              orderNote: deliveryNotes.text,
              orderType: orderController.orderType,
              paymentMethod: paymentKey ?? '',
              couponCode: (Get.find<CouponController>().discount! > 0 ||
                      (Get.find<CouponController>().coupon != null &&
                          Get.find<CouponController>().freeDelivery))
                  ? Get.find<CouponController>().coupon!.code
                  : null,
              storeId: _cartList[0].item!.storeId,
              // address: finalAddress.address,
              // latitude: finalAddress.latitude,
              // longitude: finalAddress.longitude,
              // addressType: finalAddress.addressType,
              // contactPersonName: finalAddress.contactPersonName ??
              //     '${Get.find<UserController>().userInfoModel!.fName} '
              //         '${Get.find<UserController>().userInfoModel!.lName}',
              // contactPersonNumber: finalAddress.contactPersonNumber ??
              //     Get.find<UserController>().userInfoModel!.phone,
              // streetNumber: _streetNumberController.text.trim(),
              // house: _houseController.text.trim(),
              // floor: _floorController.text.trim(),
              address: adressController.text,
              latitude: '',
              longitude: '',
              addressType: 'home',
              contactPersonName: fullNameController.text,
              contactPersonNumber:
                  '${countryDialCode ?? ''}${phoneNumerController.text}',
              streetNumber: '',
              house: '',
              floor: '',
              discountAmount: discount,
              taxAmount: tax,
              receiverDetails: null,
              parcelCategoryId: null,
              chargePayer: null,
              dmTips: '',
              cutlery: Get.find<CartController>().addCutlery ? 1 : 0,
              unavailableItemNote:
                  Get.find<CartController>().notAvailableIndex != -1
                      ? Get.find<CartController>().notAvailableList[
                          Get.find<CartController>().notAvailableIndex]
                      : '',
              deliveryInstruction: deliveryNotes.text,
              keepSecret: keepSecret ? 1 : 0,

              deliveryDate: deliveryDate,
              deliveryTime: deliveryTime,
              cardMessage: messageController.text.isEmpty
                  ? generatedMessage ?? ""
                  : messageController.text,
              attachmentLink: linkSongController.text,
            ),
            storeController.store!.zoneId,
            _callback,
            total,
            maxCodOrderAmount);
      } else {
        print('helllo:::: placePrescriptionOrder');
        // orderController.placePrescriptionOrder(
        //     storeID,
        //     storeController.store!.zoneId,
        //     orderController.distance,
        //     finalAddress.address!,
        //     finalAddress.longitude!,
        //     finalAddress.latitude!,
        //     _noteController.text,
        //     storeController.pickedPrescriptions,
        //     _tipController.text.trim(),
        //     orderController.selectedInstruction != -1
        //         ? AppConstants.deliveryInstructionList[
        //             orderController.selectedInstruction]
        //         : '',
        //     _callback,
        //     0,
        //     0);
      }
    }
  }

  void _callback(
    bool isSuccess,
    String? message,
    String orderID,
    int? zoneID,
    double amount,
    double? maximumCodOrderAmount,
  ) async {
    bool? _isCashOnDeliveryActive =
        Get.find<SplashController>().configModel!.cashOnDelivery!;
    if (isSuccess) {
      if (true) {
        Get.find<CartController>().clearCartList();
      }
      if (!Get.find<OrderController>().showBottomSheet) {
        Get.find<OrderController>().showRunningOrders();
      }
      if (Get.find<OrderController>().isDmTipSave) {
        Get.find<AuthController>().saveDmTipIndex(
            Get.find<OrderController>().selectedTips.toString());
      }
      Get.find<OrderController>().stopLoader();
      HomeScreen.loadData(true);
      if (Get.find<OrderController>().paymentMethodIndex == 1) {
        if (GetPlatform.isWeb) {
          Get.back();
          String? hostname = html.window.location.hostname;
          String protocol = html.window.location.protocol;
          String selectedUrl =
              '${AppConstants.baseUrl}/payment-mobile?order_id=$orderID&&customer_id=${Get.find<UserController>().userInfoModel!.id}&&callback=$protocol//$hostname${RouteHelper.orderSuccess}?id=$orderID&status=';
          html.window.open(selectedUrl, "_self");
        } else {
          Get.offNamed(RouteHelper.getPaymentRoute(
              orderID,
              Get.find<UserController>().userInfoModel!.id,
              Get.find<OrderController>().orderType,
              amount,
              _isCashOnDeliveryActive));
        }
      } else {
        double total = ((amount / 100) *
            Get.find<SplashController>()
                .configModel!
                .loyaltyPointItemPurchasePoint!);
        Get.find<AuthController>().saveEarningPoint(total.toStringAsFixed(0));
        Get.offNamed(RouteHelper.getOrderSuccessRoute(orderID));
      }
      Get.find<OrderController>().clearPrevData(zoneID);
      Get.find<CouponController>().removeCouponData(false);
      Get.find<OrderController>().updateTips(
          Get.find<AuthController>().getDmTipIndex().isNotEmpty
              ? int.parse(Get.find<AuthController>().getDmTipIndex())
              : 1,
          notify: false);
    } else {
      showCustomSnackBar(message);
    }
  }

  setupCountryCode(UserController userController) async {
    emit(CartLoading());
    if (userController.userInfoModel != null) {
      PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
          userController.userInfoModel?.phone ?? '');
      countryDialCode = '+${number.dialCode}';

      phoneNumerController.text = userController.userInfoModel?.phone
              ?.replaceFirst(countryDialCode ?? '', "") ??
          '';
      print(';hellllO ${userController.userInfoModel!.phone}');
      print(';hellllO countryDialCode ${countryDialCode}');
      print(';hellllO phoneNumerController ${number.phoneNumber}');
      String fullname =
          '${userController.userInfoModel!.fName ?? ''} ${userController.userInfoModel!.lName ?? ''}';
      fullNameController.text = fullname;
    }

    deliveryDate = dateCustom;
    deliveryTime = currentOption;
    emit(CartInitial());
  }

  addAddress(
    LocationController locationController,
  ) {
    AddressModel addressModel = AddressModel(
      id: null,
      addressType: 'addressType',
      contactPersonName: fullNameController.text,
      contactPersonNumber: countryDialCode! + phoneNumerController.text,
      address: adressController.text,
      latitude: locationController.position.latitude.toString(),
      longitude: locationController.position.longitude.toString(),
      zoneId: locationController.zoneID,
      streetNumber: streetController.text,
      house: buildingNumerController.text,
      floor: floorController.text,
    );
    locationController
        .addAddress(addressModel, true, false, null)
        .then((response) {
      if (response.isSuccess) {
        Get.back(result: addressModel);
        showCustomSnackBar('new_address_added_successfully'.tr, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    });
  }
}
