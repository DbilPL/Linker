import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';

abstract class UserTableDataSource {
  /// Get [Stream] of [DocumentSnapshot] from [Firestore], which automatically updates data when it changes
  /// Throws [Exception], when something went wrong
  Future<Stream<DocumentSnapshot>> getUserDataStream({String uid});

  /// Updates [UserDataModel] in [Firestore] using [DocumentReference]
  /// Throws [Exception], when something went wrong
  Future<void> updateUserData(
      {DocumentReference reference, UserDataModel newUserData});
}

class UserTableDataSourceImpl extends UserTableDataSource {
  final Firestore firestore;

  UserTableDataSourceImpl(this.firestore);

  @override
  Future<Stream<DocumentSnapshot>> getUserDataStream({String uid}) async {
    try {
      final document = firestore.collection('users').document(uid).snapshots();

      return document;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> updateUserData(
      {DocumentReference reference, UserDataModel newUserData}) async {
    try {
      return await reference.updateData(
        newUserData.toJson(),
      );
    } catch (e) {
      throw Exception();
    }
  }
}
