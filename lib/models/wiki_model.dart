import 'package:flutter/widgets.dart';

class WikiModel {
  String id;
  String title;
  String content;
  String imgurl;
  WikiModel(
      {@required this.id,
      @required this.title,
      @required this.content,
      @required this.imgurl});

  WikiModel.fromJson({@required Map<String, dynamic> json}) {
    id = json["_id"];
    title = json["title"];
    content = json["content"];
    imgurl = json["imgurl"];
  }
}
