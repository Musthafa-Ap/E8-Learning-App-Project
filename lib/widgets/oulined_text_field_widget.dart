import 'package:flutter/material.dart';

class OutlinedTextFieldWidget extends StatelessWidget {
  final hintText;
  const OutlinedTextFieldWidget({required this.hintText});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.black,
          border: Border.all(color: Colors.white)),
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
