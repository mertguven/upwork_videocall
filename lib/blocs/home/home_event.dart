part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeEventInitial extends HomeEvent {}

class HomeEventComplete extends HomeEvent {}
