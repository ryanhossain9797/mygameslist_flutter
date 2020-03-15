import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/loader/gf_loader.dart';
import 'package:getflutter/types/gf_loader_type.dart';
import 'package:mygameslist_flutter/blocs/auth_bloc_fake.dart';
import 'package:mygameslist_flutter/blocs/details_bloc.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/components/loading_indicator.dart';
import 'package:mygameslist_flutter/components/review_widget.dart';
import 'package:mygameslist_flutter/components/side_drawer.dart';
import 'package:mygameslist_flutter/components/user_avatar.dart';
import 'package:mygameslist_flutter/styles.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/models/game_model.dart';
import 'package:mygameslist_flutter/views/home_screen.dart';
import 'package:mygameslist_flutter/views/login_screen_fake.dart';
import 'package:page_transition/page_transition.dart';

class DetailsScreen extends StatefulWidget {
  final CachedNetworkImageProvider tempImage;
  final String id;
  DetailsScreen({this.tempImage, this.id});
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    BlocProvider.of<DetailsBloc>(context).add(
      LoadDetailsEvent(widget.id),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              //-----------------------LOADING
              return Center(
                child: LoadingIndicator(),
              );
            } else if (state is DetailsFailedState) {
              //-----------------------ERROR
              return Center(
                child: Text("error"),
              );
            } else {
              //-----------------------MAIN BODY
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
                    //-----------------------DESCRIPTION
                    Container(
                      decoration: BoxDecoration(color: darkGreyColor),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        article.content,
                        style: darkGreyText.copyWith(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                    //Padding
                    SizedBox(
                      height: 20,
                    ),
                    //-----------------------REVIEWS HEADER
                    Text(
                      "Reviews",
                      style: boldGreenText,
                    ),
                    //-----------------------REVIEWS
                    ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: reviews.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return ReviewWidget(review: reviews[pos]);
                      },
                    ),
                    //-----------------------BOTTOM AREA
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: BlocBuilder<AuthBlocFake, AuthStateFake>(
                        builder: (context, state) {
                          if (state is SignedInAuthStateFake) {
                            String name = state.username;
                            bool reviewed = false;
                            for (ReviewModel review in reviews) {
                              if (review.username == name) {
                                reviewed = true;
                                break;
                              }
                            }
                            if (!reviewed) {
                              //-----------------------NEW REVIEW WIDGET
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
                            //-----------------------SIGN IN PROMPT
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
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
                                    child: LoginScreenFake(),
                                    type: PageTransitionType.fade,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    //-----------------------FOOTER
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
                    (BlocProvider.of<AuthBlocFake>(context).state
                            as SignedInAuthStateFake)
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
                      textColor: darkGreyColor,
                      color: Colors.lightGreenAccent,
                      borderShape: RoundedRectangleBorder(
                          borderRadius: primaryCircleBorderRadius),
                      child: Text(
                        "submit",
                        style: darkGreyText.copyWith(fontSize: 18),
                      ),
                      onPressed: () {
                        if ((BlocProvider.of<AuthBlocFake>(context).state
                                as SignedInAuthStateFake)
                            .username
                            .isNotEmpty) {
                          onReviewed(
                              (BlocProvider.of<AuthBlocFake>(context).state
                                      as SignedInAuthStateFake)
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
