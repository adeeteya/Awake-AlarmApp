import 'package:awake/services/shared_prefs_with_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart' as sp;

void main() {
  setUp(() async {
    sp.SharedPreferences.setMockInitialValues(<String, Object>{});
    await SharedPreferencesWithCache.initialize();
  });

  test('get returns value set via setters', () async {
    await SharedPreferencesWithCache.instance.setInt('int', 1);
    await SharedPreferencesWithCache.instance.setDouble('double', 2.5);
    await SharedPreferencesWithCache.instance.setString('string', 'hi');

    expect(SharedPreferencesWithCache.instance.get<int>('int'), 1);
    expect(SharedPreferencesWithCache.instance.get<double>('double'), 2.5);
    expect(SharedPreferencesWithCache.instance.get<String>('string'), 'hi');
  });

  test('values are cached', () async {
    await SharedPreferencesWithCache.instance.setInt('cached', 1);
    final prefs = await sp.SharedPreferences.getInstance();
    await prefs.setInt('cached', 2);
    expect(SharedPreferencesWithCache.instance.get<int>('cached'), 1);
  });
}
