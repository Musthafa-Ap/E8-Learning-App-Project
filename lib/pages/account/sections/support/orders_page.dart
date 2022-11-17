import 'package:flutter/material.dart';
import 'package:nuox_project/constants/constants.dart';
import 'package:nuox_project/pages/account/account_services/account_provider.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    final size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: const Text("Order detailes"),
        ),
        body: accountProvider.noOrders == true
            ? const Center(
                child: Text(
                  "No orders",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(15),
                itemCount: accountProvider.orderDetailes?.data?.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final datas = accountProvider.orderDetailes?.data?[index];
                  return ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          datas?.createdAt ?? "11/12/22",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Order ID : ${datas?.orderId ?? "SD564453DFA533"}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: accountProvider.orderDetailes?.data?[index]
                            .orderedCourseOrder?.length,
                        itemBuilder: (context, indexes) {
                          final data = accountProvider.orderDetailes
                              ?.data?[index].orderedCourseOrder?[indexes];
                          return Container(
                            margin: const EdgeInsets.all(10),
                            height: size * .25,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                // color: Colors.amber,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(data
                                                  ?.courseThumbnail
                                                  .toString() ??
                                              "https://www.aakash.ac.in/blog/wp-content/uploads/2022/07/Blog-Image-612x536.jpg"))),
                                  width: size * .3,
                                  height: size * .25,
                                ),
                                kWidth10,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data?.courseName ?? "Course Name",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      data?.sectionId ?? "beginner",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    // Text(
                                    //   "Order ID : ${data.order}",
                                    //   style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontSize: 16,
                                    //       overflow: TextOverflow.ellipsis),
                                    // ),

                                    // Text(
                                    //   "Payment mode : ${data.}",
                                    //   style: const TextStyle(
                                    //       color: Colors.white, fontSize: 16),
                                    // ),
                                    Text(
                                      data?.instructorName ?? "Fahad",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Text(
                                      "Price : ₹${data?.itemTotal ?? "5433"}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    // Text(
                                    //   "13/11/22",
                                    //   style: TextStyle(
                                    //       color: Colors.white, fontSize: 16),
                                    // ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          "Total amount = ₹${datas?.grandTotal ?? "₹21000"}",
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  );
                },
              ));
  }
}
