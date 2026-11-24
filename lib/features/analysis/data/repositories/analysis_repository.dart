import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/analysis_result_model.dart';
import '../models/ingredient_detail_model.dart';

class AnalysisRepository {
  final ApiClient _apiClient;

  AnalysisRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Passo 1: Quick analysis (0-100 score, badges, alerts, mapped list)
  /// Sends raw OCR text to the Laravel API endpoint `POST /api/analyze/quick`
  Future<AnalysisResultModel> analyzeFormula(String rawText) async {
    final response = await _apiClient.post(
      ApiEndpoints.analyzeQuick,
      {'raw_text': rawText},
    );

    return AnalysisResultModel.fromJson(response);
  }

  /// Passo 2: Full technical dossier of an ingredient (mechanism, studies, regulation, alternatives)
  /// Calls `GET /api/ingredients/{id}`
  Future<IngredientDetailModel> getIngredientDetails(int id) async {
    final response = await _apiClient.get('${ApiEndpoints.ingredientDetails}/$id');
    return IngredientDetailModel.fromJson(response as Map<String, dynamic>);
  }
}
