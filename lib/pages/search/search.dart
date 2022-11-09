import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuox_project/constants/constants.dart';
import 'package:nuox_project/pages/search/services/search_provider.dart';
import 'package:nuox_project/widgets/bold_heading.dart';
import 'package:provider/provider.dart';

import '../course_detailed_page/course_detailed_page.dart';
import '../course_detailed_page/services/course_detailed_provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<Map<String, dynamic>> _tileDetailes = [
    {"title": "Development", "icon": Icons.developer_mode},
    {"title": "Business", "icon": Icons.business},
    {"title": "Photography", "icon": Icons.photo_camera},
    {"title": "IT & Software", "icon": Icons.computer_outlined},
    {"title": "Office Productivity", "icon": Icons.build},
  ];

  List<Map<String, dynamic>> _foundItems = [];
  @override
  void initState() {
    _foundItems = _tileDetailes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoSearchTextField(
              onChanged: (value) {
                //  searchProvider.searchList == null;

                searchProvider.getSearchItems(key: value);
                searchProvider.searchList;

                //dynamic aayi search cheythath =  _runFilter(value);
              },
              backgroundColor: Colors.grey.withOpacity(.4),
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: Colors.grey,
              ),
              suffixIcon: const Icon(
                CupertinoIcons.xmark,
                color: Colors.white,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            KHeight,
            const BoldHeading(heading: "Browse Catagories"),
            KHeight,
            Expanded(
              // child: ListView.builder(
              //   physics: const BouncingScrollPhysics(),
              //   itemCount: _foundItems.length,
              //   itemBuilder: (context, index) {
              //     final data = _foundItems[index];
              //     return SizedBox();
              //     // return CatagoriesListTile(
              //     //     title: data["title"], icon: data["icon"]);
              //   },
              // ),
              child: searchProvider.notFound != null
                  ? const Center(
                      child: Text(
                      "No course found",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ))
                  : searchProvider.searchList?.data == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 20,
                                  crossAxisCount: 2,
                                  childAspectRatio: 1 / 1.1),
                          itemCount: searchProvider.searchList!.data!.length,
                          itemBuilder: (context, index) {
                            final datas =
                                searchProvider.searchList?.data?[index];
                            return SearchCard(
                              authorName: datas?.instructor?.name.toString(),
                              courseName: datas?.courseName.toString(),
                              coursePrice: datas?.price.toString(),
                              image: datas?.thumbnail?.fullSize.toString(),
                              id: datas!.id!.toInt(),
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _tileDetailes;
    } else {
      results = _tileDetailes
          .where((item) => item["title"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundItems = results;
    });
  }
}

class SearchCard extends StatelessWidget {
  final String? courseName;
  final String? coursePrice;
  final String? authorName;
  final String? image;
  final int id;
  SearchCard(
      {required this.image,
      required this.id,
      required this.courseName,
      required this.authorName,
      required this.coursePrice});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Provider.of<CourseDetailedProvider>(context, listen: false)
            .getAll(courseID: id);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CourseDetailedPage()));
        // Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      image!,
                    ),
                    fit: BoxFit.fill),
              ),
            ),
            KHeight5,
            Text(
              courseName ?? "Course Name",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "₹${coursePrice ?? "₹3000"}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              authorName ?? "Author Name",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
