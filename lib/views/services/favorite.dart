// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../main.dart';
import '../../models/favoritesModel.dart';
import '../../utils/appColors.dart';

class Favorites extends StatefulWidget {
  final data;
  Favorites({Key? key, this.data}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Box<FavoritesModel>? favoritesBox;
  @override
  void initState() {
    // TODO: implement initState
    favoritesBox = Hive.box<FavoritesModel>(FAVORITE_BOX);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: favoritesBox!.listenable(),
        builder: (context, Box<FavoritesModel> favorites, _) {
          List<String> keys = favorites.keys.toList().cast<String>();
          return ListView.builder(
              shrinkWrap: true,
              itemCount: keys.length,
              itemBuilder: (_, index) {
                final String key = keys[index];
                final FavoritesModel? favorite = favorites.get(key);

                return Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
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
                      Container(
                        width: Get.width,
                        height: Get.height * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(favorite!.image!),
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
                                icon: Icon(
                                  Icons.thumb_up,
                                  size: 20.0,
                                  color: AppColors.kBlueColor,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              favoritesBox!.deleteAt(index);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: AppColors.kRedColor,
                              size: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
