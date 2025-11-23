import 'package:equatable/equatable.dart';
import '../../data/models/presentation_request_model.dart';

abstract class PresentationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GeneratePresentationEvent extends PresentationEvent {
  final PresentationRequestModel request;

  GeneratePresentationEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class ResetPresentationEvent extends PresentationEvent {}