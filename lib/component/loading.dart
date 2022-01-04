import 'package:flutter/material.dart';
import 'package:rajaongkir/component/cube_grid.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitCubeGrid(
      size: 51.0,
      color: Theme.of(context).primaryColor,
    );
  }
}