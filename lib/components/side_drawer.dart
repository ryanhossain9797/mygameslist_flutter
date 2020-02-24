import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideDrawer extends StatefulWidget {
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
                Text("Settings"),
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
              : Container()
        ],
      ),
    );
  }
}
