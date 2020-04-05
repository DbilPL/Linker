import 'package:flutter_test/flutter_test.dart';
import 'package:linker/features/authentication/data/model/user_model.dart';
import 'package:linker/features/authentication/domain/entities/user.dart';

void main() {
  final tUserModel =
      UserModel(password: 'hbwwuicbw', email: 'something@gmail.com');
  final tJson = {
    'password': 'hbwwuicbw',
    'email': 'something@gmail.com',
  };

  group('testing user model', () {
    test('should be a sub class of user entity', () {
      expect(tUserModel, isA<User>());
    });
    test('should return json from toJson method', () {
      expect(
        tUserModel.toJson(),
        tJson,
      );
    });

    test('should return user model from json', () {
      expect(
        UserModel.fromJson(json: tJson),
        tUserModel,
      );
    });
  });
}
