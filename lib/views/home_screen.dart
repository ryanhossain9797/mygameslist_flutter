import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/blocs/list_bloc.dart';
import 'package:mygameslist_flutter/components/article_widget.dart';
import 'package:mygameslist_flutter/components/side_drawer.dart';
import 'package:mygameslist_flutter/components/user_avatar.dart';
import 'package:mygameslist_flutter/models/wiki_model.dart';
import 'package:mygameslist_flutter/views/details_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animations/animations.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (!(BlocProvider.of<ListBloc>(context).state is ListLoadedState)) {
      BlocProvider.of<ListBloc>(context).add(ListLoadEvent());
    }
    return Scaffold(
      drawer: SideDrawer(),
      body: Container(
        child: BlocBuilder<ListBloc, ListLoadState>(
          builder: (context, state) {
            if (state is ListLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ListFailedState) {
              //------------------------------------------------Load Error
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("error"),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => BlocProvider.of<ListBloc>(context)
                            .add(ListLoadEvent()),
                      ),
                    )
                  ],
                ),
              );
            } else {
              TabController _tabController =
                  TabController(length: 2, vsync: this);
              List<WikiModel> _articles = (state as ListLoadedState).articles;
              return NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    //-------------------------------------------------AppBar
                    SliverAppBar(
                      centerTitle: true,
                      title: Text(
                        "MyGamesList",
                        style: TextStyle(
                            fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                      ),
                      automaticallyImplyLeading: true,
                      actions: <Widget>[
                        //-------------------------------------------User Avatar
                        UserAvatar(),
                      ],
                      pinned: true,

                      //----------------------------------------------AppBar Background Image
                      flexibleSpace: FlexibleSpaceBar(
                        background: Image.asset(
                          'images/header.jpg',
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.darken,
                          color: Color(0x66000000),
                        ),
                      ),
                      expandedHeight: 180,

                      //----------------------------------------------Tab Buttons
                      bottom: TabBar(
                        indicatorColor: Colors.lightGreenAccent,
                        controller: _tabController,
                        tabs: <Widget>[
                          Tab(child: Icon(Icons.list)),
                          Tab(child: Icon(Icons.favorite)),
                        ],
                      ),
                    ),
                  ];
                },

                //-----------------------------------------------------Tab Body
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    //--------------------------------------------------Tab 1
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: _articles.length,
                        itemBuilder: (BuildContext context, int index) {
                          //-------------------------------------------All Game Articles
                          return ArticleWidget(
                            article: _articles[index],
                            onTap: (image) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: DetailsScreen(
                                    tempImage: image,
                                    id: _articles[index].id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    //----------------------------------------------Tab 2
                    Container(
                      child: Center(
                        child: Text("TAB 2"),
                      ),
                    )
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
