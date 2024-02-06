
import 'package:http/http.dart';


abstract class MemoState {}

class MemoInitial extends MemoState {}

class MemoLoading extends MemoState {}

class MemoLoaded extends MemoState {

  final Response data;

  MemoLoaded(this.data);
}

class MemoError extends MemoState {}