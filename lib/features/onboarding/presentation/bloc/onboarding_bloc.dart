import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/onboarding_repository.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository repository;
  final int totalPages;

  OnboardingBloc({
    required this.repository,
    this.totalPages = 2,
  }) : super(OnboardingInitial()) {
    on<CheckOnboardingStatus>(_onCheckOnboardingStatus);
    on<CompleteOnboarding>(_onCompleteOnboarding);
    on<PageChanged>(_onPageChanged);
  }

  Future<void> _onCheckOnboardingStatus(
    CheckOnboardingStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());
    try {
      final isCompleted = await repository.isOnboardingCompleted();
      if (isCompleted) {
        emit(OnboardingCompleted());
      } else {
        emit(OnboardingNotCompleted());
      }
    } catch (e) {
      emit(OnboardingNotCompleted());
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    await repository.completeOnboarding();
    emit(OnboardingCompleted());
  }

  Future<void> _onPageChanged(
    PageChanged event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingNotCompleted) {
      final currentState = state as OnboardingNotCompleted;
      emit(currentState.copyWith(
        currentPage: event.pageIndex,
        isLastPage: event.pageIndex == totalPages - 1,
      ));
    }
  }
}