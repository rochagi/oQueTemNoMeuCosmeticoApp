import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cosmetic_scanner/features/scanner/cubit/scanner_cubit.dart';
import 'package:cosmetic_scanner/features/scanner/cubit/scanner_state.dart';
import 'package:cosmetic_scanner/features/scanner/services/image_service.dart';
import 'package:cosmetic_scanner/features/scanner/services/ocr_service.dart';

class MockImageService extends Mock implements ImageService {}
class MockOcrService extends Mock implements OcrService {}

void main() {
  late MockImageService mockImageService;
  late MockOcrService mockOcrService;

  setUp(() {
    mockImageService = MockImageService();
    mockOcrService = MockOcrService();
  });

  group('ScannerCubit', () {
    test('initial state is ScannerInitial', () {
      final cubit = ScannerCubit(
        imageService: mockImageService,
        ocrService: mockOcrService,
      );
      expect(cubit.state, equals(const ScannerInitial()));
      cubit.close();
    });

    blocTest<ScannerCubit, ScannerState>(
      'emits [ScannerLoading, ScannerSuccess] when image picked and text recognized',
      build: () {
        when(() => mockImageService.pickAndCropImage(ImageSource.camera))
            .thenAnswer((_) async => '/path/to/cropped_image.jpg');
        when(() => mockOcrService.recognizeText('/path/to/cropped_image.jpg'))
            .thenAnswer((_) async => 'AQUA, GLYCERIN, NIACINAMIDE');

        return ScannerCubit(
          imageService: mockImageService,
          ocrService: mockOcrService,
        );
      },
      act: (cubit) => cubit.captureAndRecognize(ImageSource.camera),
      expect: () => [
        const ScannerLoading('Processando imagem...'),
        const ScannerSuccess('AQUA, GLYCERIN, NIACINAMIDE'),
      ],
    );

    blocTest<ScannerCubit, ScannerState>(
      'emits [ScannerLoading, ScannerFailure] when no text found in image',
      build: () {
        when(() => mockImageService.pickAndCropImage(ImageSource.gallery))
            .thenAnswer((_) async => '/path/to/blank.jpg');
        when(() => mockOcrService.recognizeText('/path/to/blank.jpg'))
            .thenAnswer((_) async => '');

        return ScannerCubit(
          imageService: mockImageService,
          ocrService: mockOcrService,
        );
      },
      act: (cubit) => cubit.captureAndRecognize(ImageSource.gallery),
      expect: () => [
        const ScannerLoading('Processando imagem...'),
        const ScannerFailure('Nenhum texto identificado. Tente aproximar a câmera e melhorar a iluminação.'),
      ],
    );

    blocTest<ScannerCubit, ScannerState>(
      'emits nothing when user cancels image picker',
      build: () {
        when(() => mockImageService.pickAndCropImage(ImageSource.camera))
            .thenAnswer((_) async => null);

        return ScannerCubit(
          imageService: mockImageService,
          ocrService: mockOcrService,
        );
      },
      act: (cubit) => cubit.captureAndRecognize(ImageSource.camera),
      expect: () => [],
    );

    blocTest<ScannerCubit, ScannerState>(
      'setTextManually directly emits ScannerSuccess',
      build: () => ScannerCubit(
        imageService: mockImageService,
        ocrService: mockOcrService,
      ),
      act: (cubit) => cubit.setTextManually('AQUA, RETINOL'),
      expect: () => [
        const ScannerSuccess('AQUA, RETINOL'),
      ],
    );
  });
}
