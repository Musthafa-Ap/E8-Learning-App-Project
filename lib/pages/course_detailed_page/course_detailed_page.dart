import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuox_project/constants/constants.dart';
import 'package:nuox_project/pages/course_detailed_page/recomendations_services/recomendations_provider.dart';
import 'package:nuox_project/pages/course_detailed_page/services/course_detailed_provider.dart';
import 'package:nuox_project/pages/review_page/review_page.dart';
import 'package:nuox_project/widgets/bestseller.dart';
import 'package:nuox_project/widgets/bold_heading.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/course_detailes_list_tile.dart';

class CourseDetailedPage extends StatelessWidget {
  CourseDetailedPage({super.key});
  ValueNotifier _selectedValue = ValueNotifier("Beginner");
  var _items = ["Beginner", "Intermediate", "Expert"];
  @override
  Widget build(BuildContext context) {
    final courseDeailedProvider = Provider.of<CourseDetailedProvider>(context);
    final recomendationsProvider = Provider.of<RecomendationsProvider>(context);

    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Featured"),
        actions: [
          KWidth5,
          IconButton(
              onPressed: () async {
                await Share.share(
                    "https://i.guim.co.uk/img/media/71dd7c5b208e464995de3467caf9671dc86fcfd4/1176_345_3557_2135/master/3557.jpg?width=620&quality=45&dpr=2&s=none");
              },
              icon: const Icon(CupertinoIcons.share))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Container(
              height: size * .5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(courseDeailedProvider
                    .courseDetailes!.data!.first.thumbnail!.fullSize
                    .toString()),
              ))),
          KHeight15,
          BoldHeading(
              heading: courseDeailedProvider
                  .courseDetailes!.data!.first.courseName
                  .toString()),
          KHeight5,
          Text(
            "All-in-one Guitar Course,FingerStyle Guitar,Blues Guitar,Acoustic Guitar,Electric Guitar & Fingerpicking Guitarra",
            style: TextStyle(color: Colors.white),
          ),
          KHeight,
          const Align(
              alignment: Alignment.centerLeft, child: BestsellerWidget()),
          KHeight,
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ReviewPage()));
            },
            child: Text(
              "${courseDeailedProvider.courseDetailes!.data!.first.rating} *****",
              style: const TextStyle(fontSize: 12, color: Colors.yellow),
            ),
          ),
          KHeight,
          Row(
            children: [
              Text(
                "(2,414 ratings)",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              KWidth5,
              Text(
                "18,267 students",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          KHeight5,
          ValueListenableBuilder(
            valueListenable: _selectedValue,
            builder: (context, value, child) {
              int actual_price = courseDeailedProvider
                  .courseDetailes!.data!.first.price!
                  .toInt();
              int exdiscount = ((courseDeailedProvider
                              .courseDetailes!.variant![1].amountPerc! /
                          100) *
                      actual_price)
                  .toInt();
              int expert_price = actual_price - exdiscount;
              int interdiscount = ((courseDeailedProvider
                              .courseDetailes!.variant![2].amountPerc! /
                          100) *
                      actual_price)
                  .toInt();
              int inter_price = actual_price - interdiscount;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        (value == "Beginner")
                            ? courseDeailedProvider
                                .courseDetailes!.data!.first.price
                                .toString()
                            : (value == "Intermediate")
                                ? inter_price.toString()
                                : expert_price.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 27),
                      ),
                      KWidth10,
                      Text(
                        "₹7499",
                        style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                  Container(
                    height: 30,
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButton(
                        underline: const SizedBox(),
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: Colors.purple,
                        iconEnabledColor: Colors.black,
                        value: value,
                        items: _items
                            .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e,
                                    style: TextStyle(color: Colors.black))))
                            .toList(),
                        onChanged: (newValue) {
                          _selectedValue.value = newValue;
                        }),
                  )
                ],
              );
            },
          ),
          KHeight,
          Row(
            children: [
              const Text(
                "Author -  ",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                courseDeailedProvider
                    .courseDetailes!.data!.first.instructor!.name
                    .toString(),
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
          KHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Buy now"),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22))),
                    backgroundColor: MaterialStateProperty.all(Colors.purple)),
              ),
            ),
          ),
          KHeight,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22))),
                    side: MaterialStateProperty.all(const BorderSide(
                      color: Colors.white,
                    ))),
              ),
            ),
          ),
          KHeight15,
          const BoldHeading(heading: "Recommendations"),
          ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount:
                recomendationsProvider.recomendationsCourses!.data!.length,
            itemBuilder: (context, index) {
              final datas =
                  recomendationsProvider.recomendationsCourses!.data![index];
              return CourseDetailesListTile(
                  courseName: datas.courseName.toString(),
                  authorName: datas.instructor!.name.toString(),
                  coursePrice: datas.price!.toDouble(),
                  image: datas.thumbnail!.fullSize.toString(),
                  rating: datas.rating!.toDouble(),
                  id: datas.id!.toInt());
            },
          ),
        ],
      ),
    );
  }
}
