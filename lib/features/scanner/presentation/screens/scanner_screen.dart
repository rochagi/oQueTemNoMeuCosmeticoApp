import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../analysis/cubit/analysis_cubit.dart';
import '../../../analysis/cubit/analysis_state.dart';
import '../../../analysis/presentation/screens/result_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../cubit/scanner_cubit.dart';
import '../../cubit/scanner_state.dart';
import '../widgets/manual_input_sheet.dart';
import '../widgets/text_review_dialog.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  void _onReviewConfirmed(BuildContext context, String text) {
    context.read<AnalysisCubit>().analyze(text);
  }

  void _showManualInput(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ManualInputSheet(
        onSubmit: (text) => _onReviewConfirmed(context, text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ScannerCubit, ScannerState>(
          listener: (context, state) {
            if (state is ScannerSuccess) {
              showDialog(
                context: context,
                builder: (_) => TextReviewDialog(
                  initialText: state.recognizedText,
                  onConfirm: (text) => _onReviewConfirmed(context, text),
                ),
              );
            } else if (state is ScannerFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: AppColors.scoreDanger,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          },
        ),
        BlocListener<AnalysisCubit, AnalysisState>(
          listener: (context, state) {
            if (state is AnalysisSuccess) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ResultScreen(result: state.result),
                ),
              );
            } else if (state is AnalysisFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: AppColors.scoreDanger,
                  action: SnackBarAction(
                    label: 'Configurar API',
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('O Que Tem No Meu Cosmético?'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Configurações da API',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<AnalysisCubit, AnalysisState>(
          builder: (context, analysisState) {
            final isAnalyzing = analysisState is AnalysisLoading;

            return BlocBuilder<ScannerCubit, ScannerState>(
              builder: (context, scannerState) {
                final isScanning = scannerState is ScannerLoading;
                final isLoading = isScanning || isAnalyzing;

                if (isLoading) {
                  final loadingText = isAnalyzing
                      ? 'Consultando banco de dados e calculando score...'
                      : (scannerState as ScannerLoading).message;

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            loadingText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.qr_code_scanner,
                                size: 44,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Descubra a verdade sobre o seu cosmético',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Fotografe a lista de ingredientes (composição/INCI) para identificar riscos, derivados de petróleo, microplásticos e ver a nota de 0 a 100.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Instructions Title
                      const Text(
                        'Como você deseja escanear?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Camera Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        onPressed: () => context
                            .read<ScannerCubit>()
                            .captureAndRecognize(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt, size: 24),
                        label: const Text(
                          'Tirar Foto (Câmera)',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Gallery Button
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                        onPressed: () => context
                            .read<ScannerCubit>()
                            .captureAndRecognize(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library, size: 24),
                        label: const Text(
                          'Escolher da Galeria',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Manual Input Button
                      TextButton.icon(
                        onPressed: () => _showManualInput(context),
                        icon: const Icon(Icons.edit_note, color: AppColors.textSecondary),
                        label: const Text(
                          'Digitar Ingredientes Manualmente',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
