import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/blocs/auth_bloc.dart';
import 'package:mygameslist_flutter/models/review_model.dart';

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
        color: Colors.grey[800],
      ),
      child: AnimatedSize(
        vsync: this,
        duration: Duration(milliseconds: 200),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: Builder(
            key: deleting ? deleteKey : displayKey,
            builder: (context) {
              return deleting
                  ? Container(
                      height: 100,
                      color: Colors.red,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            deleting = false;
                          });
                        },
                        child: Center(
                          child: Text("Cancel"),
                        ),
                      ),
                    )
                  : Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.review.username,
                                style: TextStyle(
                                  color: Colors.lightGreenAccent,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.review.review)
                            ],
                          ),
                        ),
                        //-------------------------------------Renders CROSS button if signed in and username matches review user
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is SignedInAuthState) {
                              if (state.username == widget.review.username) {
                                return CircleAvatar(
                                  backgroundColor: Colors.lightGreenAccent,
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    color: Colors.grey[800],
                                    icon: Icon(
                                      Icons.delete,
                                    ),
                                    onPressed: () {
                                      print("pressed");
                                      setState(() {
                                        deleting = true;
                                      });
                                      print(deleting);
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
                    );
            },
          ),
        ),
      ),
    );
  }
}
