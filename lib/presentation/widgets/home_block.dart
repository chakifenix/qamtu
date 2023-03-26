import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/colors.dart';

class HomeBlock extends StatelessWidget {
  final String title;
  final bool isFirst;

  const HomeBlock({Key? key, required this.title, required this.isFirst}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: isFirst ? Colors.white : customGrey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r)
      ),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Text(title, style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: isFirst ? Colors.black : Colors.black54
        ),),
      ),
    );
  }
}
