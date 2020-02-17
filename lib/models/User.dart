/*
 * Copyright 2018 Harsh Sharma
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User extends Object with _$UserSerializerMixin {
  String fname;
  String lname;
  String id;
  String email;
  String uniqueid;
  String password;
  String oldpassword;
  String newpassword;
  String type;
  String sexe;
  String dt_naiss;

  User(
      {this.fname,
      this.lname,
      this.id,
      this.email,
      this.uniqueid,
      this.password,
      this.oldpassword,
      this.newpassword,
      this.type,
      this.sexe,
      this.dt_naiss
      });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
