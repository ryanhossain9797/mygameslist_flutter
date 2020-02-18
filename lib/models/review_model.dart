import 'package:flutter/cupertino.dart';

class ReviewModel {
  String id;
  String username;
  String review;

  ReviewModel({this.id, this.username, this.review});

  ReviewModel.fromJson({@required Map<String, dynamic> json}) {
    id = json["_id"];
    username = json["username"];
    review = json["comment"];
  }
}
