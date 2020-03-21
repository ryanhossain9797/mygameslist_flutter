import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/constants.dart';
import 'package:mygameslist_flutter/models/game_model.dart';
import 'package:mygameslist_flutter/styles.dart';

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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: primaryCircleBorderRadius,
          color: darkGreyColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 3,
              color: Colors.black.withAlpha(63),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kPrimaryRadiusValue),
                topRight: Radius.circular(kPrimaryRadiusValue),
              ),
              child: Image(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                game.title,
                style: TextStyle(
                    color: Colors.white, fontFamily: "Poppins", fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
