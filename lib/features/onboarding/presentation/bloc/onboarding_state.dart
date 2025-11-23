import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingNotCompleted extends OnboardingState {
  final int currentPage;
  final bool isLastPage;

  OnboardingNotCompleted({
    this.currentPage = 0,
    this.isLastPage = false,
  });

  @override
  List<Object?> get props => [currentPage, isLastPage];

  OnboardingNotCompleted copyWith({
    int? currentPage,
    bool? isLastPage,
  }) {
    return OnboardingNotCompleted(
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

class OnboardingCompleted extends OnboardingState {}