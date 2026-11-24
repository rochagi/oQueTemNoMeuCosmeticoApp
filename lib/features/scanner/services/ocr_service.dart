import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../../core/utils/text_cleaner.dart';

class OcrService {
  final TextRecognizer _recognizer;

  OcrService({TextRecognizer? recognizer})
      : _recognizer = recognizer ?? TextRecognizer(script: TextRecognitionScript.latin);

  /// Processes the image at [imagePath] and extracts normalized text.
  Future<String> recognizeText(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _recognizer.processImage(inputImage);
      return TextCleaner.clean(recognizedText.text);
    } catch (e) {
      throw Exception('Falha ao reconhecer texto da imagem: $e');
    }
  }

  void dispose() {
    _recognizer.close();
  }
}
