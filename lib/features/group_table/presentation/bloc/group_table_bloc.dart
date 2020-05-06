import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/group_table/data/model/group_link_table_model.dart';
import 'package:linker/features/group_table/domain/usecases/create_new_group.dart';
import 'package:linker/features/group_table/domain/usecases/get_group_table_stream.dart';
import 'package:linker/features/group_table/domain/usecases/update_group_table_data.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';

import './bloc.dart';

class GroupTableBloc extends Bloc<GroupTableEvent, GroupTableState> {
  final GetGroupTableStream getGroupTableStream;
  final CreateNewGroup createNewGroup;
  final UpdateGroupTableData _updateGroupTableData;

  GroupTableBloc(this.getGroupTableStream, this.createNewGroup,
      this._updateGroupTableData);

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
    if (event is AddNewLinkTypeForGroupEvent) {
      yield LoadingGroupTableState();

      bool isExist = false;
      if (event.type.name != '') {
        if (event.prevUserDataModel == null) {
          final newUserData = GroupLinkTableModel(
            usersOfGroup: event.prevUserDataModel.usersOfGroup,
            types: event.prevUserDataModel.types..add(event.type),
            links: event.prevUserDataModel.links,
            creatorUid: event.prevUserDataModel.creatorUid,
            tableName: event.prevUserDataModel.tableName,
          );

          final result = await _updateGroupTableData(
            UpdateGroupTableDataParams(
              newTable: newUserData,
              reference: event.reference,
            ),
          );

          yield result.fold(
            (failure) => FailureGroupTableState(failure.error),
            (success) => SnapshotsLoaded(null, null),
          );
        } else {
          List<LinkTypeModel> types = List.from(event.prevUserDataModel.types);

          if (types.length != 0) {
            int number;

            for (int i = 0; i < types.length; i++) {
              final currentType = types[i];
              final nextType = i == types.length - 1 ? types[i] : types[i + 1];
              if (currentType.importance >= event.type.importance &&
                  nextType.importance <= event.type.importance) {
                number = i + 1;
              } else if (currentType.importance <= event.type.importance) {
                number = i;
              } else if (i == types.length - 1 &&
                  currentType.importance >= event.type.importance) {
                number = types.length;
              }
              if (number != null) break;
            }

            types.forEach(
              (element) {
                if (element.name == event.type.name) {
                  isExist = true;
                }
              },
            );

            if (!isExist) {
              print(number);
              types.insert(
                number,
                event.type,
              );
              final newGroupData = GroupLinkTableModel(
                usersOfGroup: event.prevUserDataModel.usersOfGroup,
                types: types,
                links: event.prevUserDataModel.links,
                creatorUid: event.prevUserDataModel.creatorUid,
                tableName: event.prevUserDataModel.tableName,
              );

              final result = await _updateGroupTableData(
                UpdateGroupTableDataParams(
                  newTable: newGroupData,
                  reference: event.reference,
                ),
              );

              yield result.fold(
                (failure) => FailureGroupTableState(failure.error),
                (success) => SnapshotsLoaded(null, null),
              );
            } else {
              yield FailureGroupTableState('This link group already exist!');
            }
          } else {
            types.add(
              event.type,
            );

            final newGroupData = GroupLinkTableModel(
              usersOfGroup: event.prevUserDataModel.usersOfGroup,
              types: types,
              links: event.prevUserDataModel.links,
              creatorUid: event.prevUserDataModel.creatorUid,
              tableName: event.prevUserDataModel.tableName,
            );

            final result = await _updateGroupTableData(
              UpdateGroupTableDataParams(
                newTable: newGroupData,
                reference: event.reference,
              ),
            );

            yield result.fold(
              (failure) => FailureGroupTableState(failure.error),
              (success) => SnapshotsLoaded(null, null),
            );
          }
        }
      } else
        yield FailureGroupTableState('Write non-null title!');
    }
    if (event is AddNewLinkToGroup) {
      yield LoadingGroupTableState();
      if (event.link.title != '' && event.link.link != '') {
        final newGroupData = GroupLinkTableModel(
          usersOfGroup: event.prevUserDataModel.usersOfGroup,
          types: event.prevUserDataModel.types,
          links: event.prevUserDataModel.links..add(event.link),
          creatorUid: event.prevUserDataModel.creatorUid,
          tableName: event.prevUserDataModel.tableName,
        );

        final result = await _updateGroupTableData(
          UpdateGroupTableDataParams(
            newTable: newGroupData,
            reference: event.reference,
          ),
        );

        yield result.fold(
          (failure) {
            return FailureGroupTableState(failure.error);
          },
          (success) {
            print('success');
            return SnapshotsLoaded(null, null);
          },
        );
      } else
        yield FailureGroupTableState('Write non-null title or link!');
    }
    if (event is DeleteLinkTypeGroup) {
      yield LoadingGroupTableState();

      final List<LinkTypeModel> types = List.from(event.prevUserData.types);

      types.retainWhere((element) => element != event.type);

      final List<LinkModel> links = List.from(event.prevUserData.links);

      links.retainWhere((element) => element.type != event.type.name);

      final newGroupData = GroupLinkTableModel(
        usersOfGroup: event.prevUserData.usersOfGroup,
        types: types,
        links: links,
        creatorUid: event.prevUserData.creatorUid,
        tableName: event.prevUserData.tableName,
      );

      final result = await _updateGroupTableData(
        UpdateGroupTableDataParams(
          newTable: newGroupData,
          reference: event.reference,
        ),
      );

      yield result.fold(
        (failure) => FailureGroupTableState(failure.error),
        (success) => SnapshotsLoaded(null, null),
      );
    }
    if (event is DeleteLinkGroup) {
      final links = event.prevUserDataModel.links;

      links.removeWhere((element) => element == event.link);

      final newGroupData = GroupLinkTableModel(
        usersOfGroup: event.prevUserDataModel.usersOfGroup,
        types: event.prevUserDataModel.types,
        links: links,
        creatorUid: event.prevUserDataModel.creatorUid,
        tableName: event.prevUserDataModel.tableName,
      );

      final result = await _updateGroupTableData(
        UpdateGroupTableDataParams(
          newTable: newGroupData,
          reference: event.reference,
        ),
      );

      yield result.fold(
        (failure) => FailureGroupTableState(failure.error),
        (success) => SnapshotsLoaded(null, null),
      );
    }
  }
}
