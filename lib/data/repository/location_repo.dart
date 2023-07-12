import 'package:warda/controller/splash_controller.dart';
import 'package:warda/data/api/api_client.dart';
import 'package:warda/data/model/response/address_model.dart';
import 'package:warda/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/cashe_helper.dart';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAllAddress() async {
    return await apiClient.getData(AppConstants.addressListUri);
  }

  Future<Response> getZone() async {
    return await apiClient.getData(AppConstants.zoneUri);
  }

  Future<Response> removeAddressByID(int? id) async {
    return await apiClient
        .postData('${AppConstants.removeAddressUri}$id', {"_method": "delete"});
  }

  Future<Response> addAddress(AddressModel addressModel) async {
    Map<String, dynamic> body = {
      "address_type": addressModel.addressType,
      "contact_person_name": addressModel.contactPersonName,
      "contact_person_number": addressModel.contactPersonNumber,
      "address": addressModel.address,
    };
    if (addressModel.floor.runtimeType != Null) {
      body.addEntries({"floor": addressModel.floor}.entries);
    }
    if (addressModel.house.runtimeType != Null) {
      body.addEntries({"house": addressModel.house}.entries);
    }
    // if (addressModel.additionalAddress !=null) {
    //   body.addEntries(
    //       {"additional_address": addressModel.additionalAddress}.entries);
    // }
    return await apiClient.postData(AppConstants.addAddressUri, body);
  }

  Future<Response> updateAddress(
      AddressModel addressModel, int? addressId) async {
    return await apiClient.putData(
        '${AppConstants.updateAddressUri}$addressId', addressModel.toJson());
  }

  Future<bool> saveUserAddress(String address, List<int>? zoneIDs,
      List<int>? areaIDs, String? latitude, String? longitude) async {
    apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token),
        zoneIDs,
        areaIDs,
        sharedPreferences.getString(AppConstants.languageCode),
        Get.find<SplashController>().module != null
            ? Get.find<SplashController>().module!.id
            : null,
        latitude,
        longitude);
    return await sharedPreferences.setString(AppConstants.userAddress, address);
  }

  Future<Response> getAddressFromGeocode(LatLng latLng) async {
    return await apiClient.getData(
        '${AppConstants.geocodeUri}?lat=${latLng.latitude}&lng=${latLng.longitude}');
  }

  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.userAddress);
  }

  Future<Response> searchLocation(String text) async {
    return await apiClient
        .getData('${AppConstants.searchLocationUri}?search_text=$text');
  }

  Future<Response> getPlaceDetails(String? placeID) async {
    return await apiClient
        .getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
  }
}
