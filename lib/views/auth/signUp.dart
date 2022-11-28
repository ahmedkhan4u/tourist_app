// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, dead_code

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourist_app/views/auth/signIn.dart';

import '../../utils/appColors.dart';
import '../../widgets/customBtn.dart';
import '../../widgets/customText.dart';
import '../../widgets/customTextField.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool isUserLogin = false;
  File? imageFile;
  String? imageUrl;

  String? dropDownValue;

  var items = [
    'Vendor',
    'Tourist',
  ];

  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  var selectedCountry;

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
            height: Get.height,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      Get.bottomSheet(Container(
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
                      ));
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          imageFile != null ? FileImage(imageFile!) : null,
                    ),
                  ),
                ),
                customTextField(
                  text: 'Enter your Name',
                  controller: nameController,
                  inputType: TextInputType.name,
                ),
                customTextField(
                  text: 'Enter your Email',
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                ),
                DropdownButton(
                  value: dropDownValue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropDownValue = newValue!;
                    });
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.kWhiteColor,
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: CountryCodePicker(
                    initialSelection: 'Pk',
                    showOnlyCountryWhenClosed: true,
                    showDropDownButton: true,
                    showCountryOnly: true,
                    onChanged: (val) {
                      selectedCountry = val.name;
                      print(selectedCountry);
                    },
                    alignLeft: true,
                  ),
                ),
                customTextField(
                  text: 'Enter your Password',
                  controller: passController,
                  inputType: TextInputType.visiblePassword,
                ),
                customTextField(
                  text: 'Confirm Password',
                  controller: confirmPassController,
                  inputType: TextInputType.visiblePassword,
                ),
                Center(
                  child: isUserLogin
                      ? CircularProgressIndicator()
                      : customButton('Sign Up', onPress: () async {
                          try {
                            setState(() {
                              isUserLogin = true;
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

                            Get.snackbar(
                              'storage sms',
                              'Upload image successfully to firebase storage',
                            );

                            await auth
                                .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passController.text,
                            )
                                .then((value) async {
                              await db
                                  .collection('users')
                                  .doc(value.user!.uid)
                                  .set({
                                'name': nameController.text,
                                'email': emailController.text,
                                'country': selectedCountry,
                                'isBlocked': false,
                                'date':
                                    '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                'user_id':
                                    FirebaseAuth.instance.currentUser!.uid,
                                'isRemoved': false,
                                'Role': dropDownValue,
                                'image': imageUrl,
                              }).then((value) {
                                setState(() {
                                  isUserLogin = false;
                                });
                                Get.snackbar(
                                  'SignUp sms',
                                  'User Signed Up successfuly',
                                );
                                Get.to(() => SignIn());
                                return value;
                              });
                              print(selectedCountry);
                              emailController.clear();
                              passController.clear();
                              nameController.clear();
                            });
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              isUserLogin = false;
                            });
                            if (e.code == 'weak-password') {
                              Get.snackbar(
                                'Alert',
                                'Weak Password',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.kBrownColor,
                              );
                            } else if (e.code == 'email-already-in-use') {
                              Get.snackbar(
                                'Alert',
                                'The Email already in use for another account',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.kBrownColor,
                              );
                            }
                          } catch (e) {
                            setState(() {
                              isUserLogin = false;
                            });
                            Get.snackbar(
                              'Error',
                              e.toString(),
                            );
                          }
                        }),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Already have an account?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' Sign In',
                              style: TextStyle(
                                color: AppColors.kBlueColor,
                                fontSize: 10,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('click');
                                  Get.to(
                                    () => SignIn(),
                                  );
                                }),
                        ]),
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
