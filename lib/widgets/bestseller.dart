import 'package:flutter/material.dart';

class BestsellerWidget extends StatelessWidget {
  const BestsellerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 66,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.8),
          borderRadius: BorderRadius.circular(3)),
      child: const Align(
          child: Text(
        "Bestseller",
        style: TextStyle(fontSize: 12),
      )),
    );
  }
}
