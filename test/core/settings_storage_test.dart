import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cosmetic_scanner/core/storage/settings_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsStorage', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('getBaseUrl returns default baseUrl when nothing is saved', () async {
      final storage = SettingsStorage();
      final url = await storage.getBaseUrl();
      expect(url, isNotEmpty);
      expect(url.startsWith('http'), isTrue);
    });

    test('saveBaseUrl persists and getBaseUrl retrieves updated URL', () async {
      final storage = SettingsStorage();
      const customUrl = 'https://meu-servidor-producao.com/api';
      await storage.saveBaseUrl(customUrl);

      final retrieved = await storage.getBaseUrl();
      expect(retrieved, equals(customUrl));
    });

    test('resetBaseUrl clears custom URL back to default', () async {
      final storage = SettingsStorage();
      await storage.saveBaseUrl('https://custom.com/api');
      await storage.resetBaseUrl();

      final retrieved = await storage.getBaseUrl();
      expect(retrieved, equals(SettingsStorage.defaultBaseUrl));
    });
  });
}
