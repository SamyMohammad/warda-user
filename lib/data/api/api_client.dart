import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import 'package:warda/data/model/response/address_model.dart';
import 'package:warda/data/model/response/error_response.dart';
import 'package:warda/data/model/response/module_model.dart';
import 'package:warda/helper/responsive_helper.dart';
import 'package:warda/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../helper/cashe_helper.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  final int timeoutInSeconds = 30;

  String? token;
  Map<String, String> _mainHeaders = {};

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token);
    if (kDebugMode) {
      print('Token: $token');
    }
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(
          jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
    } catch (_) {}
    int? moduleID;
    if (GetPlatform.isWeb &&
        sharedPreferences.containsKey(AppConstants.moduleId)) {
      try {
        // moduleID = ModuleModel.fromJson(
        //         jsonDecode(sharedPreferences.getString(AppConstants.moduleId)!))
        //     .id;
      } catch (_) {}
    }
    updateHeader(
        token,
        addressModel?.zoneIds,
        addressModel?.areaIds,
        sharedPreferences.getString(AppConstants.languageCode),
        moduleID,
        addressModel?.latitude,
        addressModel?.longitude);
  }

  Future<Map<String, String>> updateHeader(
      String? token,
      List<int>? zoneIDs,
      List<int>? operationIds,
      String? languageCode,
      int? moduleID,
      String? latitude,
      String? longitude,
      {bool setHeader = true}) async {
    Map<String, String> _header = {};
    // if (moduleID != null) {
    //   _header.addAll({AppConstants.moduleId: moduleID.toString()});
    // }
    String cityId = await CasheHelper().read(AppConstants.zoneId);
    _header.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      //   AppConstants.ZONE_ID: zoneIDs != null ? jsonEncode(zoneIDs) : null,
      AppConstants.localizationKey:
          languageCode ?? AppConstants.languages[0].languageCode!,
      // AppConstants.LATITUDE: latitude != null ? jsonEncode(latitude) : null,
      // AppConstants.LONGITUDE: longitude != null ? jsonEncode(longitude) : null,
      "moduleId": '1',
      "zoneId": '[$cityId]',
      'Authorization': 'Bearer $token'
    });
    _mainHeaders = _header;
    return _header;
  }

  void updateCityId(String cityId) {
    if (_mainHeaders.containsKey('zoneId')) {
      _mainHeaders.update('zoneId', (value) => '[$cityId]');
    } else {
      _mainHeaders.addEntries({'zoneId': '[$cityId]'}.entries);
    }
    print('hell::updateHeader ${_mainHeaders}');
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      print('====>Header: ${_mainHeaders['moduleId']} API Call: $uri ');
      if (uri == '/api/v1/config/get-zone-id') {
        print('hello:: getZone ${headers},,,,$uri');
      }
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      if (uri.contains(AppConstants.storeUri) ||
          uri.contains(AppConstants.bannerUri)) {
        //_mainHeaders.remove(AppConstants.moduleId);
      }
      http.Response response = await http
          .get(
            Uri.parse(appBaseUrl + uri),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      if (uri.contains(AppConstants.storeUri) ||
          uri.contains(AppConstants.bannerUri)) {
        //_mainHeaders.addEntries({AppConstants.moduleId: '1'}.entries);
      }
      return handleResponse(response, uri);
    } catch (e) {
      print('====> API Call: $uri\nHeader: $_mainHeaders');
      if (kDebugMode) {
        print('------------${e.toString()}');
      }
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers, int? timeout}) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
        print('====> API Body: $body');
      }
      http.Response response = await http
          .post(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeout ?? timeoutInSeconds));

      print('hell: ${jsonEncode(body)}');
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
      String uri, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, String>? headers}) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
        print('====> API Body: $body with ${multipartBody.length} picture');
      }
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      request.headers.addAll(headers ?? _mainHeaders);
      for (MultipartBody multipart in multipartBody) {
        if (multipart.file != null) {
          Uint8List list = await multipart.file!.readAsBytes();
          request.files.add(http.MultipartFile(
            multipart.key,
            multipart.file!.readAsBytes().asStream(),
            list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }
      request.fields.addAll(body);
      http.Response response =
          await http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
        print('====> API Body: $body');
      }
      http.Response response = await http
          .put(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers}) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      http.Response response = await http
          .delete(
            Uri.parse(appBaseUrl + uri),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {}
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      if (response0.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: errorResponse.errors![0].message);
      } else if (response0.body.toString().startsWith('{message')) {
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: response0.body['message']);
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage);
    }
    if (kDebugMode) {
      print('====> API Response: [${response0.statusCode}] $uri');
      if (!ResponsiveHelper.isWeb() || response.statusCode != 500) {
        print('${response0.body}');
      }
    }
    return response0;
  }
}

class MultipartBody {
  String key;
  XFile? file;

  MultipartBody(this.key, this.file);
}
