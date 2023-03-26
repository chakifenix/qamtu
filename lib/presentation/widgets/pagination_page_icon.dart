import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/colors.dart';

class PaginationPageIcon extends StatelessWidget {
  final bool isBack;
  const PaginationPageIcon({Key? key, required this.isBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: customGrey,
          borderRadius: BorderRadius.circular(5.r)
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Icon(isBack ? Icons.arrow_back_ios_sharp : Icons.arrow_forward_ios_sharp, color: customLightBlue,),
    );
  }
}
