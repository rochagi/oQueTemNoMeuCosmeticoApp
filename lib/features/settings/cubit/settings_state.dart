import 'package:equatable/equatable.dart';

enum ConnectionStatus { initial, testing, success, failed }

class SettingsState extends Equatable {
  final String baseUrl;
  final ConnectionStatus connectionStatus;
  final String? statusMessage;

  const SettingsState({
    this.baseUrl = '',
    this.connectionStatus = ConnectionStatus.initial,
    this.statusMessage,
  });

  SettingsState copyWith({
    String? baseUrl,
    ConnectionStatus? connectionStatus,
    String? statusMessage,
  }) {
    return SettingsState(
      baseUrl: baseUrl ?? this.baseUrl,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  @override
  List<Object?> get props => [baseUrl, connectionStatus, statusMessage];
}
