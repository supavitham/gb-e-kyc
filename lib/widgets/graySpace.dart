import 'package:flutter/material.dart';

class GraySpace extends StatelessWidget {
  final double boxHeight;
  const GraySpace({required this.boxHeight, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: boxHeight, width: double.infinity, color: Colors.grey[100]);
  }
}
