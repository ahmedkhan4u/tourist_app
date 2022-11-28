import 'package:flutter/material.dart';

import '../../utils/appColors.dart';
import '../../widgets/customText.dart';

class RemoveUser extends StatelessWidget {
  const RemoveUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Center(
          child: customText(
            'Sorry You are Removed By Admin',
            textColor: AppColors.kBlackColor,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
