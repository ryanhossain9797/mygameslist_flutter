import 'dart:convert';

import 'package:http/http.dart';
import 'package:mygameslist_flutter/models/post_wiki_model.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/models/game_model.dart';

class ApiHelper {
  static getAllReviews(String id) async {
    var uri = Uri.http("118.179.70.140:3693", "articles/$id/comments");
    Response response = await get(uri);
    var jsonResponse = (jsonDecode(response.body))["comments"];
    List<ReviewModel> reviews = [];
    for (var review in jsonResponse) {
      reviews.add(ReviewModel.fromJson(json: review));
    }
    print("APIGETALLREVIEWS: total reviews: ${reviews.length}");
    return reviews;
  }

  static postReview(ReviewModel review) async {
    Response response = await post(
        Uri.encodeFull(
            "http://118.179.70.140:3693/articles/${review.articleId}/comments"),
        body: {
          "article": review.articleId,
          "username": review.username,
          "comment": review.review
        });
    var jsonResponse = jsonDecode(response.body);

    return ReviewModel.fromJson(json: jsonResponse);
  }

  static getAllGames() async {
    Response response =
        await get(Uri.encodeFull("http://118.179.70.140:3693/articles"));
    var jsonResponse = (jsonDecode(response.body))["articles"];
    List<GameModel> articles = [];
    for (var article in jsonResponse) {
      articles.add(GameModel.fromJson(json: article));
    }
    return articles;
  }

  static postGame(PostWiki article) async {
    Response response = await post(
        Uri.encodeFull("http://118.179.70.140:3693/articles"),
        body: article.toMap());
    var jsonResponse = jsonDecode(response.body);

    return GameModel.fromJson(json: jsonResponse);
  }

  static getGameById(String id) async {
    try {
      Response response =
          await get(Uri.encodeFull("http://118.179.70.140:3693/articles/$id"));
      var jsonResponse = (jsonDecode(response.body))["article"];

      return GameModel.fromJson(json: jsonResponse);
    } catch (e) {
      print("APIGETGAMEBYID: $e");
    }
  }

  static deleteGameById(String id) async {
    Response response =
        await delete(Uri.encodeFull("http://118.179.70.140:3693/articles/$id"));
    var jsonResponse = jsonDecode(response.body);

    return GameModel.fromJson(json: jsonResponse);
  }

  static patchGameById(String id, List<Map<String, String>> edits) async {
    try {
      Response response = await patch(
          Uri.encodeFull("http://118.179.70.140:3693/articles/$id"),
          headers: {'content-type': 'application/json'},
          body: json.encoder.convert(edits));
      var jsonResponse = jsonDecode(response.body);
      return GameModel.fromJson(json: jsonResponse);
    } catch (e) {
      print(e);
    }
  }
}
