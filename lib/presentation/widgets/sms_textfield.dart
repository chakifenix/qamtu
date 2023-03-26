import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../colors.dart';

class SmsTextField extends StatelessWidget {
  final void Function(String) onChanged;
  const SmsTextField({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(appContext: context, length: 4,
      onChanged: onChanged,
      animationType: AnimationType.scale,
      keyboardType: TextInputType.number,
      // obscureText: true,
      // obscuringWidget: Container(
      //   width: double.infinity,
      //   height: double.infinity,
      //   alignment: Alignment.center,
      //   decoration: BoxDecoration(
      //     color: customGrey,
      //     borderRadius: BorderRadius.circular(10.r)
      //   ),
      //   child: Text('*', style: TextStyle(
      //       fontSize: 16.sp,
      //       fontWeight: FontWeight.w500,
      //       color: Colors.black54
      //   ),),
      // ),
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          fieldHeight: 45.h,
          fieldWidth: 40.w,
          activeColor: Theme.of(context).colorScheme.primary,
          selectedColor: customLightBlue,
          inactiveColor: Colors.grey,
          disabledColor: Colors.white,
          activeFillColor: Colors.white,
          selectedFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          errorBorderColor: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          borderWidth: 0.7,
      ),
    );
  }
}
