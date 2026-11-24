import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cosmetic_scanner/core/network/api_client.dart';
import 'package:cosmetic_scanner/core/storage/settings_storage.dart';
import 'package:cosmetic_scanner/features/settings/cubit/settings_cubit.dart';
import 'package:cosmetic_scanner/features/settings/cubit/settings_state.dart';

class MockSettingsStorage extends Mock implements SettingsStorage {}
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockSettingsStorage mockStorage;
  late MockApiClient mockApiClient;

  setUp(() {
    mockStorage = MockSettingsStorage();
    mockApiClient = MockApiClient();
  });

  group('SettingsCubit', () {
    test('initial state has empty baseUrl and initial connection status', () {
      final cubit = SettingsCubit(storage: mockStorage, apiClient: mockApiClient);
      expect(cubit.state.baseUrl, equals(''));
      expect(cubit.state.connectionStatus, equals(ConnectionStatus.initial));
      cubit.close();
    });

    blocTest<SettingsCubit, SettingsState>(
      'loadSettings retrieves baseUrl from storage',
      build: () {
        when(() => mockStorage.getBaseUrl())
            .thenAnswer((_) async => 'http://10.0.2.2:8000/api');
        return SettingsCubit(storage: mockStorage, apiClient: mockApiClient);
      },
      act: (cubit) => cubit.loadSettings(),
      expect: () => [
        const SettingsState(baseUrl: 'http://10.0.2.2:8000/api'),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateBaseUrl saves new URL and emits updated state',
      build: () {
        when(() => mockStorage.saveBaseUrl(any()))
            .thenAnswer((_) async {});
        return SettingsCubit(storage: mockStorage, apiClient: mockApiClient);
      },
      act: (cubit) => cubit.updateBaseUrl('https://producao.com/api'),
      expect: () => [
        const SettingsState(baseUrl: 'https://producao.com/api'),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'testConnection emits testing then success on successful response',
      build: () {
        when(() => mockApiClient.get(any(), any()))
            .thenAnswer((_) async => []);
        return SettingsCubit(
          storage: mockStorage,
          apiClient: mockApiClient,
          initialBaseUrl: 'http://10.0.2.2:8000/api',
        );
      },
      act: (cubit) => cubit.testConnection(),
      expect: () => [
        const SettingsState(
          baseUrl: 'http://10.0.2.2:8000/api',
          connectionStatus: ConnectionStatus.testing,
          statusMessage: 'Testando conexão com a API...',
        ),
        const SettingsState(
          baseUrl: 'http://10.0.2.2:8000/api',
          connectionStatus: ConnectionStatus.success,
          statusMessage: 'Conexão estabelecida com sucesso!',
        ),
      ],
    );
  });
}
