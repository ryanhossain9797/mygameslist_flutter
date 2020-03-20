import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class FLutterStickyHeaderExperimentalWidget extends StatefulWidget {
  @override
  _FLutterStickyHeaderExperimentalWidgetState createState() =>
      _FLutterStickyHeaderExperimentalWidgetState();
}

class _FLutterStickyHeaderExperimentalWidgetState
    extends State<FLutterStickyHeaderExperimentalWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Container(
        color: Colors.red,
        height: 200,
      ),
      sliver: SliverToBoxAdapter(
        child: Container(
          color: Colors.green,
          height: 400,
        ),
      ),
    );
  }
}
