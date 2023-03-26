import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/logic/cubit/announcement_cubit.dart';
import 'package:qamtu/logic/state/announcement_state.dart';
import 'package:qamtu/presentation/screens/detailed_announce_screen.dart';
import 'package:qamtu/presentation/widgets/announcement_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../logic/cubit/user_cubit.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final userCubit = BlocProvider.of<UserCubit>(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => AnnouncementCubit(userCubit: userCubit, languageCode: languageCode)..getAnnouncements(languageCode),
      child: Scaffold(
        appBar: AppBar(
          title: Text(translations.announcements),
        ),
        body: SafeArea(
          child: BlocBuilder<AnnouncementCubit, AnnouncementState>(
            builder: (context, state) {
              if(state is AnnouncementLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if(state is AnnouncementLoaded) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  controller: BlocProvider.of<AnnouncementCubit>(context).controller,
                  itemCount: state.announcements.length,
                  itemBuilder: (context, index) {
                    return AnnouncementCard(title: state.announcements[index].title, subtitle: state.announcements[index].anons, imageURL: state.announcements[index].image, onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedAnnounceScreen(id: state.announcements[index].id)));
                    },);
                  },
                );
              } else if(state is AnnouncementError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.errorMessage),
                      TextButton(onPressed: (){
                        BlocProvider.of<AnnouncementCubit>(context).getAnnouncements(languageCode);
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
