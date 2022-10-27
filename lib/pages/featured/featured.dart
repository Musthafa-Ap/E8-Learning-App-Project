import 'package:flutter/material.dart';
import 'package:nuox_project/constants/constants.dart';

import 'sections/featured_section/featured_section.dart';
import 'widgets/top_image_section.dart';
import 'widgets/top_text_section.dart';

class Featured extends StatelessWidget {
  Featured({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hello User,"),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            const TopImageSection(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [TopTextSection(), FeaturedSection()],
            )
          ],
        ));
  }
}
