import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_client.dart';
import 'core/storage/settings_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/analysis/cubit/analysis_cubit.dart';
import 'features/analysis/data/repositories/analysis_repository.dart';
import 'features/scanner/cubit/scanner_cubit.dart';
import 'features/scanner/presentation/screens/scanner_screen.dart';
import 'features/scanner/services/image_service.dart';
import 'features/scanner/services/ocr_service.dart';
import 'features/settings/cubit/settings_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsStorage = SettingsStorage();
  final apiClient = ApiClient(storage: settingsStorage);
  final analysisRepository = AnalysisRepository(apiClient: apiClient);
  final imageService = ImageService();
  final ocrService = OcrService();

  runApp(
    CosmeticScannerApp(
      settingsStorage: settingsStorage,
      apiClient: apiClient,
      analysisRepository: analysisRepository,
      imageService: imageService,
      ocrService: ocrService,
    ),
  );
}

class CosmeticScannerApp extends StatelessWidget {
  final SettingsStorage settingsStorage;
  final ApiClient apiClient;
  final AnalysisRepository analysisRepository;
  final ImageService imageService;
  final OcrService ocrService;

  const CosmeticScannerApp({
    super.key,
    required this.settingsStorage,
    required this.apiClient,
    required this.analysisRepository,
    required this.imageService,
    required this.ocrService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (_) => SettingsCubit(
            storage: settingsStorage,
            apiClient: apiClient,
          )..loadSettings(),
        ),
        BlocProvider<ScannerCubit>(
          create: (_) => ScannerCubit(
            imageService: imageService,
            ocrService: ocrService,
          ),
        ),
        BlocProvider<AnalysisCubit>(
          create: (_) => AnalysisCubit(
            repository: analysisRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'O Que Tem No Meu Cosmético?',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const ScannerScreen(),
      ),
    );
  }
}
