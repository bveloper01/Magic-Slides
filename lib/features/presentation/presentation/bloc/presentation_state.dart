import 'package:equatable/equatable.dart';
import '../../domain/entities/presentation_response.dart';

abstract class PresentationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PresentationInitial extends PresentationState {}

class PresentationLoading extends PresentationState {}

class PresentationSuccess extends PresentationState {
  final PresentationResponse response;

  PresentationSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class PresentationError extends PresentationState {
  final String message;

  PresentationError(this.message);

  @override
  List<Object?> get props => [message];
}