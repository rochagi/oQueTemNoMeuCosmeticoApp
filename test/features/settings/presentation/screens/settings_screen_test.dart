import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cosmetic_scanner/core/network/api_client.dart';
import 'package:cosmetic_scanner/core/storage/settings_storage.dart';
import 'package:cosmetic_scanner/features/settings/cubit/settings_cubit.dart';
import 'package:cosmetic_scanner/features/settings/presentation/screens/settings_screen.dart';

class MockSettingsStorage extends Mock implements SettingsStorage {}
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockSettingsStorage mockStorage;
  late MockApiClient mockApiClient;
  late SettingsCubit settingsCubit;

  setUp(() {
    mockStorage = MockSettingsStorage();
    mockApiClient = MockApiClient();
    when(() => mockStorage.getBaseUrl())
        .thenAnswer((_) async => 'http://10.0.2.2:8000/api');
    when(() => mockStorage.saveBaseUrl(any()))
        .thenAnswer((_) async {});

    settingsCubit = SettingsCubit(
      storage: mockStorage,
      apiClient: mockApiClient,
      initialBaseUrl: 'http://10.0.2.2:8000/api',
    );
  });

  testWidgets('SettingsScreen displays title, URL field, and action buttons', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SettingsCubit>.value(
          value: settingsCubit,
          child: const SettingsScreen(),
        ),
      ),
    );

    expect(find.text('Configurações da API'), findsOneWidget);
    expect(find.text('Endereço Base da API REST'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Testar Conexão com a API'), findsOneWidget);
    expect(find.text('Emulador Android (10.0.2.2)'), findsOneWidget);
  });
}
