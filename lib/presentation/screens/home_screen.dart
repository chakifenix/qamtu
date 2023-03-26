import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/colors.dart';
import 'package:qamtu/logic/state/home_state.dart';
import 'package:qamtu/presentation/widgets/home_status_card.dart';
import '../../logic/cubit/home_cubit.dart';
import '../../logic/cubit/user_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final translations = AppLocalizations.of(context)!;
    final userCubit = BlocProvider.of<UserCubit>(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => HomeCubit(userCubit: userCubit)..getStatus(languageCode),
      child: Scaffold(
        appBar: AppBar(
          title: Text(translations.home),
        ),
        body: SafeArea(
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {

            },
            builder: (context, state) {
              if(state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if(state is HomeLoaded) {
                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w ,vertical: 20.h),
                  children: [
                    HomeStatusCard(raiting: state.rating, full_name: state.full_name,),

                    SizedBox(
                      height: state.history.isEmpty && state.queueList.isEmpty ? 100.h : 20.h,
                    ),

                    state.history.isEmpty && state.queueList.isEmpty ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(translations.resumeNotPublished, textAlign: TextAlign.center, style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500
                      ),),
                    ) : Column(
                      children: [

                        Visibility(
                            visible: state.queueList.isNotEmpty,
                            child: SizedBox(
                              height: 10.h,
                            )
                        ),

                        Visibility(
                          visible: state.queueList.isNotEmpty,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(languageCode == 'kk' ? '"${state.category_name}" ${translations.categoryRaiting} - ${state.category_rating}' : '${state.category_rating} ${translations.categoryRaiting} "${state.category_name}"', style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: primaryBlue
                            ),),
                          )
                        ),

                        Visibility(
                          visible: state.queueList.isNotEmpty,
                          child: SizedBox(
                            height: 15.h,
                          )
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: state.queueList.map((eachHuman) {
                            return Card(
                              elevation: 2,
                              color: eachHuman.full_name == state.full_name ? Colors.white : customGrey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)
                              ),
                              margin: EdgeInsets.only(bottom: 10.h),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                                child: Text('${eachHuman.raiting}) ${eachHuman.full_name}', style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            );
                          } ).toList(),
                        ),

                        Visibility(
                          visible: state.history.isNotEmpty,
                          child: SizedBox(
                            height: 20.h,
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: state.history.map((history)  {
                            return Card(
                              elevation: 2,
                              color: state.history.last == history ? Colors.white : customGrey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)
                              ),
                              margin: EdgeInsets.only(bottom: 10.h),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(history.statusModel.name, style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600
                                      ),),
                                      SizedBox(
                                        height: 20.h,
                                      ),

                                      Text(translations.companyName, style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400
                                      ),),
                                      Text(history.companyModel.name, style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500
                                      ),),

                                      SizedBox(
                                        height: 5.h,
                                      ),

                                      Text('${translations.companyAddress}:', style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400
                                      ),),
                                      Text(history.companyModel.full_address, style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500
                                      ),),

                                      SizedBox(
                                        height: 5.h,
                                      ),

                                      Text('${translations.setInterview}:', style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400
                                      ),),
                                      Text('${history.rangingModel.interview_date} ${history.rangingModel.interview_time}', style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500
                                      ),),

                                      SizedBox(
                                        height: 5.h,
                                      ),

                                      Text('${translations.comments}:', style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400
                                      ),),
                                      Text(history.rangingModel.interview_comment, style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500
                                      ),),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(history.rangingModel.order_date, style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.black54
                                        ),),
                                      )

                                      // Text(history.rangingModel.interview_comment),
                                      //


                                    ],
                                  )
                              ),
                            );
                            // return HomeBlock(title: history.statusModel.name, isFirst: history == state.history.first);
                          }).toList(),
                        )
                      ],
                    )
                  ],
                );
              } else if(state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(translations.unknownError),
                      TextButton(onPressed: (){
                        BlocProvider.of<HomeCubit>(context).getStatus(languageCode);
                      }, child: Text(translations.tryAgain))
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text(translations.unknownError),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
