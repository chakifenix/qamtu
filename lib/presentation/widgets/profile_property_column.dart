import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePropertyColumn extends StatelessWidget {
  final String title;
  final String value;
  const ProfilePropertyColumn({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black54
          ),),
          Text(value, style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black
          ),),
        ],
      ),
    );
  }
}
