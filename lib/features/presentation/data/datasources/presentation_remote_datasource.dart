import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/presentation_response.dart';
import '../models/presentation_request_model.dart';

class PresentationRemoteDataSource {
  final Dio dio;

  PresentationRemoteDataSource(this.dio);

  Future<PresentationResponse> generatePresentation(
    PresentationRequestModel request,
  ) async {
    try {
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.generatePptEndpoint}',
        data: request.toJson(),
      );

      return PresentationResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'API Error');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}