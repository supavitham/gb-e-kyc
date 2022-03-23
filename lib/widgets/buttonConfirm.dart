import 'package:flutter/material.dart';

class ButtonConfirm extends StatelessWidget {
  final Function? onPressed;
  final String? text;
  final double radius;
  final double width;
  final EdgeInsetsGeometry margin;
  final Color? colorText;

  const ButtonConfirm({
    this.onPressed,
    this.text,
    this.radius = 25,
    this.width = double.infinity,
    this.margin = EdgeInsets.zero,
    this.colorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF115899),
            Color(0xFF02416D),
          ],
        ),
      ),
      child: MaterialButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: FittedBox(fit: BoxFit.scaleDown, child: Text(text!,style: TextStyle(color: colorText == null ? null : colorText),)),
        onPressed: onPressed as void Function()?,
      ),
    );
  }
}
