import 'package:flutter/material.dart';
import 'package:mygameslist_flutter/models/review_model.dart';

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    Key key,
    @required this.review,
  }) : super(key: key);

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[800],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            review.username,
            style: TextStyle(
              color: Colors.lightGreenAccent,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(review.review),
        ],
      ),
    );
  }
}
