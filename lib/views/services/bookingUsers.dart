import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';
import '../../widgets/customText.dart';

class BookingUserScreen extends StatefulWidget {
  const BookingUserScreen({super.key});

  @override
  State<BookingUserScreen> createState() => _BookingUserScreenState();
}

class _BookingUserScreenState extends State<BookingUserScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kWhiteColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.kBlackColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: customText('Booked By', textColor: AppColors.kBlackColor),
          centerTitle: true,
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: FirestorePagination(
            //item builder type is compulsory.
            itemBuilder: (context, documentSnapshots, index) {
              final data = documentSnapshots.data() as Map?;
              String postUserId = data!['post_user_id'];
              return Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54.withOpacity(0.1),
                        blurRadius: 15.0,
                        offset: Offset(0.0, 0.75))
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data['booker_image']),
                      ),
                      title: customText(
                        // 'User Name',
                        data['booker_name'],
                        fontSize: 15.0,
                      ),
                      subtitle: customText(data['Booking_date'].toString()),
                      // trailing: IconButton(
                      //   icon: Icon(
                      //     Icons.more_vert,
                      //     color: AppColors.kBlackColor,
                      //   ),
                      //   onPressed: () {
                      //     // Get.defaultDialog(
                      //     //   title: 'Report User',
                      //     //   content: Container(
                      //     //     height: Get.height * 0.25,
                      //     //     width: Get.width,
                      //     //     child: Column(
                      //     //       mainAxisAlignment:
                      //     //           MainAxisAlignment.spaceBetween,
                      //     //       crossAxisAlignment: CrossAxisAlignment.end,
                      //     //       children: [
                      //     //         customTextField(
                      //     //           text: 'Title',
                      //     //           controller: titleController,
                      //     //         ),
                      //     //         customTextField(
                      //     //             text: 'Message',
                      //     //             controller: msgController),
                      //     //         RaisedButton(
                      //     //           onPressed: () {
                      //     //             try {
                      //     //               db.collection('reports').add({
                      //     //                 'title': titleController.text,
                      //     //                 'Message': msgController.text,
                      //     //                 'user_id': FirebaseAuth
                      //     //                     .instance.currentUser!.uid,
                      //     //               }).then((value) {
                      //     //                 Get.snackbar('Report',
                      //     //                     'You report this user');
                      //     //                 return value;
                      //     //               });
                      //     //             } catch (e) {
                      //     //               Get.snackbar(
                      //     //                 'Error',
                      //     //                 e.toString(),
                      //     //               );
                      //     //             }
                      //     //           },
                      //     //           child: customText('Report'),
                      //     //         )
                      //     //       ],
                      //     //     ),
                      //     //   ),
                      //     // );
                      //   },
                      // ),
                    ),
                    // Container(
                    //   width: Get.width,
                    //   height: Get.height * 0.3,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(
                    //       10.0,
                    //     ),
                    //     image: DecorationImage(
                    //       image: NetworkImage(data['post_image']),
                    //       fit: BoxFit.fill,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: Get.height * 0.02,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         IconButton(
                    //           icon: Icon(
                    //             Icons.thumb_up,
                    //             color: AppColors.kBlueColor,
                    //             size: 20.0,
                    //           ),
                    //           onPressed: () {},
                    //         ),
                    //         customText(data['likes']),
                    //       ],
                    //     ),
                    //     IconButton(
                    //       onPressed: () async {
                    //         Share.share(data['post_image']);
                    //       },
                    //       icon: Icon(
                    //         Icons.share,
                    //         color: AppColors.kBlackColor,
                    //         size: 20.0,
                    //       ),
                    //     ),
                    //     IconButton(
                    //       onPressed: () {
                    //         // FavoritesModel favorites = FavoritesModel(
                    //         //   image: ds['image'],
                    //         //   likes: ds['likes'],
                    //         // );
                    //         // favoritesBox!.add(favorites);
                    //         // Get.snackbar('Success', 'Added to Favorites');
                    //       },
                    //       icon: Icon(
                    //         Icons.favorite_border,
                    //         color: AppColors.kBlackColor,
                    //         size: 20.0,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              );
            },
            limit: 5,
            // orderBy is compulsory to enable pagination
            query: FirebaseFirestore.instance
                .collection('bookings')
                .where('post_user_id',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .limit(5),
            //Change types accordingly
            viewType: ViewType.list,
            // to fetch real-time data
            isLive: true,
          ),
        ),
      ),
    );
  }
}
