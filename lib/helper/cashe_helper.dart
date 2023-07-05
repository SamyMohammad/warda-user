import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CasheHelper {
  late FlutterSecureStorage storage;
  dynamic read(String key) async {
    storage = const FlutterSecureStorage();

    print('hell:: from helper ${await storage.read(key: key)},,');
    return await storage.read(key: key)??'';
  }

  store(String key, String value) async {
    storage = const FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }
}
