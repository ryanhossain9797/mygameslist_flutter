import 'dart:convert';

import 'package:http/http.dart';
import 'package:mygameslist_flutter/models/post_wiki_model.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/models/wiki_model.dart';

class ApiHelper {
  static getAllReviews(String id) async {
    var uri = Uri.http("118.179.70.140:3693", "articles/$id/comments");
    Response response = await get(uri);
    var jsonResponse = (jsonDecode(response.body))["comments"];
    List<ReviewModel> reviews = [];
    for (var review in jsonResponse) {
      reviews.add(ReviewModel.fromJson(json: review));
    }
    return reviews;
  }

  static postReview(ReviewModel review) async {
    Response response = await post(
        Uri.encodeFull("http://118.179.70.140:3693/comments"),
        body: {
          "article": review.id,
          "username": review.username,
          "comment": review.review
        });
    var jsonResponse = jsonDecode(response.body);

    return ReviewModel.fromJson(json: jsonResponse);
  }

  static getAllArticles() async {
    Response response =
        await get(Uri.encodeFull("http://118.179.70.140:3693/articles"));
    var jsonResponse = (jsonDecode(response.body))["articles"];
    List<WikiModel> articles = [];
    for (var article in jsonResponse) {
      articles.add(WikiModel.fromJson(json: article));
    }
    return articles;
  }

  static postArticle(PostWiki article) async {
    Response response = await post(
        Uri.encodeFull("http://118.179.70.140:3693/articles"),
        body: article.toMap());
    var jsonResponse = jsonDecode(response.body);

    return WikiModel.fromJson(json: jsonResponse);
  }

  static getArticleById(String id) async {
    Response response =
        await get(Uri.encodeFull("http://118.179.70.140:3693/articles/$id"));
    var jsonResponse = (jsonDecode(response.body))["article"];
    return WikiModel.fromJson(json: jsonResponse);
  }

  static deleteArticleById(String id) async {
    Response response =
        await delete(Uri.encodeFull("http://118.179.70.140:3693/articles/$id"));
    var jsonResponse = jsonDecode(response.body);

    return WikiModel.fromJson(json: jsonResponse);
  }

  static patchArticleById(String id, List<Map<String, String>> edits) async {
    try {
      Response response = await patch(
          Uri.encodeFull("http://118.179.70.140:3693/articles/$id"),
          headers: {'content-type': 'application/json'},
          body: json.encoder.convert(edits));
      var jsonResponse = jsonDecode(response.body);
      return WikiModel.fromJson(json: jsonResponse);
    } catch (e) {
      print(e);
    }
  }
}
