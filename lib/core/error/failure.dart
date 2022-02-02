import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String errorMessage;
  final String errorUrl;

  Failure({required this.errorMessage, required this.errorUrl});

  @override
  List<Object> get props => [errorMessage, errorUrl];
}
