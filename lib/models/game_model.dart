import 'package:flutter/widgets.dart';

class GameModel {
  String id;
  String title;
  String content;
  String imgurl;
  GameModel(
      {@required this.id,
      @required this.title,
      @required this.content,
      @required this.imgurl});

  GameModel.fromJson({@required Map<String, dynamic> json}) {
    id = json["_id"];
    title = json["title"];
    content = json["content"];
    imgurl = json["imgurl"];
  }

  Map toMap() {
    Map mapped = {"title": title, "content": content, "imgurl": imgurl};
    return mapped;
  }
}
