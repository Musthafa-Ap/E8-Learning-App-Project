import 'package:flutter/material.dart';
import 'package:nuox_project/pages/account/account_services/account_provider.dart';
import 'package:nuox_project/pages/cart/cart_services/cart_services.dart';
import 'package:nuox_project/pages/catagories_detailed_page.dart/services/catagories_detailed_provider.dart';
import 'package:nuox_project/pages/course_detailed_page/recomendations_services/recomendations_provider.dart';
import 'package:nuox_project/pages/course_detailed_page/services/course_detailed_provider.dart';
import 'package:nuox_project/pages/featured/services/catagories_section/catagories_provider.dart';
import 'package:nuox_project/pages/featured/services/featured_section/featured_model.dart';
import 'package:nuox_project/pages/featured/services/top_courses_section/top_courses_provider.dart';
import 'package:nuox_project/pages/featured/widgets/small_item_card.dart';
import 'package:nuox_project/pages/my_learning/services/my_learnings_provider.dart';
import 'package:nuox_project/pages/search/services/search_provider.dart';
import 'package:nuox_project/widgets/see_all_widget.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constants.dart';
import '../../../../widgets/bold_heading.dart';
import '../../services/featured_section/featured_provider.dart';
import '../top_courses_section/top_courses_section.dart';
import '../catagories_section/catagories_section.dart';
import '../../widgets/see_all_page_featured.dart';

class FeaturedSection extends StatefulWidget {
  const FeaturedSection({super.key});

  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {
  @override
  void initState() {
    Provider.of<FeaturedProvider>(context, listen: false).sample();
    Provider.of<CatagoriesProvider>(context, listen: false).getAll();
    Provider.of<TopCoursesProvider>(context, listen: false).getAll();
    Provider.of<CourseDetailedProvider>(context, listen: false)
        .getAll(courseID: 2);
    Provider.of<CatagoriesDetailedProvider>(context, listen: false)
        .getAll(catagoriesID: 1);
    Provider.of<CatagoriesDetailedProvider>(context, listen: false)
        .getAllSub(catagoriesID: 1);
    Provider.of<RecomendationsProvider>(context, listen: false).getAll();
    Provider.of<CatagoriesDetailedProvider>(context, listen: false)
        .getSubCatagoriesDetailes(subCatagoriesID: 1);
    super.initState();
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    Provider.of<TopCoursesProvider>(context, listen: false).bannerList();
    Provider.of<AccountProvider>(context, listen: false).getFAQ();
    Provider.of<CourseDetailedProvider>(context, listen: false)
        .getReview(courseID: 2);
    Provider.of<AccountProvider>(context, listen: false).getAboutApp();
    Provider.of<MyLearningsProvider>(context, listen: false).getMyLearnings();
    Provider.of<SearchProvider>(context, listen: false)
        .getSearchItems(key: "p");
    Provider.of<FeaturedProvider>(context, listen: false).sortedCourses = null;
    Provider.of<CourseDetailedProvider>(context, listen: false)
        .getRecentlyViewed();
    Provider.of<FeaturedProvider>(context, listen: false).getNotifications();
    Provider.of<FeaturedProvider>(context, listen: false).getWhishlist();
    Provider.of<AccountProvider>(context, listen: false).getOrderDetailes();
    Provider.of<AccountProvider>(context, listen: false).getDocument();
  }

  @override
  Widget build(BuildContext context) {
    final featuredProvider = Provider.of<FeaturedProvider>(context);
    Provider.of<CourseDetailedProvider>(context, listen: false)
        .getRecentlyViewed();
    final size = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kHeight15,
        const BoldHeading(
          heading: "Featured",
        ),
        featuredProvider.isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: size * .60,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final Autogenerated? data =
                              featuredProvider.auto[index];
                          return SmallItemCard(
                            id: data?.id,
                            isWishlist: data?.isWishList,
                            rating: data?.rating?.toDouble(),
                            image: data?.thumbnail?.full_size.toString(),
                            authorName: data?.instructor?.name.toString(),
                            courseName: data?.courseName.toString(),
                            coursePrice: data?.price,
                            ratingCount: data?.ratingCount,
                            isRecomended: data?.recommendedCourse,
                          );
                        },
                      ),
                      kWidth30,
                      GestureDetector(
                        child: const SeeAllWidget(),
                        onTap: () {
                          Provider.of<FeaturedProvider>(context, listen: false)
                              .sortedCourses = null;
                          featuredProvider.sample();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const SeeAllPageFeatured()));
                        },
                      ),
                      kWidth30
                    ],
                  ),
                ),
              ),
        kheight20,
        const CatagoriesSection(),
        kheight20,
        const TopCoursesSection(),
      ],
    );
  }
}
