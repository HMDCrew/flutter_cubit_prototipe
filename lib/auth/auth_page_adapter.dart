import 'package:flutter/material.dart';

class AuthPageAdapter {
  final Widget Function(String token) onUserAuthenticated;

  AuthPageAdapter({required this.onUserAuthenticated});

  void onAuthSuccess(BuildContext context, String token) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) {
          return onUserAuthenticated(token);
        },
      ),
      (Route<dynamic> route) => false,
    );
  }
}
