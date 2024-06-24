import 'package:shared_preferences/shared_preferences.dart';

import 'data_storage.dart';

class ShareReferenceDataStorage extends DataStorage {
  ShareReferenceDataStorage({required this.prefs});
  final SharedPreferences prefs;
  @override
  T read<T>(String key) {
    try {
      final value = (prefs.get(key) as T);
      return value;
    } catch (e) {
      throw "Can't find value for $key with type $T with exception : $e";
    }
  }

  @override
  Future<bool> write<T>(String key, T data) async {
    if (T == int) {
      return await prefs.setInt(key, data as int);
    }
    if (T == bool) {
      return await prefs.setBool(key, data as bool);
    }
    if (T == double) {
      return await prefs.setDouble(key, data as double);
    }
    if (T == String) {
      return await prefs.setString(key, data as String);
    }
    if (T == List<String>) {
      return await prefs.setStringList(key, data as List<String>);
    }
    throw UnsupportedError("$T is not supported");
  }

  @override
  Future<bool> delete(String key) {
    return prefs.remove(key);
  }

  @override
  Future<bool> clear() {
    return prefs.clear();
  }
}
