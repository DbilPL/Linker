import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/table/data/model/link_model.dart';
import 'package:linker/features/table/data/model/link_type_model.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/data/model/user_link_table_model.dart';
import 'package:linker/features/table/domain/usecases/get_user_data_stream.dart';
import 'package:linker/features/table/domain/usecases/update_user_data.dart';

import './bloc.dart';

class UserTableBloc extends Bloc<UserTableEvent, UserTableState> {
  final GetUserDataStream _getUserDataStream;
  final UpdateUserData _updateUserData;

  UserTableBloc(this._getUserDataStream, this._updateUserData);

  @override
  UserTableState get initialState => InitialUserTableState();

  @override
  Stream<UserTableState> mapEventToState(
    UserTableEvent event,
  ) async* {
    if (event is LoadUserDataInitial) {
      final result = await _getUserDataStream(event.uid);

      yield result.fold((failure) {
        return FailureUserTableState(failure.error);
      }, (success) {
        return UserDataLoaded(success);
      });
    }
    if (event is AddNewLink) {
      yield LoadingUserTableState();
      if (event.link.title != '' && event.link.link != '') {
        final newUserDataModel = UserDataModel(
          name: event.prevUserDataModel.name,
          groupNameList: event.prevUserDataModel.groupNameList,
          table: UserLinkTableModel(
            types: event.prevUserDataModel.table.types,
            links: event.prevUserDataModel.table.links
              ..add(
                event.link,
              ),
          ),
        );

        final result = await _updateUserData(
          UpdateUserDataParams(
            newUserData: newUserDataModel,
            reference: event.reference,
          ),
        );

        yield result.fold(
          (failure) {
            return FailureUserTableState(failure.error);
          },
          (success) {
            print('success');
            return UserDataLoaded(null);
          },
        );
      } else
        yield FailureUserTableState('Write non-null title or link!');
    }
    if (event is AddNewLinkTypeEvent) {
      yield LoadingUserTableState();

      bool isExist = false;
      if (event.type.name != '') {
        if (event.prevUserDataModel.table == null) {
          final newUserData = UserDataModel(
            name: event.prevUserDataModel.name,
            groupNameList: event.prevUserDataModel.groupNameList,
            table: UserLinkTableModel(
              links: [],
              types: []..add(
                  event.type,
                ),
            ),
          );

          final result = await _updateUserData(
            UpdateUserDataParams(
              newUserData: newUserData,
              reference: event.reference,
            ),
          );

          yield result.fold(
            (failure) => FailureUserTableState(failure.error),
            (success) => UserDataLoaded(null),
          );
        } else {
          List<LinkTypeModel> types =
              List.from(event.prevUserDataModel.table.types);

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
              final newUserDataModel = UserDataModel(
                groupNameList: event.prevUserDataModel.groupNameList,
                name: event.prevUserDataModel.name,
                table: UserLinkTableModel(
                  links: event.prevUserDataModel.table.links,
                  types: types,
                ),
              );

              final result = await _updateUserData(
                UpdateUserDataParams(
                  newUserData: newUserDataModel,
                  reference: event.reference,
                ),
              );

              yield result.fold(
                (failure) => FailureUserTableState(failure.error),
                (success) => UserDataLoaded(null),
              );
            } else {
              yield FailureUserTableState('This link group already exist!');
            }
          } else {
            types.add(
              event.type,
            );

            final newUserDataModel = UserDataModel(
              groupNameList: event.prevUserDataModel.groupNameList,
              name: event.prevUserDataModel.name,
              table: UserLinkTableModel(
                links: event.prevUserDataModel.table.links,
                types: types,
              ),
            );

            final result = await _updateUserData(
              UpdateUserDataParams(
                newUserData: newUserDataModel,
                reference: event.reference,
              ),
            );

            yield result.fold(
              (failure) => FailureUserTableState(failure.error),
              (success) => UserDataLoaded(null),
            );
          }
        }
      } else
        yield FailureUserTableState('Write non-null title!');
    }

    if (event is DeleteLinkType) {
      yield LoadingUserTableState();

      final List<LinkTypeModel> types =
          List.from(event.prevUserData.table.types);

      types.retainWhere((element) => element != event.type);

      final List<LinkModel> links = List.from(event.prevUserData.table.links);

      links.retainWhere((element) => element.type != event.type.name);

      final newUserDataModel = UserDataModel(
        groupNameList: event.prevUserData.groupNameList,
        name: event.prevUserData.name,
        table: UserLinkTableModel(
          links: links,
          types: types,
        ),
      );

      final result = await _updateUserData(
        UpdateUserDataParams(
          newUserData: newUserDataModel,
          reference: event.reference,
        ),
      );

      yield result.fold(
        (failure) => FailureUserTableState(failure.error),
        (success) => UserDataLoaded(null),
      );
    }

    if (event is DeleteLink) {
      final links = event.prevUserDataModel.table.links;

      links.removeWhere((element) => element == event.link);

      final newUserDataModel = UserDataModel(
        groupNameList: event.prevUserDataModel.groupNameList,
        name: event.prevUserDataModel.name,
        table: UserLinkTableModel(
          links: links,
          types: event.prevUserDataModel.table.types,
        ),
      );

      final result = await _updateUserData(
        UpdateUserDataParams(
          newUserData: newUserDataModel,
          reference: event.reference,
        ),
      );

      yield result.fold(
        (failure) => FailureUserTableState(failure.error),
        (success) => UserDataLoaded(null),
      );
    }
  }
}
