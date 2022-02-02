import 'package:flutter/material.dart';

class TextTagButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  const TextTagButton({Key? key, required this.text, required this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(50)),
      height: 16,
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white),
      ),
    );
  }
}
