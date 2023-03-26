import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/logic/cubit/detailed_announcement_cubit.dart';
import 'package:qamtu/models/detailed_announcement_model.dart';
import 'package:qamtu/presentation/widgets/detailed_appbar_title.dart';

import '../../logic/cubit/user_cubit.dart';

class DetailedAnnounceScreen extends StatelessWidget {
  final int id;
  const DetailedAnnounceScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = BlocProvider.of<UserCubit>(context);

    final language = Localizations.localeOf(context).languageCode;
    return BlocProvider(
      create: (_) => DetailedAnnouncementCubit(userCubit: userCubit)..getAnnouncement(id, language),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<DetailedAnnouncementCubit, DetailedAnnouncementModel?>(
            builder: (context, state) {
              if(state == null) {
                return Text('Loading..');
              } else {
                return DetailedAppbarTitle(title: 'Анонсы', subtitle: state.title,);
              }
            },
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<DetailedAnnouncementCubit, DetailedAnnouncementModel?>(
            builder: (context, state) {
              if(state == null) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  children: [
                    Text(state.title, style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500
                    ),),

                    SizedBox(
                      height: 20.h,
                    ),

                    Image.network(state.image, fit: BoxFit.fitWidth,),

                    SizedBox(
                      height: 20.h,
                    ),

                    Text(state.anons, style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500
                    )),

                    SizedBox(
                      height: 20.h,
                    ),

                    Text(state.body, style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400
                    )),

                    // SizedBox(
                    //   height: 20.h,
                    // ),
                    //
                    // Text('Автор: Орунбасарова Айдана\nДата публикации: 05.01.2023', style: TextStyle(
                    //     fontSize: 13.sp,
                    //     fontWeight: FontWeight.w400,
                    //     color: Colors.black54
                    // ),)
                  ],
                );
              }
            },
          )
        ),
      ),
    );
  }
}
