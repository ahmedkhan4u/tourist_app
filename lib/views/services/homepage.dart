// ignore_for_file: avoid_unnecessary_containers, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_import, avoid_web_libraries_in_flutter, unused_local_variable, curly_braces_in_flow_control_structures, prefer_final_fields, unused_field, unused_label, empty_statements, dead_code, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:share/share.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:tourist_app/views/services/bookingUsers.dart';
import 'package:tourist_app/views/services/postDetails.dart';
import 'package:tourist_app/views/services/remove.dart';
import '../../main.dart';
import '../../models/favoritesModel.dart';
import '../../utils/appColors.dart';
import '../../widgets/customText.dart';
import '../../widgets/customTextField.dart';
import 'block.dart';

class HomePage extends StatefulWidget {
  final data;
  HomePage({Key? key, this.data}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController titleController = TextEditingController();
  TextEditingController msgController = TextEditingController();

  Box<FavoritesModel>? favoritesBox;

  bool isList = true;

  bool _isFavorite = false;

  bool isReported = false;
  String postId = '', userId = '', postImage = '';
  @override
  void initState() {
    // TODO: implement initState
    favoritesBox = Hive.box<FavoritesModel>(FAVORITE_BOX);

    super.initState();
    // initDynamicLink();
    FirebaseFirestore.instance.collection('users').doc(uid).get().then(
      (value) {
        bool? isRemove;
        bool? isBlock;

        try {
          isRemove = value.get('isRemoved');
        } catch (e) {
          print(e);
        }
        try {
          isBlock = value.get('isBlocked');
        } catch (e) {
          print(e);
        }

        if (isRemove == true) {
          Get.to(
            () => RemoveUser(),
          );
        } else if (isBlock == true) {
          Get.to(
            () => BlockUser(),
          );
        }
      },
    );
    FirebaseFirestore.instance.collection('posts').doc().get().then((value) {
      try {
        postId = value.get('post_id');
      } catch (e) {
        print(e);
      }

      try {
        postImage = value.get('image');
      } catch (e) {
        print(e);
      }
      try {
        userId = value.get('user_id');
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.kBlackColor,
            ),
          ),
          backgroundColor: AppColors.kWhiteColor,
          title: customText(
            'Home Page',
            textColor: AppColors.kBlackColor,
          ),
          actions: [
            Container(
              height: Get.height * 0.1,
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      isList = true;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.menu,
                      color:
                          isList ? AppColors.kBlueColor : AppColors.kBlackColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      isList = false;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.grid_4x4_outlined,
                      color:
                          isList ? AppColors.kBlackColor : AppColors.kBlueColor,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.01,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: isList
            ? FirestorePagination(
                //item builder type is compulsory.
                itemBuilder: (context, documentSnapshots, index) {
                  final data = documentSnapshots.data() as Map?;
                  String postUserId = data!['user_id'];
                  FavoritesModel favorites = FavoritesModel(
                    image: data['image'],
                    likes: data['likes'],
                    uid: documentSnapshots.id,
                  );
                  return InkWell(
                    onTap: () {
                      Get.to(() => DetailScreen(data));
                    },
                    child: Container(
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
                              backgroundImage:
                                  NetworkImage(data['user_image_url']),
                            ),
                            title: customText(
                              // 'User Name',
                              data['user_name'],
                              fontSize: 15.0,
                            ),
                            subtitle: customText(data['date']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                widget.data["Role"] != null &&
                                        widget.data["Role"] == "Vendor"
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: AppColors.kBlackColor,
                                        ),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('posts')
                                              .doc(documentSnapshots.id)
                                              .delete()
                                              .then((value) {
                                            Get.snackbar(
                                              'Delete msg',
                                              'Post Deleted successfully',
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                            );
                                          });

                                          // Get.defaultDialog(
                                          //   title: 'Report User',
                                          //   content: Container(
                                          //     height: Get.height * 0.25,
                                          //     width: Get.width,
                                          //     child: Column(
                                          //       mainAxisAlignment:
                                          //           MainAxisAlignment.spaceBetween,
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.end,
                                          //       children: [
                                          //         customTextField(
                                          //           text: 'Title',
                                          //           controller: titleController,
                                          //         ),
                                          //         customTextField(
                                          //             text: 'Message',
                                          //             controller: msgController),
                                          //         ElevatedButton(
                                          //           onPressed: () {
                                          //             try {
                                          //               isReported
                                          //                   ? CircularProgressIndicator()
                                          //                   : db
                                          //                       .collection('reports')
                                          //                       .add({
                                          //                       'title':
                                          //                           titleController.text,
                                          //                       'Message':
                                          //                           msgController.text,
                                          //                       'user_id': FirebaseAuth
                                          //                           .instance
                                          //                           .currentUser!
                                          //                           .uid,
                                          //                     }).then((value) {
                                          //                       Get.snackbar('Report',
                                          //                           'You report this user');
                                          //                       Navigator.pop(context);
                                          //                       return value;
                                          //                     });
                                          //             } catch (e) {
                                          //               Get.snackbar(
                                          //                 'Error',
                                          //                 e.toString(),
                                          //               );
                                          //             }
                                          //           },
                                          //           child: customText('Report'),
                                          //         )
                                          //       ],
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                      )
                                    : Container(),
                                widget.data["Role"] != null &&
                                        widget.data["Role"] == "Vendor"
                                    ? Container()
                                    : TextButton(
                                        onPressed: () async {
                                          if (data["bookings"].contains(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)) {
                                            Get.snackbar(
                                                "Info", "Already booked");
                                            return;
                                          }
                                          await FirebaseFirestore.instance
                                              .collection("posts")
                                              .doc(data['post_id'])
                                              .update({
                                            "bookings": FieldValue.arrayUnion([
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                            ])
                                          });

                                          final bookingId =
                                              await FirebaseFirestore.instance
                                                  .collection("bookings")
                                                  .doc()
                                                  .id;

                                          await FirebaseFirestore.instance
                                              .collection("bookings")
                                              .doc(bookingId)
                                              .set({
                                            "booker_name": widget.data["name"],
                                            'booker_image':
                                                widget.data['image'],
                                            "booker_id": FirebaseAuth
                                                .instance.currentUser!.uid,
                                            "post_id": data["post_id"],
                                            "post_title": data["title"],
                                            "category": data["Category"],
                                            "post_image": data["image"],
                                            "post_user_id": data["user_id"],
                                            "post_user_image":
                                                data["user_image_url"],
                                            'post_user_name': data['user_name'],
                                            'date': data['date'],
                                            'Booking_date':
                                                '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                            'likes':
                                                data['likes'].length.toString(),
                                            "booking_id": bookingId
                                          });
                                        },
                                        child: (data["bookings"].contains(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid))
                                            ? customText('Booked')
                                            : customText('Book')),
                              ],
                            ),
                          ),
                          Container(
                            width: Get.width,
                            height: Get.height * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(data['image']),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      icon: (data['likes'].contains(FirebaseAuth
                                              .instance.currentUser!.uid))
                                          ? Icon(
                                              Icons.thumb_up,
                                              color: AppColors.kBlueColor,
                                            )
                                          : Icon(
                                              Icons.thumb_up_outlined,
                                            ),
                                      onPressed: () async {
                                        (data['likes'].contains(FirebaseAuth
                                                .instance.currentUser!.uid))
                                            ? {
                                                await FirebaseFirestore.instance
                                                    .collection('posts')
                                                    .doc(documentSnapshots.id)
                                                    .update(
                                                  {
                                                    'likes':
                                                        FieldValue.arrayRemove(
                                                      [
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                      ],
                                                    ),
                                                  },
                                                ),
                                              }
                                            : {
                                                await FirebaseFirestore.instance
                                                    .collection('posts')
                                                    .doc(documentSnapshots.id)
                                                    .update(
                                                  {
                                                    'likes':
                                                        FieldValue.arrayUnion(
                                                      [
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                      ],
                                                    ),
                                                  },
                                                ),
                                              };
                                      }),
                                  customText(data['likes'].length.toString()),
                                ],
                              ),
                              IconButton(
                                onPressed: () async {
                                  _settingModalBottomSheet(context, data["post_id"]);
                                },
                                icon: Icon(
                                  Icons.comment_outlined,
                                  color: AppColors.kBlackColor,
                                  size: 20.0,
                                ),
                              ),
                              widget.data["Role"] != null &&
                                      widget.data["Role"] == "Vendor"
                                  ? TextButton(
                                      onPressed: () async {
                                        Get.to(() => BookingUserScreen());
                                        // if (data["bookings"].contains(
                                        //     FirebaseAuth
                                        //         .instance.currentUser!.uid)) {
                                        //   Get.snackbar(
                                        //       "Info", "Already booked");
                                        //   return;
                                        // }
                                        // await FirebaseFirestore.instance
                                        //     .collection("posts")
                                        //     .doc(data['post_id'])
                                        //     .update({
                                        //   "bookings": FieldValue.arrayUnion([
                                        //     FirebaseAuth
                                        //         .instance.currentUser!.uid
                                        //   ])
                                        // });

                                        // final bookingId =
                                        //     await FirebaseFirestore.instance
                                        //         .collection("bookings")
                                        //         .doc()
                                        //         .id;

                                        // await FirebaseFirestore.instance
                                        //     .collection("bookings")
                                        //     .doc(bookingId)
                                        //     .set({
                                        //   "booker_name": widget.data["name"],
                                        //   'booker_image':
                                        //       widget.data['image'],
                                        //   "booker_id": FirebaseAuth
                                        //       .instance.currentUser!.uid,
                                        //   "post_id": data["post_id"],
                                        //   "post_title": data["title"],
                                        //   "category": data["Category"],
                                        //   "post_image": data["image"],
                                        //   "post_user_id": data["user_id"],
                                        //   "post_user_image":
                                        //       data["user_image_url"],
                                        //   'post_user_name': data['user_name'],
                                        //   'date': data['date'],
                                        //   'likes':
                                        //       data['likes'].length.toString(),
                                        //   "booking_id": bookingId
                                        // });
                                      },
                                      child: customText('Bookings'))
                                  : IconButton(
                                      onPressed: () {
                                        if (favoritesBox!
                                            .containsKey(favorites.uid)) {
                                          favoritesBox!.delete(favorites.uid);
                                          Get.snackbar(
                                            'Success',
                                            'Post removed from Favorites SuccessFully',
                                            backgroundColor:
                                                AppColors.borderColor,
                                          );
                                        } else {
                                          favoritesBox!
                                              .put(favorites.uid, favorites);
                                          Get.snackbar(
                                            'Success',
                                            'Post added to Favorites SuccessFully',
                                            backgroundColor:
                                                AppColors.borderColor,
                                          );
                                        }
                                        // favoritesBox!.containsKey(favorites.uid)
                                        //     ? favoritesBox!.delete(favorites.uid)
                                        //     : favoritesBox!
                                        //         .put(favorites.uid, favorites);
                                        setState(() {});
                                      },
                                      icon: favoritesBox!
                                              .containsKey(favorites.uid)
                                          ? Icon(
                                              Icons.favorite,
                                              color: AppColors.kRedColor,
                                            )
                                          : Icon(
                                              Icons.favorite_border,
                                            ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                limit: 5,
                // orderBy is compulsory to enable pagination
                query: db.collection('posts').limit(5),

                //Change types accordingly
                viewType: ViewType.list,
                // to fetch real-time data
                isLive: true,
              )
            : FirestorePagination(
                //item builder type is compulsory.
                itemBuilder: (context, documentSnapshots, index) {
                  final data = documentSnapshots.data() as Map?;
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 5.0,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.kWhiteColor,
                        border: Border.all(
                          color: AppColors.kGrayColor,
                        ),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(data!['image'])),
                        borderRadius: BorderRadius.circular(15)),
                  );
                },
                limit: 5,
                // orderBy is compulsory to enable pagination
                query: FirebaseFirestore.instance.collection('posts').limit(5),
                //Change types accordingly
                viewType: ViewType.grid,
                // to fetch real-time data
                isLive: true,
              ),
      ),
    );
  }


void _settingModalBottomSheet(context, postId){
  TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,
      builder: (BuildContext bc){
          return Container(
            padding: EdgeInsets.all(16),
            height: Get.height * 0.8,
            child: Wrap(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                                      decoration: InputDecoration(
                labelText: "Type here...",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueGrey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueGrey,
                    width: 2.0,
                  ),
                ),
)
                                    ),
                    ),
                    
                TextButton(onPressed: () async {

                  final data = {
                    "user_id": widget.data["user_id"],
                    "role": widget.data["Role"],
                    "comment": controller.text,
                    "name": widget.data["name"],
                    "image": widget.data["image"],   
                    "timestamp": DateTime.now().millisecondsSinceEpoch,              
                  };

                  final docId = await FirebaseFirestore.instance
                  .collection("comments").doc().id;
                  data["comment_id"] = docId;
                  await FirebaseFirestore.instance.collection("posts")
                  .doc(postId).collection("comments").doc(docId).set(data);
                  

                  controller.text = "";
                  setState(() {
                    
                  });

                }, child: Text("Post"))
                  ],
                ),

                SizedBox(height: 16,),

                Container(height: 1, color: Colors.black12,
              
                ),
                                SizedBox(height: 16,),

                Container(
                  height: Get.height*0.65,
                  width: Get.width * 1,

                  child: FirestorePagination(
                  
                  //item builder type is compulsory.
                  itemBuilder: (context, documentSnapshots, index) {
                    final data = documentSnapshots.data() as Map?;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                          
                                            borderRadius: BorderRadius.circular(100),
                                        
                            child: Image.network(
                              data!["image"],
                              fit: BoxFit.fill,
                        
                              
                              )),
                        ),
                        SizedBox(width: 8,),
                        Expanded(child: Text(data!["name"])),
                        Text(DateTime.fromMillisecondsSinceEpoch(data["timestamp"])
                        .toUtc().toIso8601String().substring(0, 10))
                          ],
                        ),

                        SizedBox(height: 8,),
                        Container(
                          margin: EdgeInsets.only(left: 48),
                          child: Text(data["comment"]),
                        ),
                        
                        Container(height: 1, color: Colors.grey, margin: EdgeInsets.symmetric(vertical: 8),)
                      ],
                    );
                  },
                  limit: 5,
                  // orderBy is compulsory to enable pagination
                  query: FirebaseFirestore.instance.collection('posts')
                  .doc(postId).collection("comments")
                  .orderBy("timestamp", descending: true)
                  .limit(5),
                  //Change types accordingly
                  viewType: ViewType.list,
                  // to fetch real-time data
                  isLive: true,
                              ),
                ),

                
              ],
            ),

            
          );
      }
    );
}

}
