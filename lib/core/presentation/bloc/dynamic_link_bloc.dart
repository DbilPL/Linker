import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/authentication/domain/usecases/sign_out.dart';
import 'package:linker/features/group_table/domain/usecases/retrieve_dynamic_link.dart';
import 'package:linker/features/group_table/domain/usecases/set_on_link_handler.dart';

import './bloc.dart';

class DynamicLinkBloc extends Bloc<DynamicLinkEvent, DynamicLinkState> {
  final RetrieveDynamicLink initialLink;
  final SetOnLinkHandler linkHandler;

  DynamicLinkBloc(this.initialLink, this.linkHandler);

  @override
  DynamicLinkState get initialState => InitialDynamicLinkState();

  @override
  Stream<DynamicLinkState> mapEventToState(
    DynamicLinkEvent event,
  ) async* {
    yield LoadingDynamicLinkState();
    if (event is LoadInitialLink) {
      final loadLink = await initialLink(NoParams());

      yield loadLink.fold((failure) {
        print(failure.error);
        return FailureLinkState(failure);
      }, (success) {
        return LoadLinkHandlerSuccess(success);
      });
    }
    if (event is SetOnLinkHandlerEvent) {
      final loadLink = await linkHandler(event.onSuccess);

      yield loadLink.fold((failure) {
        print(failure.error);
        return FailureLinkState(failure);
      }, (success) {
        return LoadLinkHandlerSuccess(null);
      });
    }
  }
}
