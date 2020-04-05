import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linker/features/table/data/model/user_data_model.dart';
import 'package:linker/features/table/domain/entities/link.dart';
import 'package:linker/features/table/domain/entities/link_type.dart';
import 'package:linker/features/table/domain/entities/user_data.dart';

void main() {
  final tUserDataModel = UserDataModel(
    types: [
      LinkType(name: 'dev', color: Colors.black, importance: 3),
    ],
    name: 'John',
    links: [
      Link(link: 'https://kcdsovjifv.com', type: 'dev', title: 'yay'),
    ],
    groupNameList: [
      'test_group',
    ],
  );
  final tJson = {
    'name': 'John',
    'group_names': ['test_group'],
    'links': [
      {
        'link': 'https://kcdsovjifv.com',
        'type': 'dev',
        'title': 'yay',
      },
    ],
    'types': [
      {
        'name': 'dev',
        'color': [0, 0, 0],
        'importance': 3,
      },
    ],
  };

  group('testing user data model', () {
    test('should be a sub class of user data entity', () {
      expect(tUserDataModel, isA<UserData>());
    });
    test('should return json from toJson method', () {
      expect(
        tUserDataModel.toJson(),
        tJson,
      );
    });

    test('should return user data model from json', () {
      expect(
        UserDataModel.fromJson(tJson),
        tUserDataModel,
      );
    });
  });
}
