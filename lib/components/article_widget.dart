import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mygameslist_flutter/models/game_model.dart';

typedef Tap(NetworkImage);

class ArticleWidget extends StatelessWidget {
  const ArticleWidget({Key key, @required this.article, this.onTap})
      : super(key: key);
  final GameModel article;
  final Tap onTap;

  @override
  Widget build(BuildContext context) {
    NetworkImage image = NetworkImage(article.imgurl);
    return InkWell(
      onTap: () {
        onTap(image);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey[800], borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: article.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  article.title,
                  style: TextStyle(
                      color: Colors.white, fontFamily: "Poppins", fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
