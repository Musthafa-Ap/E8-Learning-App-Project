import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuox_project/constants/constants.dart';
import 'package:nuox_project/pages/featured/sections/notifications_section/notifications_page.dart';
import 'package:nuox_project/pages/featured/services/featured_section/featured_provider.dart';
import 'package:nuox_project/pages/featured/services/top_courses_section/top_courses_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../course_detailed_page/course_detailed_page.dart';
import '../course_detailed_page/services/course_detailed_provider.dart';
import 'sections/featured_section/featured_section.dart';
import 'widgets/top_text_section.dart';

class Featured extends StatefulWidget {
  const Featured({super.key});

  @override
  State<Featured> createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  late Timer _timer;
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  @override
  void initState() {
    final topCoursesProvider =
        Provider.of<TopCoursesProvider>(context, listen: false);
    preffunc();
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (currentIndex <
          topCoursesProvider.banner!.data!.first.bannerImg!.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }

      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  int currentIndex = 0;
  String? username;

  @override
  Widget build(BuildContext context) {
    final topCoursesProvider = Provider.of<TopCoursesProvider>(context);
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.grey,
              statusBarBrightness: Brightness.light),
          automaticallyImplyLeading: false,
          title: const Text(
            "NUOX Learning App",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<FeaturedProvider>(context, listen: false)
                      .getNotifications();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NotificationsPage()));
                },
                icon: const Icon(Icons.notifications_outlined))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            username == null
                ? const Text(
                    "Welcome, ",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )
                : Text(
                    "Welcome $username,",
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
            kHeight,
            topCoursesProvider.banner == null ||
                    topCoursesProvider.banner!.data!.first.bannerImg!.isEmpty
                ? const SizedBox()
                : Stack(
                    children: [
                      SizedBox(
                        height: size * .5,
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          itemCount: topCoursesProvider
                              .banner!.data!.first.bannerImg!.length,
                          itemBuilder: (context, index) {
                            final datas = topCoursesProvider
                                .banner!.data!.first.bannerImg![index];
                            // final data = _images[index];
                            return GestureDetector(
                              onTap: () async {
                                await Provider.of<CourseDetailedProvider>(
                                        context,
                                        listen: false)
                                    .getAll(courseID: datas.actionId);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CourseDetailedPage()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            datas.bannerImg.toString()))),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                topCoursesProvider.banner!.data!.first
                                    .bannerImg!.length, (index) {
                              return Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == index
                                        ? Colors.purple
                                        : Colors.grey),
                              );
                            })),
                      )
                    ],
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [TopTextSection(), FeaturedSection()],
            )
          ],
        ));
  }

  void preffunc() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPrefs.getString("name");
    });
  }
}
