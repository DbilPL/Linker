import 'dart:async';

import 'package:bloc/bloc.dart';
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
      yield LoadingUserTableState(null);

      final result = await _getUserDataStream(event.uid);

      yield result.fold((failure) {
        return FailureUserTableState(failure.error, null);
      }, (success) {
        return UserDataLoaded(success);
      });
    }
    if (event is UpdateUserDataEvent) {
      yield LoadingUserTableState(event.prevStream);

      final result = await _updateUserData(
        UpdateUserDataParams(
          newUserData: event.userDataModel,
          reference: event.reference,
        ),
      );

      Completer c = Completer<String>();

      result.fold((failure) => c.complete(failure.error), (noMatter) => null);

      final failure = await c.future;

      yield FailureUserTableState(failure, event.prevStream);
    }
  }
}
