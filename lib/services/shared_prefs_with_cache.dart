import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesWithCache {
  SharedPreferencesWithCache._(this._prefs);

  static SharedPreferencesWithCache? _instance;
  final SharedPreferences _prefs;
  final Map<String, Object?> _cache = {};

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = SharedPreferencesWithCache._(prefs);
  }

  static SharedPreferencesWithCache get instance {
    final inst = _instance;
    if (inst == null) {
      throw Exception('SharedPreferencesWithCache not initialized');
    }
    return inst;
  }

  T? get<T>(String key) {
    if (_cache.containsKey(key)) {
      return _cache[key] as T?;
    }
    final value = _prefs.get(key);
    _cache[key] = value;
    return value as T?;
  }

  Future<bool> setInt(String key, int value) async {
    _cache[key] = value;
    return _prefs.setInt(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    _cache[key] = value;
    return _prefs.setDouble(key, value);
  }
}
