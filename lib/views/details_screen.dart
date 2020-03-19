import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/loader/gf_loader.dart';
import 'package:getflutter/types/gf_loader_type.dart';
import 'package:mygameslist_flutter/blocs/details_bloc.dart';
import 'package:mygameslist_flutter/blocs/login_bloc.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/components/game_widget.dart';
import 'package:mygameslist_flutter/components/input_field.dart';
import 'package:mygameslist_flutter/components/large_button.dart';
import 'package:mygameslist_flutter/components/loading_indicator.dart';
import 'package:mygameslist_flutter/components/perspective_drawer.dart';
import 'package:mygameslist_flutter/components/review_widget.dart';
import 'package:mygameslist_flutter/components/side_drawer.dart';
import 'package:mygameslist_flutter/components/user_avatar.dart';
import 'package:mygameslist_flutter/styles.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/models/game_model.dart';
import 'package:mygameslist_flutter/views/home_screen.dart';
import 'package:mygameslist_flutter/views/login_screen.dart';
import 'package:mygameslist_flutter/views/review_screen.dart';
import 'package:page_transition/page_transition.dart';

class DetailsScreen extends StatefulWidget {
  final CachedNetworkImageProvider tempImage;
  final String id;
  DetailsScreen({this.tempImage, this.id});
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with TickerProviderStateMixin {
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
            //---------------Boilerplate for preventing overlap in sliverappbar
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverAppBar(
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
                          //---------------Gradient on appbar
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
                  UserAvatar(), //---------------Avatar Icon on right of appbar
                ],
              ),
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
              GameModel _article = (state as DetailsLoadedState).game;
              List<ReviewModel> _reviews =
                  (state as DetailsLoadedState).reviews;
              // return DetailsBodyWidget(article: article, reviews: reviews);
              return Builder(
                builder: (context) {
                  return CustomScrollView(
                    key: PageStorageKey("details"),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            //-----------------------TITLE
                            Padding(
                              child: Text(
                                _article.title,
                                textAlign: TextAlign.center,
                                style: boldGreenText,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                            ),
                            //-----------------------DESCRIPTION
                            Container(
                              decoration: BoxDecoration(color: darkGreyColor),
                              padding: EdgeInsets.all(20),
                              child: MarkdownBody(
                                data: _article.content,
                                styleSheet: MarkdownStyleSheet(
                                  code: TextStyle(color: darkGreyColor),
                                ),
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
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ReviewWidget(
                              review: _reviews[index],
                            );
                          },
                          childCount: _reviews.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  if (state is LoggedInLoginState) {
                                    String email = state.email;
                                    bool reviewed = false;
                                    for (ReviewModel review in _reviews) {
                                      if (review.email == email) {
                                        reviewed = true;
                                        break;
                                      }
                                    }
                                    if (!reviewed) {
                                      //-----------------------NEW REVIEW BUTTON
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: LargeButton(
                                            onPress: () => Navigator.push(
                                              context,
                                              PageTransition(
                                                child: ReviewScreen(),
                                                type: PageTransitionType.fade,
                                              ),
                                            ),
                                            text: "Review as ${state.username}",
                                          ));
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    //-----------------------SIGN IN PROMPT IF NOT SIGNED IN
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: LargeButton(
                                        text: "Sign In to review",
                                        onPress: () => Navigator.push(
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
                            //-----------------------FOOTER
                            Container(
                              height: 100,
                              child: Center(
                                child: Text(
                                  "Total ${_reviews.length} reviews",
                                  style: boldGreenText.copyWith(fontSize: 24),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailsBodyWidget extends StatelessWidget {
  const DetailsBodyWidget({
    Key key,
    @required this.article,
    @required this.reviews,
  }) : super(key: key);

  final GameModel article;
  final List<ReviewModel> reviews;

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          ),
          //-----------------------DESCRIPTION
          Container(
            decoration: BoxDecoration(color: darkGreyColor),
            padding: EdgeInsets.all(20),
            child: MarkdownBody(
              data: article.content,
              styleSheet: MarkdownStyleSheet(
                code: TextStyle(color: darkGreyColor),
              ),
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
          SizedBox(
            height: 15,
          ),
          //-----------------------REVIEWS
          for (var review in reviews)
            ReviewWidget(
              review: review,
            ), //-------------Minimum dart version 2.5
          //-----------------------BOTTOM AREA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                if (state is LoggedInLoginState) {
                  String email = state.email;
                  bool reviewed = false;
                  for (ReviewModel review in reviews) {
                    if (review.email == email) {
                      reviewed = true;
                      break;
                    }
                  }
                  if (!reviewed) {
                    //-----------------------NEW REVIEW BUTTON
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: LargeButton(
                          onPress: () => Navigator.push(
                            context,
                            PageTransition(
                              child: ReviewScreen(),
                              type: PageTransitionType.fade,
                            ),
                          ),
                          text: "Review as ${state.username}",
                        ));
                  } else {
                    return Container();
                  }
                } else {
                  //-----------------------SIGN IN PROMPT IF NOT SIGNED IN
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: LargeButton(
                      text: "Sign In to review",
                      onPress: () => Navigator.push(
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
                    (BlocProvider.of<LoginBloc>(context).state
                            as LoggedInLoginState)
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
                        var state = (BlocProvider.of<LoginBloc>(context).state
                            as LoggedInLoginState);
                        if (state.username.isNotEmpty) {
                          onReviewed(state.username, reviewController.text);
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
          InputBox(
            hint: "review",
            controller: reviewController,
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
      child: InputField(
        controller: controller != null ? controller : TextEditingController(),
        hintText: hint,
      ),
    );
  }
}
