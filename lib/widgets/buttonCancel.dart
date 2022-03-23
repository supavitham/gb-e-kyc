import 'package:flutter/material.dart';

class ButtonCancel extends StatelessWidget {
  final Function? onPressed;
  final String? text;
  final double width;

  const ButtonCancel({this.onPressed, this.text, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(color: Color(0xFF02416D)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text!, style: TextStyle(color: Color(0xFF02416D))),
        ),
        onPressed: onPressed as void Function()?,
      ),
    );
  }
}
