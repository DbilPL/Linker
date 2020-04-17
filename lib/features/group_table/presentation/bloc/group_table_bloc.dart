import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/group_table/domain/usecases/get_group_table_stream.dart';

import './bloc.dart';

class GroupTableBloc extends Bloc<GroupTableEvent, GroupTableState> {
  final GetGroupTableStream getGroupTableStream;

  GroupTableBloc(this.getGroupTableStream);

  @override
  GroupTableState get initialState => InitialGroupTableState();

  @override
  Stream<GroupTableState> mapEventToState(
    GroupTableEvent event,
  ) async* {
    yield LoadingGroupTableState();

    if (event is LoadGroupSnapshots) {
      final result = await getGroupTableStream(event.groupName);

      yield await result.fold((failure) {
        return FailureGroupTableState(failure.error);
      }, (success) {
        return SnapshotsLoaded(success, event.groupName);
      });
    }
  }
}
