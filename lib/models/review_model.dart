import 'package:flutter/cupertino.dart';

class ReviewModel {
  String articleId;
  String username;
  String review;
  String id;
  String userId;
  String email;

  ReviewModel(
      {this.articleId,
      this.username,
      this.review,
      this.email,
      this.id,
      this.userId});

  ReviewModel.fromJson({@required Map<String, dynamic> json}) {
    try {
      id = json["_id"];
      articleId = json["articleid"];
      username = json["username"];
      review = json["comment"];
      email = json["email"];
      userId = json["userid"];
    } catch (e) {
      print(e);
    }
  }
}
