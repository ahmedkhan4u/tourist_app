// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/appColors.dart';
import '../../widgets/customText.dart';

class DetailScreen extends StatefulWidget {
  final docId;
  DetailScreen(this.docId);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final auth = FirebaseAuth.instance;
  @override
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.docId['image']),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: Get.height * 0.3,
                width: Get.width,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kBlackColor.withOpacity(0.8),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        10.0,
                      ),
                      topRight: Radius.circular(
                        10.0,
                      )),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      "Title:\t${widget.docId['title']}",
                      textColor: AppColors.kWhiteColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.share,
                            color: AppColors.kWhiteColor,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.01,
                        ),
                        Icon(
                          Icons.favorite,
                          color: AppColors.kRedColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
