import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:mygameslist_flutter/blocs/details_bloc.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/models/wiki_model.dart';

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
    BlocProvider.of<DetailsBloc>(context).add(LoadDetailsEvent(widget.id));
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Hero(
              tag: widget.id,
              child: Image(
                image: widget.tempImage,
              ),
            ),
            BlocBuilder<DetailsBloc, DetailsLoadState>(
              builder: (context, state) {
                if (state is DetailsLoadingState) {
                  return Expanded(
                      child: Center(child: CircularProgressIndicator()));
                } else if (state is DetailsFailedState) {
                  return Expanded(child: Center(child: Text("error")));
                } else {
                  WikiModel article = (state as DetailsLoadedState).article;
                  List<ReviewModel> reviews =
                      (state as DetailsLoadedState).reviews;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                article.title,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'Poppins',
                                    color: Colors.lightGreenAccent),
                              ),
                              padding: EdgeInsets.all(20),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                article.content,
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Reviews",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: "Poppins",
                                  color: Colors.lightGreenAccent),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: reviews.length,
                              itemBuilder: (BuildContext context, int pos) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[800]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        reviews[pos].username,
                                        style: TextStyle(
                                            color: Colors.lightGreenAccent,
                                            fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(reviews[pos].review),
                                    ],
                                  ),
                                );
                              },
                            ),
                            ReviewWidget(
                              onReviewed: (username, review) {
                                BlocProvider.of<DetailsBloc>(context).add(
                                  ReviewDetailsEvent(
                                    review: ReviewModel(
                                        id: article.id,
                                        username: username,
                                        review: review),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

typedef ReviewCallback(String username, String review);

class ReviewWidget extends StatelessWidget {
  ReviewWidget({Key key, @required this.onReviewed}) : super(key: key);

  final ReviewCallback onReviewed;

  String username = "";
  String review = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InputBox(
                    hint: "username",
                    onChange: (text) {
                      username = text;
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GFButton(
                      textColor: Colors.grey[800],
                      color: Colors.lightGreenAccent,
                      borderShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text("submit"),
                      onPressed: () {
                        if (username.isNotEmpty && review.isNotEmpty) {
                          onReviewed(username, review);
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: InputBox(
              hint: "review",
              onChange: (text) {
                review = text;
              },
            ),
          ),
        ],
      ),
    );
  }
}

typedef InputCallback(String text);

class InputBox extends StatelessWidget {
  const InputBox({Key key, this.hint = "hint", @required this.onChange})
      : super(key: key);

  final String hint;
  final InputCallback onChange;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(cursorColor: Colors.lightGreenAccent),
      child: TextField(
        onChanged: (text) {
          onChange(text);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.grey[800]),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.lightGreenAccent),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Colors.greenAccent),
          ),
        ),
      ),
    );
  }
}
