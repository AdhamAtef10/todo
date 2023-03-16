part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoChangeBottomNavBarState extends TodoState {}

class AppCreateDataBaseState extends TodoState {}
class AppGetDataBaseState extends TodoState {}
class AppGetDataBaseLoadingState extends TodoState {}
class AppInsertDataBaseState extends TodoState {}
class AppUpdateDataBaseState extends TodoState {}
class AppDeleteDataBaseState extends TodoState {}

class AppChangeBottomSheetState extends TodoState {}






