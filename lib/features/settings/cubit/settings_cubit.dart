import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/settings_storage.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsStorage _storage;
  final ApiClient _apiClient;

  SettingsCubit({
    SettingsStorage? storage,
    ApiClient? apiClient,
    String? initialBaseUrl,
  })  : _storage = storage ?? SettingsStorage(),
        _apiClient = apiClient ?? ApiClient(),
        super(SettingsState(baseUrl: initialBaseUrl ?? ''));

  Future<void> loadSettings() async {
    final url = await _storage.getBaseUrl();
    emit(state.copyWith(baseUrl: url));
  }

  Future<void> updateBaseUrl(String url) async {
    await _storage.saveBaseUrl(url);
    emit(state.copyWith(
      baseUrl: url,
      connectionStatus: ConnectionStatus.initial,
      statusMessage: null,
    ));
  }

  Future<void> resetToDefault() async {
    await _storage.resetBaseUrl();
    emit(state.copyWith(
      baseUrl: SettingsStorage.defaultBaseUrl,
      connectionStatus: ConnectionStatus.initial,
      statusMessage: null,
    ));
  }

  Future<void> testConnection() async {
    emit(state.copyWith(
      connectionStatus: ConnectionStatus.testing,
      statusMessage: 'Testando conexão com a API...',
    ));

    try {
      await _apiClient.get(ApiEndpoints.ingredientsSearch, {'q': 'Aqua'});
      emit(state.copyWith(
        connectionStatus: ConnectionStatus.success,
        statusMessage: 'Conexão estabelecida com sucesso!',
      ));
    } catch (e) {
      emit(state.copyWith(
        connectionStatus: ConnectionStatus.failed,
        statusMessage: 'Falha ao conectar: $e',
      ));
    }
  }
}
