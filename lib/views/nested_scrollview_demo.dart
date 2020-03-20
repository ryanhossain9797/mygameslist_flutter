import 'package:flutter/material.dart';
import 'package:mygameslist_flutter/components/review_widget.dart';
import 'package:mygameslist_flutter/experimental/flutter_sticky_header_widget.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class NestedScrollviewDemo extends StatefulWidget {
  @override
  _NestedScrollviewDemoState createState() => _NestedScrollviewDemoState();
}

class _NestedScrollviewDemoState extends State<NestedScrollviewDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: const Text('Books'), // This is the title in the app bar.
          pinned: true,
          expandedHeight: 150.0,
          // The "forceElevated" property causes the SliverAppBar to show
          // a shadow. The "innerBoxIsScrolled" parameter is true when the
          // inner scroll view is scrolled beyond its "zero" point, i.e.
          // when it appears to be scrolled below the SliverAppBar.
          // Without this, there are cases where the shadow would appear
          // or not appear inappropriately, because the SliverAppBar is
          // not actually aware of the precise position of the inner
          // scroll views.
        ),
        for (int i = 0; i < 10; i++) FLutterStickyHeaderExperimentalWidget(),
      ],
    ));
  }
}
