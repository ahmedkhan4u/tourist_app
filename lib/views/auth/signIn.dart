// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:tourist_app/views/auth/reset_pass.dart';
import 'package:tourist_app/views/auth/signUp.dart';
import 'package:tourist_app/views/bottomnavigation.dart';

import '../../utils/appColors.dart';
import '../../widgets/customBtn.dart';
import '../../widgets/customText.dart';
import '../../widgets/customTextField.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool isUserLogin = false;

  String role = '';
  final db = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
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
            height: Get.height,
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Center(
                  child: customText('Sign In',
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
                SizedBox(
                  height: Get.height * 0.02,
                ),
                customTextField(
                  text: 'Enter your Password',
                  controller: passController,
                  inputType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => ResetPassword(),
                    );
                  },
                  child: customText(
                    'Forgot Password?',
                    textColor: AppColors.kRedColor,
                    fontSize: 10.0,
                    align: TextAlign.right,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Center(
                  child: isUserLogin
                      ? CircularProgressIndicator()
                      : customButton(
                          'Sign In',
                          onPress: () async {
                            setState(() {
                              isUserLogin = true;
                            });
                            try {
                              await auth.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passController.text,
                              );

                              final res = await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get();

                              if (res.exists && res.data()!.length > 0) {
                                if (res.data()!["Role"] == "Vendor") {
                                  Get.to(() =>
                                      BottomNavigationScreen(data: res.data()));
                                  print("Vendor");
                                  setState(() {});
                                } else {
                                  Get.to(() => BottomNavigationForTourist(
                                        data: res.data(),
                                      ));
                                  print("Tourist");
                                  setState(() {});
                                }
                              }
                              Get.snackbar(
                                  'SignIn', 'User Singed In Successfully');
                            } on FirebaseAuthException catch (e) {
                              Get.snackbar(
                                'Error',
                                e.toString(),
                              );
                            } catch (e) {
                              setState(() {
                                isUserLogin = false;
                              });
                              Get.snackbar('Error', e.toString());
                            }
                          },
                        ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                // Center(
                //   child: SignInButton(
                //     buttonType: ButtonType.google,
                //     onPressed: () {
                //       signInWithGoogle();
                //     },
                //   ),
                // ),
                SizedBox(height: Get.height * 0.02),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' Sign up',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 12,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('click');
                                  Get.to(
                                    () => SignUp(),
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

  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   return await FirebaseAuth.instance
  //       .signInWithCredential(credential)
  //       .then((value) {
  //     Get.to(
  //       () => BottomNavigationScreen(),
  //     );
  //     return value;
  //   });
  // }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print('Your id token is ${googleAuth?.idToken}');

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      // Get.off(
      //   () => HomePage(),
      // );
    });
  }
}
