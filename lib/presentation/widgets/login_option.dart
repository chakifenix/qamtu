import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors.dart';

class LoginOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function()? onPress;

  const LoginOption({Key? key, required this.title, required this.isSelected, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isSelected ? customLightBlue : null,
            borderRadius: isSelected ? BorderRadius.circular(10.r) : null
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
        child: Text(title, style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400
        )),
      ),
    );
  }
}
