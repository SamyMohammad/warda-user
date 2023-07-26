import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:warda/util/app_constants.dart';

class CasheHelper {
  late FlutterSecureStorage storage;
  Future<String> read(String key) async {
    storage = const FlutterSecureStorage();
    return await storage.read(key: key) ?? '';
  }

  store(String key, String value) async {
    storage = const FlutterSecureStorage();
    await storage.write(key: key, value: value);

    if (key == AppConstants.zoneId) {
    }
  }
}
