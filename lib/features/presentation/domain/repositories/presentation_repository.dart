import '../../data/models/presentation_request_model.dart';
import '../entities/presentation_response.dart';

abstract class PresentationRepository {
  Future<PresentationResponse> generatePresentation(
    PresentationRequestModel request,
  );
}