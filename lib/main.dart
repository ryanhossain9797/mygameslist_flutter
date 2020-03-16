import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/blocs/login_bloc.dart';
import 'package:mygameslist_flutter/blocs/signup_bloc.dart';
import 'package:mygameslist_flutter/blocs/list_bloc.dart';
import 'package:mygameslist_flutter/views/home_screen.dart';
import 'package:mygameslist_flutter/views/splash_screen.dart';

import 'blocs/details_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiBlocProvider(
      providers: [
        BlocProvider<ListBloc>(create: (context) => ListBloc()),
        BlocProvider<DetailsBloc>(create: (context) => DetailsBloc()),
        BlocProvider<SignupBloc>(create: (context) => SignupBloc()),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        darkTheme:
            ThemeData.dark().copyWith(accentColor: Colors.lightGreenAccent),
        themeMode: ThemeMode.dark,
        home: SplashScreen(),
      ),
    );
  }
}
