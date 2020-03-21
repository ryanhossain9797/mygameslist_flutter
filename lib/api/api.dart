import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mygameslist_flutter/models/login_result_model.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/models/game_model.dart';

class ApiHelper {
  //---------------------------------------------------------------REVIEW
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

  static postGame(GameModel game) async {
    Response response = await post(
        Uri.encodeFull("http://118.179.70.140:3693/articles"),
        body: game.toMap());
    var jsonResponse = jsonDecode(response.body);

    return GameModel.fromJson(json: jsonResponse);
  }

  static getGameById(String id) async {
    print("APIGETGAMEBYID: Called");
    try {
      Response response =
          await get(Uri.encodeFull("http://118.179.70.140:3693/articles/$id"));
      print("APIGETGAMEBYID: Response Received");
      var jsonResponse = (jsonDecode(response.body))["article"];
      print("APIGETGAMEBYID: Response Decoded, Returning Game");
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

  //---------------------------------------------------------------REVIEW
  static getAllReviews(String id) async {
    Response response = await get(
        Uri.encodeFull("http://118.179.70.140:3693/articles/$id/comments"));
    var jsonResponse = (jsonDecode(response.body))["comments"];
    List<ReviewModel> reviews = [];
    for (var review in jsonResponse) {
      reviews.add(ReviewModel.fromJson(json: review));
    }
    print("APIGETALLREVIEWS: total reviews: ${reviews.length}");
    return reviews;
  }

  static postReview(
    String token,
    ReviewModel review,
  ) async {
    print("POSTREVIEW: token: $token");
    Response response = await post(
      Uri.encodeFull(
          "http://118.179.70.140:3693/articles/${review.articleId}/comments"),
      body: {"comment": review.review},
      headers: {"token": token},
    );
    var jsonResponse = jsonDecode(response.body);

    return ReviewModel.fromJson(json: jsonResponse);
  }

  static deleteReviewById(
    String token, {
    @required String aid,
    @required String cid,
    @required String username,
  }) async {
    print("API_DELETE_REVIEW: username is $username");
    Response response = await delete(
      Uri.encodeFull("http://118.179.70.140:3693/articles/$aid/comments/$cid"),
      headers: {"token": token},
    );

    var jsonResponse = jsonDecode(response.body);

    return GameModel.fromJson(json: jsonResponse);
  }

  //---------------------------------------------------------------AUTH
  static signUpWithEmailPass({
    @required String email,
    @required String username,
    @required String password,
  }) async {
    print("API_SIGNUP: called $username $email $password");
    Response response = await post(
      Uri.encodeFull("http://118.179.70.140:3693/users/signup"),
      body: {"username": username, "email": email, "password": password},
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  static Future<LogInResult> logInWithEmailPass({
    @required String email,
    @required String password,
  }) async {
    print("API_LOGIN: called $email $password");
    Response response = await post(
      Uri.encodeFull("http://118.179.70.140:3693/users/login"),
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String token = jsonResponse["token"];
      String userName = jsonResponse["username"];
      String email = jsonResponse["email"];
      print(token);
      return LogInResult(
          success: true,
          username: userName,
          email: email,
          message: "success",
          token: token);
    } else {
      print(response.statusCode);
      return LogInResult(success: false, message: "failed", token: "");
    }
  }
}
