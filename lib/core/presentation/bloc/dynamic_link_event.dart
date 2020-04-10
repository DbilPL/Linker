import 'package:equatable/equatable.dart';

abstract class DynamicLinkEvent extends Equatable {
  const DynamicLinkEvent();
}

class LoadOnLinkHandler extends DynamicLinkEvent {
  @override
  List<Object> get props => [];
}
