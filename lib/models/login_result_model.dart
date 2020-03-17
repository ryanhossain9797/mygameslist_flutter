import 'package:flutter/material.dart';

class LogInResult {
  final bool success;
  final String email;
  final String username;
  final String message;
  final String token;

  LogInResult(
      {@required this.message,
      @required this.success,
      this.username,
      this.email,
      this.token});
}
