// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:social_app/utils/appColors.dart';
// import 'package:social_app/views/auth/signUp.dart';
// import 'package:social_app/views/bottomNavigation.dart';
// import 'package:social_app/widgets/customBtn.dart';
// import 'package:social_app/widgets/customText.dart';
// import 'package:social_app/widgets/customTextField.dart';
// import 'package:sign_button/sign_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/appColors.dart';
import '../../widgets/customBtn.dart';
import '../../widgets/customText.dart';
import '../../widgets/customTextField.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Center(
                  child: customText('Reset Password',
                      textColor: AppColors.kBlackColor, fontSize: 20.0),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                customTextField(
                  text: 'Enter your Email',
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                ),
                Center(
                  child: customButton(
                    'Send Request',
                    onPress: () async {
                      try {
                        await auth
                            .sendPasswordResetEmail(email: emailController.text)
                            .then((value) {
                          Get.snackbar('Success',
                              'Send request successfully to your email');
                          // Get.to(() => BottomNavigationScreen());
                          return value;
                        });
                      } on FirebaseAuthException catch (e) {
                        Get.snackbar(
                          'Error',
                          e.toString(),
                        );
                      } catch (e) {
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

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) {
      // Get.to(
      //   () => BottomNavigationScreen(),
      // );
      return value;
    });
  }
}
