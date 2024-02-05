import 'package:dima_project/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('edit profile page ...', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: EditProfilePage(),
    ));
  });
}
