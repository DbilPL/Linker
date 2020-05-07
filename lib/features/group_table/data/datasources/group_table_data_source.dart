import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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

  /// Creates new group in [Firestore] via group name and creator uid
  /// Throws [Exception], when something went wrong
  Future<Stream<DocumentSnapshot>> createNewGroup(
      {String uid, String userName, String groupName});

  /// Creates new group in [Firestore] via group name and creator uid
  /// Throws [Exception], when something went wrong
  Future<Uri> retrieveDynamicLink(Function onSuccess);
}

class GroupTableDataSourceImpl extends GroupTableDataSource {
  final Firestore firestore;
  final FirebaseDynamicLinks firebaseDynamicLinks;

  GroupTableDataSourceImpl(this.firestore, this.firebaseDynamicLinks);

  @override
  Future<String> generateJoiningLink({String tableName}) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://linkerapp.page.link',
        link: Uri.parse(
            'https://linkerapp.page.link/groups?group_name=$tableName}'),
        androidParameters: AndroidParameters(
          packageName: 'com.example.linker',
          minimumVersion: 0,
        ),
        iosParameters: IosParameters(
          bundleId: 'com.example.linker',
        ),
      );

      final Uri dynamicUrl = await parameters.buildUrl();
      final ShortDynamicLink shortenedLink =
          await DynamicLinkParameters.shortenUrl(
        dynamicUrl,
        DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable,
        ),
      );
      final Uri shortUrl = shortenedLink.shortUrl;

      return 'https://linkerapp.page.link' + shortUrl.path;
    } catch (E) {
      throw Exception();
    }
  }

  @override
  Future<Stream<DocumentSnapshot>> getGroupTableStream(
      {String tableName}) async {
    try {
      final stream =
          firestore.collection('groups').document(tableName).snapshots();

      return stream;
    } catch (E) {
      throw Exception();
    }
  }

  @override
  Future<void> updateGroupTableData(
      {DocumentReference reference, GroupLinkTableModel newGroupTable}) async {
    try {
      final success = await reference.updateData(newGroupTable.toJson());
      return success;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Stream<DocumentSnapshot>> createNewGroup(
      {String uid, String groupName, String userName}) async {
    try {
      final collection = firestore.collection('groups');

      final document = collection.document(groupName);

      await document.setData(
        GroupLinkTableModel(
          tableName: groupName,
          types: [],
          links: [],
          creatorUid: uid,
          usersOfGroup: [userName],
        ).toJson(),
      );

      return document.snapshots();
    } catch (E) {
      throw Exception();
    }
  }

  @override
  Future<Uri> retrieveDynamicLink(Function onSuccess) async {
    try {
      final PendingDynamicLinkData data =
          await firebaseDynamicLinks.getInitialLink();

      firebaseDynamicLinks.onLink(onSuccess: onSuccess);

      final Uri link = data?.link;
      if (link != null)
        return link;
      else
        throw Exception();
    } catch (E) {
      throw Exception();
    }
  }
}
