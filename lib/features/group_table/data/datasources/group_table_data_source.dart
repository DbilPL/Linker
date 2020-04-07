import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linker/features/group_table/data/model/group_link_table_model.dart';

abstract class GroupTableDataSource {
  /// Returns [Stream] of [DocumentSnapshot], which automatically updates data when it changes
  /// Throws [Exception], when something went wrong
  Future<Stream<DocumentSnapshot>> getGroupTableStream({String tableName});

  /// Updates [GroupLinkTableModel] in [Firestore] using [DocumentReference]
  /// Throws [Exception], when something went wrong
  Future<void> updateGroupTableData(
      {DocumentReference reference, GroupLinkTableModel newGroupTable});

  /// Generates link to join the group
  /// Throws [Exception], when something went wrong
  Future<String> generateJoiningLink({String tableName});
}

class GroupTableDataSourceImpl extends GroupTableDataSource {
  final Firestore firestore;

  GroupTableDataSourceImpl(this.firestore);

  @override
  Future<String> generateJoiningLink({String tableName}) {
    // TODO: implement generateJoiningLink
    return null;
  }

  @override
  Future<Stream<DocumentSnapshot>> getGroupTableStream(
      {String tableName}) async {
    final stream =
        firestore.collection('groups').document(tableName).snapshots();

    return stream;
  }

  @override
  Future<void> updateGroupTableData(
      {DocumentReference reference, GroupLinkTableModel newGroupTable}) async {
    final success = await reference.updateData(newGroupTable.toJson());
    return success;
  }
}
