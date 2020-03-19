import 'package:flutter/material.dart';
import 'package:mygameslist_flutter/styles.dart';
import 'package:mygameslist_flutter/views/nested_scrollview_demo.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mygameslist_flutter/views/practice_screen.dart';

class SideDrawer extends StatefulWidget {
  AnimationController controller;

  SideDrawer({this.controller});
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  bool loaded = false;
  bool switchValue = false;

  SharedPreferences prefs;
  _getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loaded = true;
      switchValue = prefs.getBool('on') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getPrefs();
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Settings",
                  style: darkGreyText,
                ),
              ],
            ),
            decoration: BoxDecoration(color: Colors.lightGreenAccent),
          ),
          loaded
              ? Switch(
                  value: switchValue,
                  onChanged: (value) {
                    prefs.setBool('on', value);
                    setState(() {
                      switchValue = value;
                    });
                  },
                )
              : Container(),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: NestedScrollviewDemo(),
                  type: PageTransitionType.fade,
                ),
              );
            },
            title: Text("Launch Nested Demo"),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: PracticeScreen(),
                ),
              );
            },
            title: Text("Practice Screen"),
          ),
        ],
      ),
    );
  }
}
