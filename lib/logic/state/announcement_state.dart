import 'package:equatable/equatable.dart';

import '../../models/announcement_model.dart';

abstract class AnnouncementState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AnnouncementLoading extends AnnouncementState{}

class AnnouncementLoaded extends AnnouncementState{
  final int currentPage;
  final bool hasNextPage;
  final List<AnnouncementModel> announcements;

  AnnouncementLoaded({required this.currentPage, required this.hasNextPage, required this.announcements});

  @override
  // TODO: implement props
  List<Object?> get props => [currentPage];
}

class AnnouncementError extends AnnouncementState{
  final String errorMessage;

  AnnouncementError(this.errorMessage);
}

