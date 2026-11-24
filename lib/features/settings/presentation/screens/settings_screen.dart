import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../cubit/settings_cubit.dart';
import '../../cubit/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(
      text: context.read<SettingsCubit>().state.baseUrl,
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _applyPreset(String url) {
    _urlController.text = url;
    context.read<SettingsCubit>().updateBaseUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações da API'),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (_urlController.text != state.baseUrl) {
            _urlController.text = state.baseUrl;
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Endereço Base da API REST',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Configure o endpoint onde a API Laravel está rodando para realizar as análises dos cosméticos.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: 'Ex: http://10.0.2.2:8000/api',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.link, color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.check, color: AppColors.primary),
                      onPressed: () {
                        context
                            .read<SettingsCubit>()
                            .updateBaseUrl(_urlController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('URL da API salva com sucesso!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Atalhos Rápidos:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.android, size: 16),
                      label: const Text('Emulador Android (10.0.2.2)'),
                      onPressed: () => _applyPreset('http://10.0.2.2:8000/api'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.laptop, size: 16),
                      label: const Text('Localhost (127.0.0.1)'),
                      onPressed: () => _applyPreset('http://127.0.0.1:8000/api'),
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.restore, size: 16),
                      label: const Text('Restaurar Padrão'),
                      onPressed: () => context.read<SettingsCubit>().resetToDefault(),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: state.connectionStatus == ConnectionStatus.testing
                      ? null
                      : () => context.read<SettingsCubit>().testConnection(),
                  icon: state.connectionStatus == ConnectionStatus.testing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.network_check),
                  label: const Text('Testar Conexão com a API'),
                ),
                if (state.statusMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: state.connectionStatus == ConnectionStatus.success
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: state.connectionStatus == ConnectionStatus.success
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          state.connectionStatus == ConnectionStatus.success
                              ? Icons.check_circle
                              : Icons.error_outline,
                          color: state.connectionStatus == ConnectionStatus.success
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.statusMessage!,
                            style: TextStyle(
                              color: state.connectionStatus == ConnectionStatus.success
                                  ? const Color(0xFF065F46)
                                  : const Color(0xFF991B1B),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
