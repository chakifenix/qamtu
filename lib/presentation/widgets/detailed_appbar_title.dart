import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailedAppbarTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const DetailedAppbarTitle({Key? key, required this.title, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title, style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400
      ),),
      SizedBox(
        width: 15.w,
        child: FittedBox(
          child: Icon(Icons.arrow_forward, color: Colors.black,),
        ),
      ),
      Expanded(
        child: Text(subtitle, style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400
        ),),
      )
    ],);
  }
}
