// ignore_for_file: avoid_unnecessary_containers, file_names, prefer_const_constructors, sized_box_for_whitespace, avoid_print, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';

import '../../utils/appColors.dart';
import '../../widgets/customBtn.dart';
import '../../widgets/customText.dart';
import '../../widgets/customTextField.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _CreatePostState extends State<CreatePost> {
  final db = FirebaseFirestore.instance;
  File? imageFile;
  CroppedFile? _croppedFile;
  TextEditingController titleController = TextEditingController();
  String? imageUrl;
  Map? likes;
  bool isPosted = false;

  late AppState state;

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }

    // if (pickedFile != null) {
    //   CroppedFile? cropped = (await ImageCropper().cropImage(
    //     sourcePath: pickedFile.path,
    //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    //     compressQuality: 100,
    //     maxWidth: 700,
    //     maxHeight: 700,
    //     compressFormat: ImageCompressFormat.jpg,
    //     // androidUiSettings: AndroidUiSettings(
    //     //   backgroundColor: AppColors.kWhiteColor,
    //     // ),
    //   ));
    //   if (_croppedFile != null) {
    //     setState(() {
    //       imageFile = File(cropped!.path);
    //     });
    //   }
    // }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    // if (pickedFile != null) {
    //   CroppedFile? cropped = (await ImageCropper().cropImage(
    //     sourcePath: pickedFile.path,
    //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    //     compressQuality: 100,
    //     maxWidth: 700,
    //     maxHeight: 700,
    //     compressFormat: ImageCompressFormat.jpg,
    //     // androidUiSettings: AndroidUiSettings(
    //     //   backgroundColor: AppColors.kWhiteColor,
    //     // ),
    //   ));
    //   if (_croppedFile != null) {
    //     setState(() {
    //       imageFile = File(cropped!.path);
    //     });
    //   }
    // }
  }

  String image = '', name = '', country = '';
  final auth = FirebaseAuth.instance;
  String? dropDownValue;

  @override
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

      try {
        country = value.get('country');
        print(country);
      } catch (e) {
        print(e);
      }

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: Column(
              children: [
                (imageFile == null)
                    ? InkWell(
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              height: Get.height * 0.2,
                              color: AppColors.kWhiteColor,
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      _getFromGallery();
                                      Navigator.pop(context);
                                    },
                                    leading: Icon(
                                      Icons.add_a_photo,
                                      color: AppColors.kBlackColor,
                                    ),
                                    title: customText(
                                      'Gallery',
                                      textColor: AppColors.kBlackColor,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {
                                      _getFromCamera();
                                      Navigator.pop(context);
                                    },
                                    leading: Icon(
                                      Icons.camera,
                                      color: AppColors.kBlackColor,
                                    ),
                                    title: customText(
                                      'Camera',
                                      textColor: AppColors.kBlackColor,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                            height: Get.height * 0.45,
                            width: Get.width,
                            color: AppColors.borderColor,
                            child: Center(
                                child: Icon(
                              Icons.add,
                              size: 50,
                            ))),
                      )
                    : Container(
                        height: Get.height * 0.4,
                        width: Get.width - 2,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.borderColor,
                          ),
                          image: DecorationImage(
                            image: FileImage(imageFile!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                      ),
                SizedBox(height: Get.height * 0.04),
                customTextField(
                  text: 'Enter title',
                  controller: titleController,
                ),
                SizedBox(height: Get.height * 0.05),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButton<String>(
                    hint: customText('Select Category:'),
                    isExpanded: true,
                    value: dropDownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 36,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropDownValue = newValue!;
                      });
                    },
                    items: <String>['Services', 'Car', 'Room', 'Hotel']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Center(
                  child: isPosted
                      ? CircularProgressIndicator()
                      : customButton(
                          'Upload',
                          onPress: () async {
                            var likes = [];

                            try {
                              setState(() {
                                isPosted = true;
                              });
                              var storageImage = FirebaseStorage.instance
                                  .ref()
                                  .child(imageFile!.path);
                              var task = storageImage.putFile(imageFile!);
                              imageUrl =
                                  await (await task.whenComplete(() => null))
                                      .ref
                                      .getDownloadURL();
                              print(imageUrl);

                              Get.snackbar('storage sms',
                                  'Upload image successfully to firebase storage');
                              db.collection('posts').add({
                                'image': imageUrl,
                                'title': titleController.text,
                                'user_id':
                                    FirebaseAuth.instance.currentUser!.uid,
                                'date':
                                    '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                // 'isApproved': false,
                                'user_name': name,
                                'user_image_url': image,
                                'country': country,
                                'Category': dropDownValue,
                                'likes': likes,
                              }).then((value) {
                                setState(() {
                                  isPosted = false;
                                });
                                print(imageUrl);
                                Get.snackbar(
                                    'Success', 'Post Created SuccessFully');
                                return value;
                              });
                            } catch (e) {
                              setState(() {
                                isPosted = false;
                              });
                              Get.snackbar('Error', e.toString());
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
