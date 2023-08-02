import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:warda/data/model/response/get_countries_cities_model.dart';
import 'package:warda/view/screens/location/widget/web_landing_page.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/location_controller.dart';
import '../../../data/model/response/address_model.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_loader.dart';
import '../../base/footer_view.dart';
import '../../base/menu_drawer.dart';
import '../../base/no_data_screen.dart';
import '../address/widget/address_widget.dart';
import '../dashboard/dashboard_screen.dart';
import 'cubit/location_cubit.dart';

class AccessLocationScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String? route;
  AccessLocationScreen(
      {required this.fromSignUp, required this.fromHome, this.route});

  @override
  State<AccessLocationScreen> createState() => _AccessLocationScreenState();
}

class _AccessLocationScreenState extends State<AccessLocationScreen> {
  bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

  @override
  void initState() {
    super.initState();

    if (!widget.fromHome &&
        Get.find<LocationController>().getUserAddress() != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        Get.dialog(CustomLoader(), barrierDismissible: false);
        Get.find<LocationController>().autoNavigate(
          Get.find<LocationController>().getUserAddress(),
          widget.fromSignUp,
          widget.route,
          widget.route != null,
          ResponsiveHelper.isDesktop(context),
        );
      });
    }
    if (_isLoggedIn) {
      Get.find<LocationController>().getAddressList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'set_location'.tr,
        backButton: widget.fromHome,
        onBackPressed: () {
          Get.offNamed(RouteHelper.getInitialRoute(fromSplash: false));
        },
      ),
      endDrawer: MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: BlocBuilder<LocationCubit, LocationState>(
        bloc: BlocProvider.of<LocationCubit>(context)..getCountryData(),
        builder: (context, state) {
          final cubit = BlocProvider.of<LocationCubit>(context);
          print('location state $state');
          return SafeArea(
              child: Padding(
            padding: ResponsiveHelper.isDesktop(context)
                ? EdgeInsets.zero
                : EdgeInsets.all(Dimensions.paddingSizeSmall),
            child:
                GetBuilder<LocationController>(builder: (locationController) {
              return (ResponsiveHelper.isDesktop(context) &&
                      locationController.getUserAddress() == null)
                  ? WebLandingPage(
                      fromSignUp: widget.fromSignUp,
                      fromHome: widget.fromHome,
                      route: widget.route,
                    )
                  : !_isLoggedIn
                      ? Column(children: [
                          Expanded(
                              child: SingleChildScrollView(
                            child: FooterView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  // (locationController.addressList.isNotEmpty)
                                  //     ?
                                  locationController.addressList!.isNotEmpty
                                      ? ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: locationController
                                              .addressList!.length,
                                          itemBuilder: (context, index) {
                                            return Center(
                                                child: SizedBox(
                                                    width: 700,
                                                    child: AddressWidget(
                                                      address:
                                                          locationController
                                                                  .addressList![
                                                              index],
                                                      fromAddress: false,
                                                      onTap: () {
                                                        Get.dialog(
                                                            CustomLoader(),
                                                            barrierDismissible:
                                                                false);
                                                        AddressModel _address =
                                                            locationController
                                                                    .addressList![
                                                                index];
                                                        locationController
                                                            .saveAddressAndNavigate(
                                                          _address,
                                                          widget.fromSignUp,
                                                          widget.route,
                                                          widget.route != null,
                                                          ResponsiveHelper
                                                              .isDesktop(
                                                                  context),
                                                        );
                                                      },
                                                    )));
                                          },
                                        )
                                      : NoDataScreen(
                                          text: 'no_saved_address_found'.tr),
                                  // : Center(
                                  //     child: CircularProgressIndicator()),
                                  SizedBox(height: Dimensions.paddingSizeLarge),
                                  // ResponsiveHelper.isDesktop(context)
                                  //     ? BottomButton(
                                  //         locationController:
                                  //             locationController,
                                  //         fromSignUp: widget.fromSignUp,
                                  //         route: widget.route)
                                  //     : SizedBox(),
                                ])),
                          )),
                          // ResponsiveHelper.isDesktop(context)
                          //     ? SizedBox()
                          //     : BottomButton(
                          //         locationController: locationController,
                          //         fromSignUp: widget.fromSignUp,
                          //         route: widget.route),

                          selectCity(state, cubit)
                        ])
                      : Center(
                          child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: FooterView(
                              child: SizedBox(
                                  width: 700,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(Images.deliveryLocation,
                                            height: 220),
                                        SizedBox(
                                            height:
                                                Dimensions.paddingSizeSmall),
                                        Text(
                                            'find_stores_and_items'
                                                .tr
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: robotoMedium.copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraLarge)),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              Dimensions.paddingSizeSmall),
                                          child: Text(
                                            'by_allowing_location_access'.tr,
                                            textAlign: TextAlign.center,
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .disabledColor),
                                          ),
                                        ),
                                        selectCity(state, cubit)
                                      ]))),
                        ));
            }),
          ));
        },
      ),
    );
  }

  Widget selectCity(
    LocationState state,
    LocationCubit cubit,
  ) {
    if (state is CountiresLoaded) {
      return Column(
        children: [
          SizedBox(height: Dimensions.paddingSizeLarge),
          dropDownCoutriesCities(true, cubit, state),
          SizedBox(height: Dimensions.paddingSizeLarge),
          state.countrySelected.runtimeType != Null
              ? dropDownCoutriesCities(false, cubit, state)
              : SizedBox(),
          SizedBox(height: Dimensions.paddingSizeLarge),
          GestureDetector(
            onTap: (state.citySelected.runtimeType != Null &&
                    state.countrySelected.runtimeType != Null)
                ? () {
                    cubit.updateHeaderWithCityId();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DashboardScreen(pageIndex: 0)));
                  }
                : null,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Center(
                  child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )),
              decoration: BoxDecoration(
                  color: (state.citySelected.runtimeType != Null &&
                          state.countrySelected.runtimeType != Null)
                      ? AppConstants.primaryColor
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: Offset(0, 1))
                  ]),
            ),
          )
        ],
      );
    } else {
      return SizedBox(height: Dimensions.paddingSizeLarge);
    }
  }

  Widget dropDownCoutriesCities(
      bool isCoutry, LocationCubit cubit, LocationState state) {
    if (state is CountiresLoaded) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: DropdownButton2(
                isExpanded: true,
                hint: isCoutry
                    ? Text(
                        'Select Country',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).hintColor,
                        ),
                      )
                    : Text(
                        'Select City',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                items: !isCoutry
                    ? state.countriesCitiesModel!.countries
                        .firstWhere((element) =>
                            state.countrySelected!.id == element.id)
                        .cities
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Row(
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ))
                        .toList()
                    : state.countriesCitiesModel!.countries
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Row(
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Image.network(
                                      isCoutry ? item.flagLink : item.name,
                                      errorBuilder:
                                          ((context, error, stackTrace) {
                                        return Image.asset(Images.logoColor);
                                      }),
                                    ),
                                  ),
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                value: isCoutry ? state.countrySelected : state.citySelected,
                onChanged: (value) {
                  if (isCoutry) {
                    cubit.changeCountry(value as Country);
                  } else {
                    cubit.changeCity(value as City);
                  }
                },
                buttonStyleData: const ButtonStyleData(height: 40, width: 140),
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 200,
                ),
                menuItemStyleData: MenuItemStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
