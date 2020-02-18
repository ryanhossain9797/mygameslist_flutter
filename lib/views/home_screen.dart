import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/blocs/list_bloc.dart';
import 'package:mygameslist_flutter/components/article_widget.dart';
import 'package:mygameslist_flutter/models/wiki_model.dart';
import 'package:mygameslist_flutter/views/details_screen.dart';

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
      appBar: AppBar(
        title: Text("MyGamesList"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(child: BlocBuilder<ListBloc, ListLoadState>(
          builder: (context, state) {
            if (state is ListLoadingState) {
              return CircularProgressIndicator();
            } else if (state is ListFailedState) {
              return Text("error");
            } else {
              List<WikiModel> articles = (state as ListLoadedState).articles;
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: articles.length,
                itemBuilder: (context, pos) {
                  return ArticleWidget(
                    article: articles[pos],
                    onTap: (image) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                  tempImage: image, id: articles[pos].id)));
                    },
                  );
                },
              );
            }
          },
        )),
      ),
    );
  }
}
