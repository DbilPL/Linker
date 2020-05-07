import 'package:equatable/equatable.dart';

abstract class DynamicLinkEvent extends Equatable {
  const DynamicLinkEvent();
}

class LoadInitialLink extends DynamicLinkEvent {
  @override
  List<Object> get props => [];
}

class SetOnLinkHandlerEvent extends DynamicLinkEvent {

  final Function onSuccess;

  SetOnLinkHandlerEvent(this.onSuccess);

  @override
  List<Object> get props => [onSuccess];

}
