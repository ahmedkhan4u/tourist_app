// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'favoritesModel.g.dart';

@HiveType(typeId: 0)
class FavoritesModel {
  @HiveField(0)
  String? image;
  @HiveField(1)
  var likes;
  @HiveField(2)
  String? uid;
  @HiveField(3)
  bool? isFavorite;
  FavoritesModel({
    this.image,
    this.likes,
    this.uid,
    this.isFavorite = false,
  });
}
