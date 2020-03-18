import 'package:flutter/material.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/components/side_drawer.dart';
import 'dart:math' as math;

class PerspectiveDrawer extends StatelessWidget {
  const PerspectiveDrawer({
    Key key,
    @required AnimationController controller,
    @required this.drawerWidth,
    @required this.body,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;
  final double drawerWidth;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Container(
              color: darkGreyColor,
            ),
            Transform.translate(
              offset: Offset(drawerWidth * (_controller.value - 1), 0),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..scale(1.0 +
                      ((_controller.value < 0.5
                              ? _controller.value
                              : (1.0 - _controller.value)) *
                          0.4))
                  ..rotateY(
                    math.pi / 2 * (1 - _controller.value),
                  ),
                alignment: Alignment.centerRight,
                child: Container(
                  width: 255,
                  child: SideDrawer(
                    controller: _controller,
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(drawerWidth * _controller.value, 0),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..scale(1.0 +
                      ((_controller.value < 0.5
                              ? _controller.value
                              : (1.0 - _controller.value)) *
                          0.4))
                  ..rotateY(
                    (-math.pi * _controller.value / 2),
                  ),
                alignment: Alignment.centerLeft,
                child: child,
              ),
            ),
          ],
        );
      },
      child: body,
    );
  }
}
