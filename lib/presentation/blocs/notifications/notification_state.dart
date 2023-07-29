import 'package:equatable/equatable.dart';
import 'package:test_flutter/models/products_model.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<Products> notifications;

  const NotificationsLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object> get props => [message];
}
class NotificationEmpty extends NotificationsState {
  final String message;

  const NotificationEmpty(this.message);

  @override
  List<Object> get props => [message];
}
