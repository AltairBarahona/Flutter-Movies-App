import 'package:flutter/cupertino.dart';

class Actores {
  List<Actor> actores = [];

  Actores.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) {
      return;
    }

    jsonList.forEach((actor) {
      final actorTemp = Actor.fromJsonMap(actor);
      actores.add(actorTemp);
    });
  }
}

class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  Actor.fromJsonMap(Map<String, dynamic> json) {
    castId = json["cast_id"];
    character = json["character"];
    creditId = json["credit_id"];
    gender = json["gender"];
    id = json["id"];
    name = json["name"];
    order = json["oder"];
    profilePath = json["profile_path"];
  }

  getActorImg() {
    if (profilePath == null) {
      return 'https://www.web2present.com/wp-content/uploads/2017/02/no-avatar-350x350-300x300.jpg';
    } else {
      return "https://image.tmdb.org/t/p/w500/" + profilePath;
    }
  }
}
