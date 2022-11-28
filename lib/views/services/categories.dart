// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tourist_app/categories/carCategory.dart';
import 'package:tourist_app/categories/hotelCategory.dart';
import 'package:tourist_app/categories/roomCategory.dart';
import 'package:tourist_app/categories/servicesCategory.dart';

import '../../models/categoriesModel.dart';
import '../../utils/appColors.dart';
import '../../widgets/customText.dart';

class CategoryClass extends StatefulWidget {
  const CategoryClass({Key? key}) : super(key: key);

  @override
  _CategoryClassState createState() => _CategoryClassState();
}

class _CategoryClassState extends State<CategoryClass> {
  List<CategoriesModel> catList = [
    CategoriesModel(text: 'Services', image: 'images/service.jpg'),
    CategoriesModel(text: 'Cars', image: 'images/car.jpg'),
    CategoriesModel(text: 'Rooms', image: 'images/room.jpg'),
    CategoriesModel(text: 'Hotels', image: 'images/hotel.jpg'),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: buildGridView(),
        ),
      ),
    );
  }

  buildGridView() {
    return GridView.builder(
      itemCount: catList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (_, index) {
        return Container(
          padding: EdgeInsets.all(
            15.0,
          ),
          child: InkWell(
            onTap: () {
              if (index == 0) {
                Get.to(() => ServicesScreen());
              }
              if (index == 1) {
                Get.to(() => CarScreen());
              }
              if (index == 2) {
                Get.to(() => RoomScreen());
              }
              if (index == 3) {
                Get.to(() => HotelScreen());
              }
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(catList[index].image.toString()),
                  fit: BoxFit.cover,
                ),
                color: AppColors.kGrayColor,
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),
              child: Center(
                child: customText(
                  catList[index].text!,
                  textColor: AppColors.kBlackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
