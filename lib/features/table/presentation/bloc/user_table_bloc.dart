import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/table/domain/usecases/get_user_data_stream.dart';

import './bloc.dart';

class UserTableBloc extends Bloc<UserTableEvent, UserTableState> {
  final GetUserDataStream _getUserDataStream;

  UserTableBloc(this._getUserDataStream);

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
  }
}
