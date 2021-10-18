import 'package:flutter/material.dart';

class Character {
  late int charId;
  late String name;
  late String nickName;
  late String image;
  late List<dynamic> jobs;
  late String status;
  late List<dynamic> appearance;
  late String actorName;
  late String category;
  late List<dynamic> betterCallSaulAppearance;

  Character.fromJson(Map<String, dynamic> json) {
    charId = json["char_id"];
    name = json["name"];
    nickName = json["nickname"];
    image = json["img"];
    jobs = json["occupation"];
    status = json["status"];
    appearance = json["appearance"];
    actorName = json["portrayed"];
    category = json["category"];
    betterCallSaulAppearance = json["better_call_saul_appearance"];
  }
}
