import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/authentication/domain/usecases/sign_out.dart';
import 'package:linker/features/group_table/domain/usecases/dynamic_link_stream.dart';

import './bloc.dart';

class DynamicLinkBloc extends Bloc<DynamicLinkEvent, DynamicLinkState> {
  final DynamicLinkStream linkStream;

  DynamicLinkBloc(this.linkStream);

  @override
  DynamicLinkState get initialState => InitialDynamicLinkState();

  @override
  Stream<DynamicLinkState> mapEventToState(
    DynamicLinkEvent event,
  ) async* {
    if (event is LoadOnLinkHandler) {
      await Future.delayed(Duration(seconds: 4));

      final loadLink = await linkStream(NoParams());

      yield loadLink.fold((failure) {
        return FailureLinkState(failure);
      }, (success) {
        return LoadLinkHandlerSuccess(success);
      });
    }
  }
}
