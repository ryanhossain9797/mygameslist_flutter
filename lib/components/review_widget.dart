import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/blocs/auth_bloc.dart';
import 'package:mygameslist_flutter/blocs/details_bloc.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/constants.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/styles.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    Key key,
    @required this.review,
  }) : super(key: key);

  final ReviewModel review;

  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget>
    with SingleTickerProviderStateMixin {
  bool deleting = false;
  @override
  Widget build(BuildContext context) {
    Key deleteKey = UniqueKey();
    Key displayKey = UniqueKey();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: darkGrey,
      ),
      child: AnimatedSize(
        vsync: this,
        duration: animationDuration,
        child: AnimatedSwitcher(
          duration: animationDuration,
          child: Builder(
            key: deleting ? deleteKey : displayKey,
            builder: (context) {
              return deleting
                  //-----------------------DELETION WIDGET
                  ? Container(
                      height: 100,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Delete your review?",
                            style: boldGreenText.copyWith(fontSize: 24),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: accentColor),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            deleting = false;
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            "Cancel",
                                            style: darkGreyText.copyWith(
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: Colors.red),
                                      child: InkWell(
                                        onTap: () {
                                          BlocProvider.of<DetailsBloc>(context)
                                              .add(
                                            DeleteReviewDetailsEvent(
                                                review: widget.review),
                                          );
                                          setState(() {
                                            deleting = false;
                                          });
                                        },
                                        child: Center(
                                          child: Text(
                                            "Delete",
                                            style: darkGreyText.copyWith(
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  widget.review.username,
                                  style: boldGreenText.copyWith(fontSize: 22),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              //-------------------------------------Renders CROSS button if signed in and username matches review user
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  if (state is SignedInAuthState) {
                                    if (state.username ==
                                        widget.review.username) {
                                      return CircleAvatar(
                                        backgroundColor: accentColor,
                                        child: IconButton(
                                          splashColor: Colors.transparent,
                                          color: darkGrey,
                                          icon: Icon(
                                            Icons.delete,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              deleting = true;
                                            });
                                          },
                                        ),
                                      );
                                    } else {
                                      return SizedBox(
                                        width: 0,
                                      );
                                    }
                                  } else {
                                    return SizedBox(
                                      width: 0,
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.review.review,
                            style: darkGreyText.copyWith(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
