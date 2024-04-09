import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String email;

  @HiveField(1)
  late String password;

  @HiveField(2)
  String? gender;

  @HiveField(3)
  String? dateOfBirth;

  @HiveField(4)
  String? race;
  User(this.email, this.password, {this.gender, this.dateOfBirth, this.race});
}