import 'package:dima_project/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('signup page ...', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SignUpPage(),
    ));
  });
}
