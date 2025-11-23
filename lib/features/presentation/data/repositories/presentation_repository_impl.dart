import '../../domain/entities/presentation_response.dart';
import '../../domain/repositories/presentation_repository.dart';
import '../datasources/presentation_remote_datasource.dart';
import '../models/presentation_request_model.dart';

class PresentationRepositoryImpl implements PresentationRepository {
  final PresentationRemoteDataSource remoteDataSource;

  PresentationRepositoryImpl(this.remoteDataSource);

  @override
  Future<PresentationResponse> generatePresentation(
    PresentationRequestModel request,
  ) async {
    return await remoteDataSource.generatePresentation(request);
  }
}