import 'package:flutter/material.dart' show immutable;

@immutable
class Persons {
  final String name;
  final int age;

  const Persons(this.name, this.age);

  Persons.fromJson(Map<String, dynamic> json)
      : name = json["name"] as String,
        age = json["age"] as int;
}