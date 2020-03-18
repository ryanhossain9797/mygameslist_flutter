import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getflutter/components/loader/gf_loader.dart';
import 'package:getflutter/types/gf_loader_type.dart';
import 'package:mygameslist_flutter/blocs/list_bloc.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/components/game_widget.dart';
import 'package:mygameslist_flutter/components/loading_indicator.dart';
import 'package:mygameslist_flutter/components/perspective_drawer.dart';
import 'package:mygameslist_flutter/components/side_drawer.dart';
import 'package:mygameslist_flutter/components/user_avatar.dart';
import 'package:mygameslist_flutter/models/game_model.dart';
import 'package:mygameslist_flutter/styles.dart';
import 'package:mygameslist_flutter/views/details_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animations/animations.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    var state = BlocProvider.of<ListBloc>(context);
    if (state is ListInitialState || state is ListLoadingState) {
      BlocProvider.of<ListBloc>(context).add(ListLoadEvent());
    }
    state.close();
    super.initState();
  }

  //------------------------------Experimental Animations

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      drawer: SideDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            //-------------------------------------------------AppBar
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                  centerTitle: true,
                  title: Text(
                    "MyGamesList",
                    style: appBarText,
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
              ),
            ),
          ];
        },

        //-----------------------------------------------------Tab Body
        body: BlocBuilder<ListBloc, ListLoadState>(
          builder: (context, state) {
            if (state is ListLoadingState || state is ListInitialState) {
              return Center(
                child: LoadingIndicator(),
              );
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
              List<GameModel> _articles = (state as ListLoadedState).games;
              return TabBarView(
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
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: GameWidget(
                            game: _articles[index],
                            onTap: (image) {
                              //--------------------TODO {LoadDetailEvent here instead?}
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
                          ),
                        );
                      },
                    ),
                  ),

                  //----------------------------------------------Tab 2
                  Container(
                    child: Center(
                      child: Text("TAB 2"),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
