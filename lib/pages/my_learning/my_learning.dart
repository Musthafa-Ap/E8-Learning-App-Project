import 'package:flutter/material.dart';
import 'package:nuox_project/pages/my_learning/services/my_learnings_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/my_learning_card.dart';

class MyLearning extends StatelessWidget {
  const MyLearning({super.key});

  @override
  Widget build(BuildContext context) {
    final myLearningsProvider = Provider.of<MyLearningsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("My learning"),
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: const Icon(
        //         Icons.search,
        //         size: 28,
        //       )),
        //   IconButton(onPressed: () {}, icon: const Icon(Icons.sort, size: 28))
        // ],
      ),
      body: myLearningsProvider.myLearningsList?.data == null
          ? const Center(
              child: Text(
                "No courses",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              physics: const BouncingScrollPhysics(),
              itemCount: myLearningsProvider.myLearningsList!.data!.length,
              itemBuilder: (context, index) {
                final datas = myLearningsProvider.myLearningsList?.data?[index];
                return MyLearningCard(
                  author: datas?.instructorName.toString(),
                  courseName: datas?.courseName.toString(),
                  id: datas?.courseId?.toInt(),
                  img: datas?.courseThumbnail.toString(),
                  variant: datas?.variant.toString(),
                );
              },
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                );
              },
            ),
    );
  }
}
