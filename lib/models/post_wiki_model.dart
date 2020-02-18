import 'package:flutter/widgets.dart';

class PostWiki {
  String title;
  String content;
  String imgurl;
  PostWiki(
      {@required this.title, @required this.content, @required this.imgurl});

  Map toMap() {
    Map mapped = {"title": title, "content": content, "imgurl": imgurl};
    return mapped;
  }
}
