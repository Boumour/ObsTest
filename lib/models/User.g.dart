// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => new User(
    fname: json['f_name'] as String,
    lname: json['l_name'] as String,
    id: json['id'] as String,
    email: json['email'] as String,
    uniqueid: json['unique_id'] as String,
    password: json['password'] as String,
    oldpassword: json['old_password'] as String,
    newpassword: json['new_password'] as String,
    sexe: json['sexe'] as String,
    dt_naiss: json['dt_naiss'] as String,
    type: json['type'] as String,);

abstract class _$UserSerializerMixin {
  String get fname;

  String get lname;
  String get id;
  String get email;

  String get uniqueid;

  String get password;

  String get oldpassword;

  String get newpassword;
  String get sexe;
  String get dt_naiss;

    String get type;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'f_name': fname,
        'l_name': lname,
        'email': email,
        'unique_id': uniqueid,
        'password': password,
        'old_password': oldpassword,
        'new_password': newpassword,
        'type': type,
        'sexe': sexe,
        'dt_naiss': dt_naiss,
        'id':id
      };
}
