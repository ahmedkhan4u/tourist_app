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
import 'package:tourist_app/views/services/postDetails.dart';
import 'package:tourist_app/views/services/remove.dart';
import '../../main.dart';
import '../../models/favoritesModel.dart';
import '../../utils/appColors.dart';
import '../../widgets/customText.dart';
import '../../widgets/customTextField.dart';
import 'block.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
                                IconButton(
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
                                        snackPosition: SnackPosition.BOTTOM,
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
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: customText('Book'),
                                ),
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
                                onPressed: () async {},
                                icon: Icon(
                                  Icons.comment_outlined,
                                  color: AppColors.kBlackColor,
                                  size: 20.0,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (favoritesBox!
                                      .containsKey(favorites.uid)) {
                                    favoritesBox!.delete(favorites.uid);
                                    Get.snackbar(
                                      'Success',
                                      'Post removed from Favorites SuccessFully',
                                      backgroundColor: AppColors.borderColor,
                                    );
                                  } else {
                                    favoritesBox!.put(favorites.uid, favorites);
                                    Get.snackbar(
                                      'Success',
                                      'Post added to Favorites SuccessFully',
                                      backgroundColor: AppColors.borderColor,
                                    );
                                  }
                                  // favoritesBox!.containsKey(favorites.uid)
                                  //     ? favoritesBox!.delete(favorites.uid)
                                  //     : favoritesBox!
                                  //         .put(favorites.uid, favorites);
                                  setState(() {});
                                },
                                icon: favoritesBox!.containsKey(favorites.uid)
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
}