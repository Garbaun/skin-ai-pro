import 'dart:io';
import 'package:dio/dio.dart';
import 'package:skin_ai_clean/core/models/analysis_models.dart';

class VLMService {
  static const String _baseUrl = 'https://api.example.com'; // VLM API URL
  static const String _apiKey = 'your-vlm-api-key'; // VLM API Key
  
  final Dio _dio = Dio();

  VLMService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers['Authorization'] = 'Bearer $_apiKey';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  // Analyze skin from image
  Future<SkinAnalysisResult> analyzeImage(File imageFile) async {
    try {
      // Convert image to base64 or multipart
      String fileName = imageFile.path.split('/').last;
      
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        'analysis_type': 'skin_analysis',
        'detailed': true,
      });

      final response = await _dio.post(
        '/analyze',
        data: formData,
      );

      if (response.statusCode == 200) {
        return SkinAnalysisResult.fromJson(response.data);
      } else {
        throw Exception('Analysis failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to analyze image: $e');
    }
  }

  // Get analysis history
  Future<List<SkinAnalysisResult>> getAnalysisHistory(String userId) async {
    try {
      final response = await _dio.get(
        '/history',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'] ?? [];
        return data.map((json) => SkinAnalysisResult.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get history: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get analysis history: $e');
    }
  }

  // Get product recommendations based on analysis
  Future<List<ProductRecommendation>> getProductRecommendations(String analysisId) async {
    try {
      final response = await _dio.get(
        '/recommendations',
        queryParameters: {'analysis_id': analysisId},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['products'] ?? [];
        return data.map((json) => ProductRecommendation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get recommendations: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get product recommendations: $e');
    }
  }

  // Compare two analyses
  Future<ComparisonResult> compareAnalyses(String analysisId1, String analysisId2) async {
    try {
      final response = await _dio.post(
        '/compare',
        data: {
          'analysis_id_1': analysisId1,
          'analysis_id_2': analysisId2,
        },
      );

      if (response.statusCode == 200) {
        return ComparisonResult.fromJson(response.data);
      } else {
        throw Exception('Failed to compare: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to compare analyses: $e');
    }
  }
}