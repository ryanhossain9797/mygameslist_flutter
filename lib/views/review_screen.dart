import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:mygameslist_flutter/blocs/details_bloc.dart';
import 'package:mygameslist_flutter/blocs/login_bloc.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/components/input_field.dart';
import 'package:mygameslist_flutter/components/large_button.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/styles.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String text = "";
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String articleId;
    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (context) {
        var loginState = BlocProvider.of<LoginBloc>(context).state;
        var loadState = BlocProvider.of<DetailsBloc>(context).state;
        if (!(loginState is LoggedInLoginState) ||
            !(loadState is DetailsLoadedState)) {
          return Center(
            child: Text(
                "Either you're not logged in or the app has failed load\nEither way you shouldn't have been able to see this screen"),
          );
        } else {
          articleId = (loadState as DetailsLoadedState).game.id;
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 15),
                Row(
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
                            BlocProvider.of<DetailsBloc>(context).add(
                              SubmitReviewDetailsEvent(
                                review: ReviewModel(
                                  review: _controller.text,
                                  articleId: articleId,
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )
                  ],
                ),
                InputField(
                  keyBoardType: TextInputType.multiline,
                  hintText: "review",
                  controller: _controller,
                  maxLines: null,
                ),
                SizedBox(
                  height: 15,
                ),
                LargeButton(
                  text: "Update preview",
                  onPress: () {
                    setState(() {
                      text = _controller.text;
                    });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                MarkdownBody(
                  data: text,
                  styleSheet: MarkdownStyleSheet(
                    code: TextStyle(color: darkGreyColor),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
