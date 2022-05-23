import 'package:flutter/material.dart';
import 'package:gb_e_kyc/screens/e_kyc_screen.dart';
import 'package:get/route_manager.dart';

class EKYCButtonWidget extends StatefulWidget {
  final BoxDecoration? boxDecorationContainer;
  final String? title;
  final TextStyle? textStyle;
  final double? heightContainer;
  final double? widthContainer;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const EKYCButtonWidget({Key? key, this.boxDecorationContainer, this.title, this.textStyle, this.heightContainer, this.widthContainer, this.padding, this.margin}) : super(key: key);

  @override
  State<EKYCButtonWidget> createState() => _EKYCButtonWidgetState();
}

class _EKYCButtonWidgetState extends State<EKYCButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(EKYCScreen()),
      child: Container(
        width: widget.widthContainer,
        height: widget.heightContainer,
        padding: widget.padding == null ? EdgeInsets.symmetric(vertical: 16, horizontal: 8) : widget.padding,
        margin: widget.margin == null ? EdgeInsets.all(8) : widget.margin,
        decoration: widget.boxDecorationContainer == null
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              )
            : widget.boxDecorationContainer,
        child: Center(
          child: Text(
            "${widget.title ?? "KYC 2"}",
            style: widget.textStyle == null ? TextStyle(fontSize: 20, color: Colors.black) : widget.textStyle,
          ),
        ),
      ),
    );
  }
}
