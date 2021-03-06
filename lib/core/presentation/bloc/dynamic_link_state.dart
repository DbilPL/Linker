import 'package:equatable/equatable.dart';
import 'package:linker/core/errors/failure.dart';

abstract class DynamicLinkState extends Equatable {
  const DynamicLinkState();
}

class InitialDynamicLinkState extends DynamicLinkState {
  @override
  List<Object> get props => [];
}

class LoadingDynamicLinkState extends DynamicLinkState {
  @override
  List<Object> get props => [];
}

class FailureLinkState extends DynamicLinkState {
  final Failure failure;

  FailureLinkState(this.failure);

  @override
  List<Object> get props => [failure];
}

class LoadLinkHandlerSuccess extends DynamicLinkState {
  final Uri uri;

  LoadLinkHandlerSuccess(this.uri);

  @override
  List<Object> get props => [uri];
}
