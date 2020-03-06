import 'package:flutter/cupertino.dart';

class ReviewModel {
  String articleId;
  String username;
  String review;

  ReviewModel({this.articleId, this.username, this.review});

  ReviewModel.fromJson({@required Map<String, dynamic> json}) {
    articleId = json["_id"];
    username = json["username"];
    review = json["comment"];
  }
}
