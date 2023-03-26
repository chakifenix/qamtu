import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/colors.dart';
import 'package:qamtu/logic/cubit/internet_cubit.dart';
import 'package:qamtu/logic/cubit/login_cubit.dart';
import 'package:qamtu/logic/state/login_state.dart';
import 'package:qamtu/presentation/widgets/custom_button.dart';
import 'package:qamtu/presentation/widgets/custom_textfield.dart';
import 'package:qamtu/presentation/widgets/login_option.dart';
import 'package:qamtu/presentation/widgets/sms_textfield.dart';
import '../../logic/cubit/user_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/firebase_service.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController iinController = TextEditingController();

  String smsCode = '';

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userCubit = BlocProvider.of<UserCubit>(context);
    final translations = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final internetCubit = BlocProvider.of<InternetCubit>(context);

    return BlocProvider(
      create: (_) => LoginCubit(userCubit: userCubit),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                children: [
                  SizedBox(
                    height: 132.h,
                  ),

                  SizedBox(
                    width: 200.w,
                    height: 45.h,
                    child: Image.asset('assets/logotype.png', fit: BoxFit.contain,),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 10.h),
                    child: Text(translations.qamtuTitle, style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54
                    ), textAlign: TextAlign.center,),
                  ),

                  SizedBox(
                    height: 70.h,
                  ),

                  Expanded(
                    child: BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if(state is LoginInitial) {
                          if(state.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                          }
                        }

                        if(state is LoginSms) {
                          if(state.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                          }
                        }

                        if(state is LoginSuccess) {
                          userCubit.setUser(state.user);
                        }
                      },
                      builder: (context, state) {
                        if(state is LoginInitial) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 30.w),
                                  decoration: BoxDecoration(
                                    color: customGrey,
                                    borderRadius: BorderRadius.circular(10.r)
                                  ),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: state.isPhone ? 26 : 23,
                                          child: LoginOption(title: translations.phoneNumber, isSelected: state.isPhone, onPress: () {
                                            BlocProvider.of<LoginCubit>(context).toggleLoginMode(true);
                                          },),
                                        ),
                                        Expanded(
                                          flex: state.isPhone ? 23 : 26,
                                          child: LoginOption(title: translations.email, isSelected: !state.isPhone, onPress: () {
                                            BlocProvider.of<LoginCubit>(context).toggleLoginMode(false);
                                          },),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 25.h,
                                ),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(state.isPhone ? translations.phoneNumber : translations.email, style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400
                                  ),),
                                ),

                                SizedBox(
                                  height: 5.h,
                                ),

                                state.isPhone ? IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                            color: customGrey,
                                            borderRadius: BorderRadius.circular(10.r)
                                        ),
                                        child: Text('+7', style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54
                                        ),),
                                      ),

                                      SizedBox(
                                        width: 5.w,
                                      ),

                                      Expanded(
                                        child: CustomTextField(hint: translations.enterPhoneNumber, length: 10, textInputType: TextInputType.phone, textEditingController: phoneController,),
                                      )
                                    ],
                                  ),
                                ) : CustomTextField(hint: translations.enterEmail, length: 50, textInputType: TextInputType.emailAddress, textEditingController: emailController,),

                                SizedBox(
                                  height: 25.h,
                                ),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(translations.iin, style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400
                                  ),),
                                ),

                                SizedBox(
                                  height: 5.h,
                                ),

                                CustomTextField(hint: translations.iin, length: 12, textInputType: TextInputType.number, textEditingController: iinController,),

                                SizedBox(
                                  height: 25.h,
                                ),

                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    title: translations.logIn,
                                    onPressed: () {
                                      if(internetCubit.state) {
                                        if(state.isPhone) {
                                          BlocProvider.of<LoginCubit>(context).sendSmsCode(isPhone: true, firstText: phoneController.value.text, iin: iinController.value.text, language: Localizations.localeOf(context).languageCode);
                                        } else {
                                          BlocProvider.of<LoginCubit>(context).sendSmsCode(isPhone: false, firstText: emailController.value.text, iin: iinController.value.text, language: Localizations.localeOf(context).languageCode);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(translations.noInternet), backgroundColor: customRed,));
                                      }
                                    },
                                  )
                                )
                              ],
                            ),
                          );
                        } else if(state is LoginSms) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(translations.activationCode, style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400
                                    ),),
                                  ),

                                  SizedBox(
                                    height: 5.h,
                                  ),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 180.w,
                                      child: SmsTextField(onChanged: (value) {
                                        smsCode = value;
                                      },),
                                    ),
                                  ),

                                  Visibility(
                                    visible: state.seconds > 0,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(state.seconds > 9 ? '${translations.sendAfter} 00:${state.seconds}' : '${translations.sendAfter} 00:0${state.seconds}', style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54
                                      ),),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 5.h,
                                  ),

                                  Visibility(
                                    visible: state.showSendAgain,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        onPressed: () {
                                          if(internetCubit.state) {
                                            BlocProvider.of<LoginCubit>(context).sendSmsCode(firstText: state.firstText, iin: state.iinText, language: languageCode, isPhone: state.isPhone);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(translations.noInternet), backgroundColor: customRed,));
                                          }
                                        },
                                        child: Text(translations.sendCode, style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context).colorScheme.primary
                                        ),),
                                      )
                                    ),
                                  ),

                                  SizedBox(
                                    height: 30.h,
                                  ),

                                  SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(title: translations.confirm, onPressed: () {
                                      if(internetCubit.state) {
                                        BlocProvider.of<LoginCubit>(context).loginFunc(smsCode, Localizations.localeOf(context).languageCode);
                                        smsCode = '';
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(translations.noInternet), backgroundColor: customRed,));
                                      }
                                    },),
                                  )

                                ],
                              ),
                            );
                          } else {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
