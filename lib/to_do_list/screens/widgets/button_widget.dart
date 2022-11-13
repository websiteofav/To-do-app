import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final double width;
  final String title;
  final VoidCallback omTap;
  final TextStyle style;
  const ButtonWidget(
      {Key? key,
      required this.width,
      required this.title,
      required this.omTap,
      required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: omTap,
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.orange,

            // border: Border.all(
            //   color: Colors.red[500],
            // ),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        height: 50,
        width: width,
        margin: const EdgeInsets.fromLTRB(5, 20, 5, 10),
        // margin: EdgeInsets.all(25),
        child: Text(
            // color: Colors.blueAccent,
            // textColor: Colors.white,

            title,
            style: style
            //  {
            ),
      ),
    );
  }
}
