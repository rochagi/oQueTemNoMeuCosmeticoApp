import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_service.dart';
import '../services/ocr_service.dart';
import 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  final ImageService _imageService;
  final OcrService _ocrService;

  ScannerCubit({
    ImageService? imageService,
    OcrService? ocrService,
  })  : _imageService = imageService ?? ImageService(),
        _ocrService = ocrService ?? OcrService(),
        super(const ScannerInitial());

  Future<void> captureAndRecognize(ImageSource source) async {
    try {
      final imagePath = await _imageService.pickAndCropImage(source);
      if (imagePath == null) {
        // User cancelled picker
        return;
      }

      emit(const ScannerLoading('Processando imagem...'));
      final text = await _ocrService.recognizeText(imagePath);

      if (text.trim().isEmpty) {
        emit(const ScannerFailure(
          'Nenhum texto identificado. Tente aproximar a câmera e melhorar a iluminação.',
        ));
      } else {
        emit(ScannerSuccess(text));
      }
    } catch (e) {
      emit(ScannerFailure('Erro ao capturar e processar imagem: $e'));
    }
  }

  void setTextManually(String text) {
    if (text.trim().isNotEmpty) {
      emit(ScannerSuccess(text.trim()));
    }
  }

  void reset() {
    emit(const ScannerInitial());
  }
}
