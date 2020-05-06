import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/group_table/domain/usecases/create_new_group.dart';
import 'package:linker/features/group_table/domain/usecases/get_group_table_stream.dart';

import './bloc.dart';

class GroupTableBloc extends Bloc<GroupTableEvent, GroupTableState> {
  final GetGroupTableStream getGroupTableStream;
  final CreateNewGroup createNewGroup;

  GroupTableBloc(this.getGroupTableStream, this.createNewGroup);

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

    if (event is AddNewGroup) {
      final result = await createNewGroup(
        CreateNewGroupParams(
          uid: event.uid,
          groupName: event.groupName,
          userName: event.userName,
        ),
      );

      yield await result.fold((failure) {
        return FailureGroupTableState(failure.error);
      }, (success) {
        return SnapshotsLoaded(success, event.groupName);
      });
    }
  }
}
