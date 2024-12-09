import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentUserRefProvider extends InheritedWidget {
  final DocumentReference currentUserRef;

  const CurrentUserRefProvider({
    super.key,
    required this.currentUserRef,
    required super.child,
  });

  static CurrentUserRefProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CurrentUserRefProvider>();
  }

  static CurrentUserRefProvider of(BuildContext context) {
    final CurrentUserRefProvider? result = maybeOf(context);
    assert(result != null, 'No CurrentUserProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CurrentUserRefProvider oldWidget) =>
      currentUserRef != oldWidget.currentUserRef;
}
