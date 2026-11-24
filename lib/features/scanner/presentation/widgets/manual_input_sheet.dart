import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ManualInputSheet extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  const ManualInputSheet({super.key, required this.onSubmit});

  @override
  State<ManualInputSheet> createState() => _ManualInputSheetState();
}

class _ManualInputSheetState extends State<ManualInputSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _insertSampleText() {
    _controller.text =
        'AQUA / WATER, NIACINAMIDE, VASELINA, CARBOMER, PHENOXYETHANOL.';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Digitar ou Colar Composição',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Cole a lista de ingredientes do cosmético separada por vírgulas ou barras:',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Ex: Aqua, Glycerin, Niacinamide, Carbomer...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _insertSampleText,
              icon: const Icon(Icons.auto_awesome, size: 16),
              label: const Text('Preencher com exemplo de teste'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              final text = _controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(context).pop();
                widget.onSubmit(text);
              }
            },
            icon: const Icon(Icons.analytics_outlined),
            label: const Text('Analisar Ingredientes'),
          ),
        ],
      ),
    );
  }
}
