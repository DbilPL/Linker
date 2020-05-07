import 'package:equatable/equatable.dart';

abstract class DynamicLinkEvent extends Equatable {
  const DynamicLinkEvent();
}

class LoadInitialLink extends DynamicLinkEvent {
  final Function function;

  LoadInitialLink(this.function);

  @override
  List<Object> get props => [function];
}
