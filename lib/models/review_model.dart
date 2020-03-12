import 'package:flutter/cupertino.dart';

class ReviewModel {
  String articleId;
  String username;
  String review;
  String id;

  ReviewModel({this.articleId, this.username, this.review});

  ReviewModel.fromJson({@required Map<String, dynamic> json}) {
    try {
      id = json["_id"];
      articleId = json["article"];
      username = json["username"];
      review = json["comment"];
    } catch (e) {
      print(e);
    }
  }
}
