import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:mygameslist_flutter/blocs/auth_bloc.dart';
import 'package:mygameslist_flutter/blocs/details_bloc.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/components/review_widget.dart';
import 'package:mygameslist_flutter/components/side_drawer.dart';
import 'package:mygameslist_flutter/components/user_avatar.dart';
import 'package:mygameslist_flutter/styles.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/models/game_model.dart';
import 'package:mygameslist_flutter/views/home_screen.dart';
import 'package:mygameslist_flutter/views/login_screen.dart';
import 'package:page_transition/page_transition.dart';

class DetailsScreen extends StatefulWidget {
  final NetworkImage tempImage;
  final String id;
  DetailsScreen({this.tempImage, this.id});
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DetailsBloc>(context).add(
      LoadDetailsEvent(widget.id),
    );
    return Scaffold(
      drawer: SideDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            //-------------------------APPBAR
            SliverAppBar(
              pinned: true,
              expandedHeight: 180,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.id,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        fit: BoxFit.cover,
                        image: widget.tempImage,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.lightGreenAccent.withAlpha(127),
                              Colors.transparent
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                UserAvatar(),
              ],
            ),
          ];
        },
        body: BlocBuilder<DetailsBloc, DetailsLoadState>(
          builder: (context, state) {
            if (state is DetailsLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DetailsFailedState) {
              return Center(
                child: Text("error"),
              );
            } else {
              //---------------------------------------------MAIN BODY
              GameModel article = (state as DetailsLoadedState).game;
              List<ReviewModel> reviews = (state as DetailsLoadedState).reviews;
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //-----------------------TITLE
                    Padding(
                      child: Text(
                        article.title,
                        textAlign: TextAlign.center,
                        style: boldGreenText,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: darkGrey),
                      padding: EdgeInsets.all(10),
                      child: Text(article.content,
                          style: darkGreyText.copyWith(
                              color: Colors.white, fontSize: 12)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Reviews",
                      style: boldGreenText,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: reviews.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return ReviewWidget(review: reviews[pos]);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is SignedInAuthState) {
                            String name = state.username;
                            bool reviewed = false;
                            for (ReviewModel review in reviews) {
                              if (review.username == name) {
                                reviewed = true;
                                break;
                              }
                            }
                            if (!reviewed) {
                              return ReviewSubmissionWidget(
                                onReviewed: (username, review) {
                                  BlocProvider.of<DetailsBloc>(context).add(
                                    SubmitReviewDetailsEvent(
                                      review: ReviewModel(
                                        articleId: article.id,
                                        username: username,
                                        review: review,
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              //----------------------Sign in Prompt to review
                              child: GFButton(
                                size: 50,
                                color: Colors.lightGreenAccent,
                                child: Center(
                                  child: Text(
                                    "Sign in to review",
                                    style: TextStyle(color: Colors.grey[800]),
                                  ),
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  PageTransition(
                                    child: LoginScreen(),
                                    type: PageTransitionType.fade,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Center(
                        child: Text(
                          "Total ${reviews.length} reviews",
                          style: boldGreenText.copyWith(fontSize: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

typedef ReviewCallback(String username, String review);

class ReviewSubmissionWidget extends StatelessWidget {
  ReviewSubmissionWidget({Key key, @required this.onReviewed})
      : super(key: key);

  final ReviewCallback onReviewed;
  final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Center(
                  child: Text(
                    (BlocProvider.of<AuthBloc>(context).state
                            as SignedInAuthState)
                        .username,
                    style: boldGreenText.copyWith(fontSize: 18),
                  ),
                )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: GFButton(
                      textColor: darkGrey,
                      color: Colors.lightGreenAccent,
                      borderShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "submit",
                        style: darkGreyText.copyWith(fontSize: 18),
                      ),
                      onPressed: () {
                        if ((BlocProvider.of<AuthBloc>(context).state
                                as SignedInAuthState)
                            .username
                            .isNotEmpty) {
                          onReviewed(
                              (BlocProvider.of<AuthBloc>(context).state
                                      as SignedInAuthState)
                                  .username,
                              reviewController.text);
                          FocusScope.of(context).requestFocus(FocusNode());
                          reviewController.clear();
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: InputBox(
              hint: "review",
              controller: reviewController,
            ),
          ),
        ],
      ),
    );
  }
}

class InputBox extends StatelessWidget {
  const InputBox({Key key, this.hint = "hint", this.controller})
      : super(key: key);

  final String hint;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cursorColor: Colors.lightGreenAccent,
      ),
      child: TextField(
        //-------------------------TODO: Implement scroll
        onTap: () {},
        controller: controller != null ? controller : TextEditingController(),
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
          enabledBorder: greyBorder,
          focusedBorder: lightGreenBorder,
          border: greenBorder,
        ),
      ),
    );
  }
}
