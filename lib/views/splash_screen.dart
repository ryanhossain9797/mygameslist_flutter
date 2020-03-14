import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/blocs/details_bloc.dart';
import 'package:mygameslist_flutter/blocs/list_bloc.dart';
import 'package:mygameslist_flutter/views/home_screen.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    //-----------------------------------Start initial load
    BlocProvider.of<ListBloc>(context).add(ListLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListBloc, ListLoadState>(
      listener: (context, state) {
        //-------------------------------Splash Screen stays until initial load
        if (!(state is ListLoadingState || state is ListInitialState)) {
          Navigator.pushReplacement(
            context,
            PageTransition(type: PageTransitionType.fade, child: HomeScreen()),
          );
        }
      },
      child: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            "images/icon.png",
            width: 200,
          ),
        ),
      ),
    );
  }
}
