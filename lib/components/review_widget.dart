import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mygameslist_flutter/blocs/details_bloc.dart';
import 'package:mygameslist_flutter/blocs/login_bloc.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/constants.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/styles.dart';
import 'package:sticky_headers/sticky_headers.dart';

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
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            spreadRadius: 3,
            color: Colors.black.withAlpha(63),
          ),
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)),
        color: darkGreyColor,
      ),
      child: AnimatedSize(
        vsync: this,
        duration: kAnimationDuration,
        child: AnimatedSwitcher(
          duration: kAnimationDuration,
          child: Builder(
            key: deleting ? deleteKey : displayKey,
            builder: (context) {
              return deleting
                  //-----------------------DELETION WIDGET
                  ? Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
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
                                        decoration: BoxDecoration(
                                            color: lightAccentColor),
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
                                        decoration: BoxDecoration(
                                            color: dangerWarningColor),
                                        child: InkWell(
                                          onTap: () {
                                            BlocProvider.of<DetailsBloc>(
                                                    context)
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
                      ),
                    )
                  //---------------------------MAIN BODY
                  : StickyHeaderBuilder(
                      builder: (context, stuckAmount) {
                        return Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: darkGreyColor,
                                  border: Border.all(
                                      color: Color.lerp(
                                        lightAccentColor,
                                        null,
                                        stuckAmount,
                                      ),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      //-----------------------First letter as avatar
                                      backgroundColor: lightAccentColor,
                                      child: Text(
                                        widget.review.username.substring(0, 1),
                                        style:
                                            darkGreyText.copyWith(fontSize: 24),
                                      ),
                                    ),
                                    //-----------------------Rest of username
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: Text(
                                        widget.review.username.substring(
                                            1, widget.review.username.length),
                                        style: boldGreenText.copyWith(
                                            fontSize: 22),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),

                              //-------------------------------------Renders CROSS button if signed in and username matches review user
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  if (state is LoggedInLoginState) {
                                    if (state.email == widget.review.email) {
                                      return CircleAvatar(
                                        backgroundColor: dangerWarningColor,
                                        child: IconButton(
                                          splashColor: Colors.transparent,
                                          color: darkGreyColor,
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
                        );
                      },
                      content: Padding(
                        padding:
                            EdgeInsets.only(bottom: 15, left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 25,
                                  child: Icon(
                                    Icons.thumb_up,
                                    size: 30,
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                                CircleAvatar(
                                  radius: 25,
                                  child: Icon(
                                    Icons.thumb_down,
                                    size: 30,
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MarkdownBody(
                              data: widget.review.review,
                              styleSheet: MarkdownStyleSheet(
                                codeblockDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                code: TextStyle(color: darkGreyColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
