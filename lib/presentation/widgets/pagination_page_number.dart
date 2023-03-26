import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors.dart';

class PaginationPageNumber extends StatelessWidget {
  final int number;
  final bool isSelected;
  const PaginationPageNumber({Key? key, required this.number, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: customGrey,
          borderRadius: BorderRadius.circular(5.r)
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      child: Text(number.toString(), style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black54
      ),),
    );
  }
}
