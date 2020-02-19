import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/blocs/list_bloc.dart';
import 'package:mygameslist_flutter/components/article_widget.dart';
import 'package:mygameslist_flutter/models/wiki_model.dart';
import 'package:mygameslist_flutter/views/details_screen.dart';
import 'package:page_transition/page_transition.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    if (!(BlocProvider.of<ListBloc>(context).state is ListLoadedState)) {
      BlocProvider.of<ListBloc>(context).add(ListLoadEvent());
    }
    return Scaffold(
      drawer: Drawer(),
      body: Container(
        child: BlocBuilder<ListBloc, ListLoadState>(
          builder: (context, state) {
            if (state is ListLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ListFailedState) {
              return Center(child: Text("error"));
            } else {
              List<WikiModel> articles = (state as ListLoadedState).articles;
              return CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: true,
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                      ),
                    ],
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        "MyGamesList",
                        style: TextStyle(
                            fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                      ),
                      background: Image.asset(
                        'images/header.jpg',
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.darken,
                        color: Color(0x66000000),
                      ),
                    ),
                    expandedHeight: 180,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ArticleWidget(
                        article: articles[index],
                        onTap: (image) {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: DetailsScreen(
                                tempImage: image,
                                id: articles[index].id,
                              ),
                            ),
                          );
                        },
                      );
                    }, childCount: articles.length),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
