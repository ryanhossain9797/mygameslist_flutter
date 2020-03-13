import 'package:flutter/material.dart';
import 'package:getflutter/components/loader/gf_loader.dart';
import 'package:getflutter/types/gf_loader_type.dart';
import 'package:mygameslist_flutter/colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFLoader(
      type: GFLoaderType.circle,
      loaderColorOne: lightAccentColor,
      loaderColorTwo: lightAccentColor,
      loaderColorThree: lightAccentColor,
    );
  }
}
