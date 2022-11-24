import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nuox_project/constants/constants.dart';
import 'package:nuox_project/pages/course_detailed_page/services/course_detailed_provider.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatelessWidget {
  bool isPurchased;
  int id;
  ReviewPage({super.key, required this.id, required this.isPurchased});
  final ValueNotifier<int> _ratingNotifier = ValueNotifier(1);
  final TextEditingController _reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final courseDetailedProvider = Provider.of<CourseDetailedProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: const Text("Add Review"),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15),
        children: [
          isPurchased == true
              ? Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _ratingNotifier,
                      builder: (context, value, child) {
                        return Center(
                          child: Column(
                            children: [
                              RatingBar.builder(
                                  updateOnDrag: true,
                                  unratedColor: Colors.grey,
                                  initialRating: 1,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                  onRatingUpdate: (rating) {
                                    _ratingNotifier.value = rating.toInt();
                                  }),
                              Text(
                                _ratingNotifier.value.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              kheight20,
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black,
                                    border: Border.all(color: Colors.white)),
                                child: TextField(
                                  controller: _reviewController,
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 6,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Any suggestions...",
                                      hintStyle:
                                          TextStyle(color: Colors.white)),
                                ),
                              ),
                              kheight20,
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                )
              : const SizedBox(),
          isPurchased == true
              ? SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple)),
                    onPressed: () async {
                      var rating = _ratingNotifier.value;
                      var review = _reviewController.text;
                      if (review.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Please type a review',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )));
                        // courseDetailedProvider.addRatingWithoutReview(
                        //     context: context, rating: rating, id: id);
                      } else {
                        await courseDetailedProvider.addRatingWithReview(
                            rating: rating,
                            id: id,
                            review: review,
                            context: context);
                        _reviewController.text = "";
                        courseDetailedProvider.getReview(
                            courseID: courseDetailedProvider
                                .courseDetailes!.data!.first.id);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Submit"),
                  ),
                )
              : const SizedBox(),
          // ValueListenableBuilder(
          //   valueListenable: _ratingNotifier,
          //   builder: (context, value, child) {
          //     return Center(
          //       child: Column(
          //         children: [
          //           RatingBar.builder(
          //               updateOnDrag: true,
          //               unratedColor: Colors.grey,
          //               initialRating: 1,
          //               minRating: 1,
          //               direction: Axis.horizontal,
          //               itemCount: 5,
          //               itemPadding:
          //                   const EdgeInsets.symmetric(horizontal: 4.0),
          //               itemBuilder: (context, _) => const Icon(
          //                     Icons.star,
          //                     color: Colors.amber,
          //                   ),
          //               onRatingUpdate: (rating) {
          //                 _ratingNotifier.value = rating.toInt();
          //               }),
          //           Text(
          //             _ratingNotifier.value.toString(),
          //             style: const TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 20,
          //                 fontWeight: FontWeight.bold),
          //           )
          //         ],
          //       ),
          //     );
          //   },
          // ),
          // kheight20,
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       color: Colors.black,
          //       border: Border.all(color: Colors.white)),
          //   child: TextField(
          //     controller: _reviewController,
          //     style: const TextStyle(color: Colors.white),
          //     maxLines: 6,
          //     decoration: const InputDecoration(
          //         border: InputBorder.none,
          //         hintText: "Any suggestions...",
          //         hintStyle: TextStyle(color: Colors.white)),
          //   ),
          // ),

          kheight20,
          kheight20,
          courseDetailedProvider.getReviewList == null ||
                  courseDetailedProvider.getReviewList!.data!.isEmpty ||
                  courseDetailedProvider.noReview == true
              ? const Center(
                  child: Text(
                    "No review",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              : courseDetailedProvider.isReviewLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(5),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          courseDetailedProvider.getReviewList!.data!.length,
                      itemBuilder: (context, index) {
                        final datas =
                            courseDetailedProvider.getReviewList!.data![index];
                        return ReviewCard(
                          rating: datas.rating.toString(),
                          review: datas.review.toString(),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  String rating;
  String review;
  ReviewCard({super.key, required this.rating, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        Container(
          height: 22,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.green,
          ),
          child: Row(children: [
            const Spacer(),
            Text(
              rating,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Icon(
              Icons.star,
              size: 14,
              color: Colors.white,
            ),
            const Spacer(),
          ]),
        ),
        kWidth10,
        Expanded(
          child: Text(
            review,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
        )
      ]),
    );
  }
}
