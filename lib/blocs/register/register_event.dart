part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterEventInitial extends RegisterEvent {}

class RegisterEventComplete extends RegisterEvent {}
