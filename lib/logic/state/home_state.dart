import '../../models/history_model.dart';

abstract class HomeState {}

class HomeLoading extends HomeState{}

class HomeLoaded extends HomeState{
  final int rating;
  final int category_rating;
  final String category_name;
  final String full_name;
  final List<HistoryModel> history;
  final List<QueueModel> queueList;

  HomeLoaded({required this.rating, required this.category_rating, required this.category_name, required this.full_name, required this.history, required this.queueList});
}

class HomeError extends HomeState{}