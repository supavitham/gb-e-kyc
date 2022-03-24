import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String? title, textConfirm, textCancel;

  final VoidCallback? onPressedConfirm, onPressedCancel;

  DeleteDialog({
    this.title,
    this.textConfirm,
    this.textCancel,
    this.onPressedConfirm,
    this.onPressedCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 30, left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    title!,
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
              SizedBox(height: 30),
              Column(children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF115899),
                        Color(0xFF02416D),
                      ],
                    ),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onPressed: onPressedConfirm,
                    child: Text(textConfirm!),
                  ),
                ),
                SizedBox(height: 15)
              ]),
              Column(children: [
                MaterialButton(
                  minWidth: double.infinity,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: Color(0xFF02416D)),
                  ),
                  child: Text(
                    textCancel!,
                    style: TextStyle(
                      color: Color(0xFF02416D),
                    ),
                  ),
                  onPressed: onPressedCancel,
                ),
                SizedBox(height: 40)
              ])
            ],
          ),
        ),
        CircleAvatar(
          child: Image.asset(
            'assets/images/Exclamation.png',
            height: 48,
            width: 48,
          ),
          maxRadius: 32,
          backgroundColor: Colors.white,
        )
      ],
    );
  }
}
