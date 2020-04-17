import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:linker/features/authentication/data/model/user_model.dart';
import 'package:rxdart/rxdart.dart';

import './bloc.dart';

class UserTableBloc extends Bloc<UserTableEvent, UserTableState> {
  final BehaviorSubject<UserModel> userData;

  UserTableBloc(this.userData);

  @override
  UserTableState get initialState => InitialUserTableState();

  @override
  Stream<UserTableState> mapEventToState(
    UserTableEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
