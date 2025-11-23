import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckOnboardingStatus extends OnboardingEvent {}

class CompleteOnboarding extends OnboardingEvent {}

class PageChanged extends OnboardingEvent {
  final int pageIndex;

  PageChanged(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}