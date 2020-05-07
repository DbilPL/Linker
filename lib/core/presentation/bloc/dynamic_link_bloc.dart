import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/group_table/domain/usecases/retrieve_dynamic_link.dart';

import './bloc.dart';

class DynamicLinkBloc extends Bloc<DynamicLinkEvent, DynamicLinkState> {
  final RetrieveDynamicLink initialLink;

  DynamicLinkBloc(this.initialLink);

  @override
  DynamicLinkState get initialState => InitialDynamicLinkState();

  @override
  Stream<DynamicLinkState> mapEventToState(
    DynamicLinkEvent event,
  ) async* {
    if (event is LoadInitialLink) {
      final loadLink = await initialLink(event.function);

      yield loadLink.fold((failure) {
        return FailureLinkState(failure);
      }, (success) {
        return LoadLinkHandlerSuccess(success);
      });
    }
  }
}
