import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final int? length;
  final TextInputType? textInputType;
  final TextEditingController? textEditingController;
  const CustomTextField({Key? key, required this.hint, this.length, this.textInputType, this.textEditingController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: TextStyle(
        fontSize: 16.sp,
      ),
      maxLength: length,
      maxLines: 1,
      keyboardType: textInputType ?? TextInputType.visiblePassword,
      cursorColor: Theme.of(context).colorScheme.primary,//if phone number
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none
        ),
        fillColor: customGrey,
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey
        ),
        counterText: '',
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      ),
    );
  }
}
