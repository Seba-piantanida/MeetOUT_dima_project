import 'package:dima_project/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('signin page ...', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SignInPage(),
    ));
  });
}
