import 'package:equatable/equatable.dart';

abstract class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object?> get props => [];
}

class ScannerInitial extends ScannerState {
  const ScannerInitial();
}

class ScannerLoading extends ScannerState {
  final String message;

  const ScannerLoading([this.message = 'Processando...']);

  @override
  List<Object?> get props => [message];
}

class ScannerSuccess extends ScannerState {
  final String recognizedText;

  const ScannerSuccess(this.recognizedText);

  @override
  List<Object?> get props => [recognizedText];
}

class ScannerFailure extends ScannerState {
  final String errorMessage;

  const ScannerFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
