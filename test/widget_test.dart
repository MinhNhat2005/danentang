import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_management_firebase/theme/app_theme.dart';

void main() {
  test('light and dark themes use Material 3', () {
    expect(AppTheme.light().useMaterial3, isTrue);
    expect(AppTheme.dark().useMaterial3, isTrue);
    expect(AppTheme.light().brightness, Brightness.light);
    expect(AppTheme.dark().brightness, Brightness.dark);
  });
}
