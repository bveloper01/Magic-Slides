import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/presentation_repository.dart';
import 'presentation_event.dart';
import 'presentation_state.dart';

class PresentationBloc extends Bloc<PresentationEvent, PresentationState> {
  final PresentationRepository repository;

  PresentationBloc(this.repository) : super(PresentationInitial()) {
    on<GeneratePresentationEvent>(_onGeneratePresentation);
    on<ResetPresentationEvent>(_onReset);
  }

  Future<void> _onGeneratePresentation(
    GeneratePresentationEvent event,
    Emitter<PresentationState> emit,
  ) async {
    emit(PresentationLoading());
    try {
      final response = await repository.generatePresentation(event.request);
      if (response.success && response.url != null) {
        emit(PresentationSuccess(response));
      } else {
        emit(PresentationError(response.message));
      }
    } catch (e) {
      emit(PresentationError(e.toString()));
    }
  }

  Future<void> _onReset(
    ResetPresentationEvent event,
    Emitter<PresentationState> emit,
  ) async {
    emit(PresentationInitial());
  }
}