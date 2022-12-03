// ignore_for_file: file_names, prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_app/utils/appColors.dart';
import 'package:tourist_app/views/auth/signIn.dart';

import '../../widgets/customText.dart';
import '../splash.dart';

class MyPosts extends StatefulWidget {
  final data;
  MyPosts({Key? key, this.data}) : super(key: key);

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  String image = '', name = '', post = '';
  final auth = FirebaseAuth.instance;

  void initState() {
    // TODO: implement initState
    final User? user = auth.currentUser;
    final uid = user!.uid;

    db.collection('users').doc(uid).get().then((value) {
      try {
        image = value.get('image');
        print(image);
      } catch (e) {
        print(e);
      }
      try {
        name = value.get('name');
        print(name);
      } catch (e) {
        print(e);
      }

      setState(() {});
    });

    super.initState();
  }

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  void logoutUser() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    // Get.to(() => SignIn());
    FirebaseAuth.instance.signOut();
    Get.to(() => SignIn());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.kBlackColor,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: AppColors.kWhiteColor,
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: AppColors.kBlackColor,
              ),
              onPressed: () {
                logoutUser();
              },
            ),
          ],
          elevation: 0,
        ),
        body: Container(
          height: Get.height,
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.02,
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: db
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (_, snapshot) {
                  return Container(
                    child: Column(
                      children: [
                        Center(
                          child: CircleAvatar(
                            backgroundImage:
                                image.isNotEmpty ? NetworkImage(image) : null,
                            radius: 50,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Center(child: customText(name)),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: db
                      .collection('posts')
                      .where('user_id', isEqualTo: uid)
                      .snapshots(),
                  builder: (_, snapshot) {
                    return snapshot.hasData
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            height: Get.height,
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  DocumentSnapshot ds =
                                      snapshot.data!.docs[index];
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(ds['image'])),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  );
                                }),
                          )
                        : Container(
                            child: customText('data not Found'),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
