import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mygameslist_flutter/models/game_model.dart';

typedef Tap(NetworkImage);

class GameWidget extends StatelessWidget {
  const GameWidget({Key key, @required this.game, this.onTap})
      : super(key: key);
  final GameModel game;
  final Tap onTap;

  @override
  Widget build(BuildContext context) {
    CachedNetworkImageProvider image = CachedNetworkImageProvider(game.imgurl);
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
                tag: game.id,
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
                  game.title,
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
